#!/bin/bash
################################################################################
# 파일명   : check_unix_vulnerabilities.sh
# 목적     : Unix 서버 취약점 점검 (U-01 ~ U-67) - 점검만 수행
# 주의     : 이 스크립트는 시스템을 변경하지 않습니다. (Read-Only)
# 사용법   : sudo ./check_unix_vulnerabilities.sh [출력파일경로]
# 예시     : sudo ./check_unix_vulnerabilities.sh /tmp/unix_check_$(date +%Y%m%d).log
################################################################################

set -u

# ==================== 설정 ====================
OUTPUT_FILE="${1:-/tmp/unix_vuln_check_$(date +%Y%m%d_%H%M%S).log}"
HOSTNAME=$(hostname)
CHECK_DATE=$(date '+%Y-%m-%d %H:%M:%S')
OS_TYPE="unknown"

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 결과 카운터
TOTAL_CHECKS=0
VULN_COUNT=0
SAFE_COUNT=0

# ==================== 함수 정의 ====================
log() {
    echo -e "$1" | tee -a "$OUTPUT_FILE"
}

print_header() {
    log ""
    log "======================================================================"
    log " $1"
    log "======================================================================"
}

check_result() {
    local code="$1"
    local item="$2"
    local status="$3"    # SAFE, VULN, INFO
    local detail="$4"
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    case "$status" in
        SAFE)
            SAFE_COUNT=$((SAFE_COUNT + 1))
            log "[${GREEN}양호${NC}] ${code} - ${item}"
            ;;
        VULN)
            VULN_COUNT=$((VULN_COUNT + 1))
            log "[${RED}취약${NC}] ${code} - ${item}"
            ;;
        INFO)
            log "[${BLUE}정보${NC}] ${code} - ${item}"
            ;;
    esac
    [ -n "$detail" ] && log "       └─ $detail"
}

detect_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_TYPE="$ID"
    elif [ -f /etc/redhat-release ]; then
        OS_TYPE="redhat"
    elif [ -f /etc/debian_version ]; then
        OS_TYPE="debian"
    elif [ -f /etc/SuSE-release ]; then
        OS_TYPE="suse"
    fi
    log "[*] 감지된 OS: $OS_TYPE"
}

# ==================== 시작 ====================
log "######################################################################"
log "#  Unix 서버 취약점 점검 스크립트 (U-01 ~ U-67)                       #"
log "#  호스트명 : $HOSTNAME"
log "#  점검일시 : $CHECK_DATE"
log "#  OS 정보  : $(uname -a)"
log "#  출력파일 : $OUTPUT_FILE"
log "######################################################################"

detect_os

################################################################################
# 1. 계정 관리 (U-01 ~ U-13)
################################################################################
print_header "1. 계정 관리 (U-01 ~ U-13)"

# U-01: root 계정 원격 접속 제한
check_u01() {
    local detail=""
    # SSH 확인
    if [ -f /etc/ssh/sshd_config ]; then
        local permit_root=$(grep -i "^PermitRootLogin" /etc/ssh/sshd_config | awk '{print $2}' | tail -1)
        if [ "$permit_root" = "no" ]; then
            detail="SSH PermitRootLogin: no"
            return 0
        fi
    fi
    # Telnet (securetty)
    if [ -f /etc/securetty ]; then
        if grep -qE "^pts/" /etc/securetty; then
            detail="Telnet에서 pts/ 접속 허용됨"
            return 1
        fi
    fi
    detail="SSH PermitRootLogin: ${permit_root:-미설정} (기본값 yes)"
    return 1
}

if check_u01; then
    check_result "U-01" "root 계정 원격 접속 제한" "SAFE" "$detail"
else
    check_result "U-01" "root 계정 원격 접속 제한" "VULN" "$detail"
fi

# U-02: 비밀번호 관리정책 설정
check_u02() {
    local detail=""
    if [ -f /etc/login.defs ]; then
        local max_days=$(grep -E "^PASS_MAX_DAYS" /etc/login.defs | awk '{print $2}')
        local min_days=$(grep -E "^PASS_MIN_DAYS" /etc/login.defs | awk '{print $2}')
        local min_len=$(grep -E "^PASS_MIN_LEN" /etc/login.defs | awk '{print $2}')
        detail="PASS_MAX_DAYS=$max_days, PASS_MIN_DAYS=$min_days, PASS_MIN_LEN=${min_len:-미설정}"
        if [ -n "$max_days" ] && [ "$max_days" -le 90 ] && [ -n "$min_days" ] && [ "$min_days" -ge 1 ]; then
            return 0
        fi
    else
        detail="/etc/login.defs 파일 없음"
    fi
    return 1
}

if check_u02; then
    check_result "U-02" "비밀번호 관리정책 설정" "SAFE" "$detail"
else
    check_result "U-02" "비밀번호 관리정책 설정" "VULN" "$detail"
fi

# U-03: 계정 잠금 임계값 설정
check_u03() {
    local detail=""
    # PAM 모듈 확인
    for pam_file in /etc/pam.d/system-auth /etc/pam.d/common-auth /etc/pam.d/password-auth; do
        if [ -f "$pam_file" ]; then
            if grep -qE "pam_tally2|pam_faillock|pam_tally" "$pam_file"; then
                local deny=$(grep -oE "deny=[0-9]+" "$pam_file" | head -1)
                detail="$pam_file 에 $deny 설정됨"
                if [ -n "$deny" ]; then
                    local deny_val=${deny#deny=}
                    [ "$deny_val" -le 10 ] && return 0
                fi
            fi
        fi
    done
    detail="계정 잠금 임계값 미설정"
    return 1
}

if check_u03; then
    check_result "U-03" "계정 잠금 임계값 설정" "SAFE" "$detail"
else
    check_result "U-03" "계정 잠금 임계값 설정" "VULN" "$detail"
fi

# U-04: 비밀번호 파일 보호
check_u04() {
    local detail=""
    if [ -f /etc/shadow ]; then
        detail="/etc/shadow 파일 존재 (Shadow Password 사용 중)"
        return 0
    fi
    detail="/etc/shadow 파일 없음"
    return 1
}

if check_u04; then
    check_result "U-04" "비밀번호 파일 보호" "SAFE" "$detail"
else
    check_result "U-04" "비밀번호 파일 보호" "VULN" "$detail"
fi

# U-05: root 이외의 UID가 '0' 금지
check_u05() {
    local result=$(awk -F: '($3 == 0) {print $1}' /etc/passwd | grep -v "^root$")
    if [ -z "$result" ]; then
        return 0
    fi
    detail="UID 0 계정: $(echo $result | tr '\n' ' ')"
    return 1
}

if check_u05; then
    check_result "U-05" "root 이외의 UID가 '0' 금지" "SAFE"
else
    check_result "U-05" "root 이외의 UID가 '0' 금지" "VULN" "$detail"
fi

# U-06: 사용자 계정 su 기능 제한
check_u06() {
    local detail=""
    if [ -f /etc/pam.d/su ]; then
        if grep -qE "pam_wheel" /etc/pam.d/su; then
            detail="pam_wheel.so 설정됨"
            return 0
        fi
    fi
    # wheel 그룹 권한 확인
    if [ -f /usr/bin/su ]; then
        local su_perm=$(stat -c "%a" /usr/bin/su)
        detail="/usr/bin/su 권한: $su_perm"
        [ "$su_perm" = "4750" ] && return 0
    fi
    return 1
}

if check_u06; then
    check_result "U-06" "사용자 계정 su 기능 제한" "SAFE" "$detail"
else
    check_result "U-06" "사용자 계정 su 기능 제한" "VULN" "$detail"
fi

# U-07: 불필요한 계정 제거
check_u07() {
    local unnecessary=""
    for user in lp uucp nuucp games gopher; do
        if grep -q "^${user}:" /etc/passwd 2>/dev/null; then
            unnecessary="$unnecessary $user"
        fi
    done
    if [ -z "$unnecessary" ]; then
        return 0
    fi
    detail="불필요 계정 존재:$unnecessary (수동 검토 필요)"
    return 1
}

if check_u07; then
    check_result "U-07" "불필요한 계정 제거" "SAFE"
else
    check_result "U-07" "불필요한 계정 제거" "VULN" "$detail"
fi

# U-08: 관리자 그룹에 최소한의 계정 포함
check_u08() {
    local root_group=$(grep "^root:" /etc/group | cut -d: -f4)
    local count=$(echo "$root_group" | tr ',' '\n' | grep -c .)
    detail="root 그룹 구성원: ${root_group:-없음} (총 ${count}명)"
    [ "$count" -le 1 ] && return 0
    return 1
}

if check_u08; then
    check_result "U-08" "관리자 그룹에 최소한의 계정 포함" "SAFE" "$detail"
else
    check_result "U-08" "관리자 그룹에 최소한의 계정 포함" "VULN" "$detail"
fi

# U-09: 계정이 존재하지 않는 GID 금지
check_u09() {
    local orphan_groups=""
    while IFS=: read -r gname x gid members; do
        # 시스템 그룹 제외 (GID 1000 미만)
        [ "$gid" -lt 1000 ] && continue
        if [ -z "$members" ]; then
            orphan_groups="$orphan_groups $gname(GID=$gid)"
        fi
    done < /etc/group
    if [ -z "$orphan_groups" ]; then
        return 0
    fi
    detail="구성원 없는 그룹:$orphan_groups"
    return 1
}

if check_u09; then
    check_result "U-09" "계정이 존재하지 않는 GID 금지" "SAFE"
else
    check_result "U-09" "계정이 존재하지 않는 GID 금지" "INFO" "$detail (수동 검토 권장)"
fi

# U-10: 동일한 UID 금지
check_u10() {
    local dup_uid=$(awk -F: '{print $3}' /etc/passwd | sort | uniq -d)
    if [ -z "$dup_uid" ]; then
        return 0
    fi
    detail="중복 UID: $(echo $dup_uid | tr '\n' ' ')"
    return 1
}

if check_u10; then
    check_result "U-10" "동일한 UID 금지" "SAFE"
else
    check_result "U-10" "동일한 UID 금지" "VULN" "$detail"
fi

# U-11: 사용자 Shell 점검
check_u11() {
    local vulnerable=""
    for user in daemon bin sys adm listen nobody nobody4 noaccess diag operator games gopher; do
        local shell=$(grep "^${user}:" /etc/passwd 2>/dev/null | awk -F: '{print $7}')
        if [ -n "$shell" ] && [[ "$shell" != "/bin/false" ]] && [[ "$shell" != "/sbin/nologin" ]] && [[ "$shell" != "/usr/sbin/nologin" ]]; then
            vulnerable="$vulnerable ${user}(${shell})"
        fi
    done
    if [ -z "$vulnerable" ]; then
        return 0
    fi
    detail="Shell 부여된 불필요 계정:$vulnerable"
    return 1
}

if check_u11; then
    check_result "U-11" "사용자 Shell 점검" "SAFE"
else
    check_result "U-11" "사용자 Shell 점검" "VULN" "$detail"
fi

# U-12: 세션 종료 시간 설정
check_u12() {
    local detail=""
    local tmout=$(grep -E "^TMOUT|export TMOUT" /etc/profile 2>/dev/null | grep -oE "TMOUT=[0-9]+" | head -1)
    if [ -n "$tmout" ]; then
        local tmout_val=${tmout#TMOUT=}
        detail="/etc/profile TMOUT=$tmout_val"
        [ "$tmout_val" -le 600 ] && return 0
    fi
    detail="TMOUT 미설정 또는 600초 초과"
    return 1
}

if check_u12; then
    check_result "U-12" "세션 종료 시간 설정" "SAFE" "$detail"
else
    check_result "U-12" "세션 종료 시간 설정" "VULN" "$detail"
fi

# U-13: 안전한 비밀번호 암호화 알고리즘 사용
check_u13() {
    local detail=""
    if [ -f /etc/login.defs ]; then
        local enc=$(grep -E "^ENCRYPT_METHOD" /etc/login.defs | awk '{print $2}')
        detail="ENCRYPT_METHOD=${enc:-미설정}"
        case "$enc" in
            SHA256|SHA512|YESCRYPT) return 0 ;;
        esac
    fi
    # /etc/shadow 필드 확인
    if [ -f /etc/shadow ]; then
        local algo=$(awk -F: '$2 ~ /^\$/ {print substr($2, 2, 1); exit}' /etc/shadow)
        case "$algo" in
            5|6) 
                detail="Shadow 해시 알고리즘: \$${algo} (SHA-256/512)"
                return 0 
                ;;
        esac
    fi
    return 1
}

if check_u13; then
    check_result "U-13" "안전한 비밀번호 암호화 알고리즘 사용" "SAFE" "$detail"
else
    check_result "U-13" "안전한 비밀번호 암호화 알고리즘 사용" "VULN" "$detail"
fi

################################################################################
# 2. 파일 및 디렉터리 관리 (U-14 ~ U-33)
################################################################################
print_header "2. 파일 및 디렉터리 관리 (U-14 ~ U-33)"

# U-14: root 홈, 패스 디렉터리 권한 및 패스 설정
check_u14() {
    local path=$(echo $PATH)
    if echo "$PATH" | grep -qE "(^|:)\.(:|$)"; then
        detail="PATH에 '.' 포함됨: $PATH"
        return 1
    fi
    detail="PATH 정상"
    return 0
}

if check_u14; then
    check_result "U-14" "root 홈, 패스 디렉터리 권한 및 패스 설정" "SAFE" "$detail"
else
    check_result "U-14" "root 홈, 패스 디렉터리 권한 및 패스 설정" "VULN" "$detail"
fi

# U-15: 파일 및 디렉터리 소유자 설정
check_u15() {
    local result=$(find / -nouser -o -nogroup 2>/dev/null | head -5)
    if [ -z "$result" ]; then
        return 0
    fi
    detail="소유자 없는 파일 발견: $(echo "$result" | tr '\n' ' ')"
    return 1
}

if check_u15; then
    check_result "U-15" "파일 및 디렉터리 소유자 설정" "SAFE"
else
    check_result "U-15" "파일 및 디렉터리 소유자 설정" "VULN" "$detail"
fi

# U-16: /etc/passwd 파일 소유자 및 권한 설정
check_u16() {
    local perm=$(stat -c "%a" /etc/passwd)
    local owner=$(stat -c "%U" /etc/passwd)
    detail="소유자=$owner, 권한=$perm"
    [ "$owner" = "root" ] && [ "$perm" -le 644 ] && return 0
    return 1
}

if check_u16; then
    check_result "U-16" "/etc/passwd 파일 소유자 및 권한 설정" "SAFE" "$detail"
else
    check_result "U-16" "/etc/passwd 파일 소유자 및 권한 설정" "VULN" "$detail"
fi

# U-17: 시스템 시작 스크립트 권한 설정
check_u17() {
    local vuln_files=""
    for file in /etc/rc.d/rc*.d/* /etc/rc*.d/*; do
        [ -f "$file" ] || continue
        local perm=$(stat -c "%a" "$file")
        local owner=$(stat -c "%U" "$file")
        if [ "$owner" != "root" ] || [ "${perm: -1}" -gt 4 ]; then
            vuln_files="$vuln_files $file"
        fi
    done
    if [ -z "$vuln_files" ]; then
        return 0
    fi
    detail="권한 취약 스크립트:$vuln_files"
    return 1
}

if check_u17; then
    check_result "U-17" "시스템 시작 스크립트 권한 설정" "SAFE"
else
    check_result "U-17" "시스템 시작 스크립트 권한 설정" "VULN" "$detail"
fi

# U-18: /etc/shadow 파일 소유자 및 권한 설정
check_u18() {
    if [ ! -f /etc/shadow ]; then
        check_result "U-18" "/etc/shadow 파일 소유자 및 권한 설정" "INFO" "/etc/shadow 없음"
        return
    fi
    local perm=$(stat -c "%a" /etc/shadow)
    local owner=$(stat -c "%U" /etc/shadow)
    detail="소유자=$owner, 권한=$perm"
    if [ "$owner" = "root" ] && [ "$perm" -le 400 ]; then
        check_result "U-18" "/etc/shadow 파일 소유자 및 권한 설정" "SAFE" "$detail"
    else
        check_result "U-18" "/etc/shadow 파일 소유자 및 권한 설정" "VULN" "$detail"
    fi
}

check_u18

# U-19: /etc/hosts 파일 소유자 및 권한 설정
check_u19() {
    if [ ! -f /etc/hosts ]; then return 0; fi
    local perm=$(stat -c "%a" /etc/hosts)
    local owner=$(stat -c "%U" /etc/hosts)
    detail="소유자=$owner, 권한=$perm"
    [ "$owner" = "root" ] && [ "$perm" -le 644 ] && return 0
    return 1
}

if check_u19; then
    check_result "U-19" "/etc/hosts 파일 소유자 및 권한 설정" "SAFE" "$detail"
else
    check_result "U-19" "/etc/hosts 파일 소유자 및 권한 설정" "VULN" "$detail"
fi

# U-20: /etc/(x)inetd.conf 파일 소유자 및 권한 설정
check_u20() {
    local file=""
    [ -f /etc/inetd.conf ] && file="/etc/inetd.conf"
    [ -f /etc/xinetd.conf ] && file="/etc/xinetd.conf"
    if [ -z "$file" ]; then
        check_result "U-20" "/etc/(x)inetd.conf 파일 소유자 및 권한 설정" "INFO" "inetd 미사용"
        return
    fi
    local perm=$(stat -c "%a" "$file")
    local owner=$(stat -c "%U" "$file")
    detail="$file 소유자=$owner, 권한=$perm"
    if [ "$owner" = "root" ] && [ "$perm" -le 600 ]; then
        check_result "U-20" "/etc/(x)inetd.conf 파일 소유자 및 권한 설정" "SAFE" "$detail"
    else
        check_result "U-20" "/etc/(x)inetd.conf 파일 소유자 및 권한 설정" "VULN" "$detail"
    fi
}

check_u20

# U-21: /etc/(r)syslog.conf 파일 소유자 및 권한 설정
check_u21() {
    local file=""
    [ -f /etc/rsyslog.conf ] && file="/etc/rsyslog.conf"
    [ -f /etc/syslog.conf ] && file="/etc/syslog.conf"
    if [ -z "$file" ]; then
        check_result "U-21" "/etc/(r)syslog.conf 파일 소유자 및 권한 설정" "INFO" "syslog 미사용"
        return
    fi
    local perm=$(stat -c "%a" "$file")
    local owner=$(stat -c "%U" "$file")
    detail="$file 소유자=$owner, 권한=$perm"
    if [ "$owner" = "root" ] && [ "$perm" -le 640 ]; then
        check_result "U-21" "/etc/(r)syslog.conf 파일 소유자 및 권한 설정" "SAFE" "$detail"
    else
        check_result "U-21" "/etc/(r)syslog.conf 파일 소유자 및 권한 설정" "VULN" "$detail"
    fi
}

check_u21

# U-22: /etc/services 파일 소유자 및 권한 설정
check_u22() {
    if [ ! -f /etc/services ]; then return 0; fi
    local perm=$(stat -c "%a" /etc/services)
    local owner=$(stat -c "%U" /etc/services)
    detail="소유자=$owner, 권한=$perm"
    [ "$owner" = "root" ] && [ "$perm" -le 644 ] && return 0
    return 1
}

if check_u22; then
    check_result "U-22" "/etc/services 파일 소유자 및 권한 설정" "SAFE" "$detail"
else
    check_result "U-22" "/etc/services 파일 소유자 및 권한 설정" "VULN" "$detail"
fi

# U-23: SUID, SGID, Sticky bit 설정 파일 점검
check_u23() {
    local count=$(find / -perm -4000 -type f 2>/dev/null | wc -l)
    local sgid_count=$(find / -perm -2000 -type f 2>/dev/null | wc -l)
    detail="SUID 파일: ${count}개, SGID 파일: ${sgid_count}개 (수동 검토 권장)"
    check_result "U-23" "SUID, SGID, Sticky bit 설정 파일 점검" "INFO" "$detail"
}

check_u23

# U-24: 사용자, 시스템 환경변수 파일 소유자 및 권한 설정
check_u24() {
    local vuln=""
    for home in $(awk -F: '$3 >= 1000 && $3 < 65000 {print $6}' /etc/passwd); do
        for file in .profile .bashrc .bash_profile .cshrc .kshrc; do
            [ -f "$home/$file" ] || continue
            local perm=$(stat -c "%a" "$home/$file")
            if [ "${perm: -1}" -gt 4 ] 2>/dev/null; then
                vuln="$vuln $home/$file"
            fi
        done
    done
    if [ -z "$vuln" ]; then return 0; fi
    detail="기타 사용자 쓰기 권한 존재:$vuln"
    return 1
}

if check_u24; then
    check_result "U-24" "사용자, 시스템 환경변수 파일 소유자 및 권한 설정" "SAFE"
else
    check_result "U-24" "사용자, 시스템 환경변수 파일 소유자 및 권한 설정" "VULN" "$detail"
fi

# U-25: world writable 파일 점검
check_u25() {
    local count=$(find / -type f -perm -2 -not -path "/proc/*" -not -path "/sys/*" 2>/dev/null | wc -l)
    detail="world writable 파일 ${count}개 (수동 검토 필요)"
    check_result "U-25" "world writable 파일 점검" "INFO" "$detail"
}

check_u25

# U-26: /dev에 존재하지 않는 device 파일 점검
check_u26() {
    local count=$(find /dev -type f 2>/dev/null | wc -l)
    detail="/dev 일반 파일 ${count}개 (수동 검토 필요)"
    check_result "U-26" "/dev에 존재하지 않는 device 파일 점검" "INFO" "$detail"
}

check_u26

# U-27: $HOME/.rhosts, hosts.equiv 사용 금지
check_u27() {
    local found=""
    [ -f /etc/hosts.equiv ] && found="$found /etc/hosts.equiv"
    while IFS=: read -r user x uid gid info home shell; do
        [ -f "$home/.rhosts" ] && found="$found $home/.rhosts"
    done < /etc/passwd
    if [ -z "$found" ]; then return 0; fi
    detail="r-command 신뢰 파일 존재:$found"
    return 1
}

if check_u27; then
    check_result "U-27" "\$HOME/.rhosts, hosts.equiv 사용 금지" "SAFE"
else
    check_result "U-27" "\$HOME/.rhosts, hosts.equiv 사용 금지" "VULN" "$detail"
fi

# U-28: 접속 IP 및 포트 제한
check_u28() {
    local detail=""
    # TCP Wrapper
    if [ -s /etc/hosts.deny ] && [ -s /etc/hosts.allow ]; then
        detail="TCP Wrapper 설정됨"
        return 0
    fi
    # iptables
    if command -v iptables &>/dev/null; then
        local rules=$(iptables -L -n 2>/dev/null | wc -l)
        if [ "$rules" -gt 8 ]; then
            detail="iptables 규칙 ${rules}개"
            return 0
        fi
    fi
    # firewalld
    if command -v firewall-cmd &>/dev/null && systemctl is-active firewalld &>/dev/null; then
        detail="firewalld 활성화됨"
        return 0
    fi
    detail="방화벽 설정 미흡"
    return 1
}

if check_u28; then
    check_result "U-28" "접속 IP 및 포트 제한" "SAFE" "$detail"
else
    check_result "U-28" "접속 IP 및 포트 제한" "VULN" "$detail"
fi

# U-29: hosts.lpd 파일 소유자 및 권한 설정
check_u29() {
    if [ ! -f /etc/hosts.lpd ]; then return 0; fi
    local perm=$(stat -c "%a" /etc/hosts.lpd)
    local owner=$(stat -c "%U" /etc/hosts.lpd)
    detail="소유자=$owner, 권한=$perm"
    [ "$owner" = "root" ] && [ "$perm" -le 600 ] && return 0
    return 1
}

if check_u29; then
    check_result "U-29" "hosts.lpd 파일 소유자 및 권한 설정" "SAFE" "$detail"
else
    check_result "U-29" "hosts.lpd 파일 소유자 및 권한 설정" "VULN" "$detail"
fi

# U-30: UMASK 설정 관리
check_u30() {
    local umask_val=$(grep -E "^[[:space:]]*umask" /etc/profile 2>/dev/null | tail -1 | awk '{print $2}')
    detail="umask=${umask_val:-미설정}"
    if [ -n "$umask_val" ] && [ "$umask_val" -ge 22 ] 2>/dev/null; then
        return 0
    fi
    return 1
}

if check_u30; then
    check_result "U-30" "UMASK 설정 관리" "SAFE" "$detail"
else
    check_result "U-30" "UMASK 설정 관리" "VULN" "$detail"
fi

# U-31: 홈 디렉토리 소유자 및 권한 설정
check_u31() {
    local vuln=""
    while IFS=: read -r user x uid gid info home shell; do
        [ -d "$home" ] || continue
        [ "$uid" -lt 1000 ] && [ "$uid" -ne 0 ] && continue
        local owner=$(stat -c "%U" "$home")
        local perm=$(stat -c "%a" "$home")
        if [ "$owner" != "$user" ] || [ "${perm: -1}" -gt 4 ] 2>/dev/null; then
            vuln="$vuln $home(owner=$owner,perm=$perm)"
        fi
    done < /etc/passwd
    if [ -z "$vuln" ]; then return 0; fi
    detail="취약 홈 디렉토리:$vuln"
    return 1
}

if check_u31; then
    check_result "U-31" "홈 디렉토리 소유자 및 권한 설정" "SAFE"
else
    check_result "U-31" "홈 디렉토리 소유자 및 권한 설정" "VULN" "$detail"
fi

# U-32: 홈 디렉토리로 지정한 디렉토리의 존재 관리
check_u32() {
    local vuln=""
    while IFS=: read -r user x uid gid info home shell; do
        [ -z "$home" ] && continue
        if [ ! -d "$home" ]; then
            vuln="$vuln $user($home)"
        fi
    done < /etc/passwd
    if [ -z "$vuln" ]; then return 0; fi
    detail="존재하지 않는 홈 디렉토리:$vuln"
    return 1
}

if check_u32; then
    check_result "U-32" "홈 디렉토리로 지정한 디렉토리의 존재 관리" "SAFE"
else
    check_result "U-32" "홈 디렉토리로 지정한 디렉토리의 존재 관리" "VULN" "$detail"
fi

# U-33: 숨겨진 파일 및 디렉토리 검색 및 제거
check_u33() {
    local count=$(find /tmp /var/tmp -name ".*" -type f 2>/dev/null | wc -l)
    detail="/tmp, /var/tmp 내 숨김 파일 ${count}개 (수동 검토 필요)"
    check_result "U-33" "숨겨진 파일 및 디렉토리 검색 및 제거" "INFO" "$detail"
}

check_u33

################################################################################
# 3. 서비스 관리 (U-34 ~ U-63) - 주요 항목만
################################################################################
print_header "3. 서비스 관리 (U-34 ~ U-63)"

# U-34: Finger 서비스 비활성화
check_u34() {
    if systemctl is-active finger &>/dev/null || \
       netstat -tlnp 2>/dev/null | grep -q ":79 " || \
       [ -f /etc/xinetd.d/finger ] && grep -q "disable.*=.*no" /etc/xinetd.d/finger 2>/dev/null; then
        detail="Finger 서비스 활성화됨"
        return 1
    fi
    return 0
}

if check_u34; then
    check_result "U-34" "Finger 서비스 비활성화" "SAFE"
else
    check_result "U-34" "Finger 서비스 비활성화" "VULN" "$detail"
fi

# U-36: r 계열 서비스 비활성화
check_u36() {
    local detail=""
    if [ -f /etc/xinetd.d/rlogin ] && grep -q "disable.*=.*no" /etc/xinetd.d/rlogin 2>/dev/null; then
        detail="$detail rlogin"
    fi
    if [ -f /etc/xinetd.d/rsh ] && grep -q "disable.*=.*no" /etc/xinetd.d/rsh 2>/dev/null; then
        detail="$detail rsh"
    fi
    if [ -f /etc/xinetd.d/rexec ] && grep -q "disable.*=.*no" /etc/xinetd.d/rexec 2>/dev/null; then
        detail="$detail rexec"
    fi
    if [ -z "$detail" ]; then return 0; fi
    detail="활성화된 r계열 서비스:$detail"
    return 1
}

if check_u36; then
    check_result "U-36" "r 계열 서비스 비활성화" "SAFE"
else
    check_result "U-36" "r 계열 서비스 비활성화" "VULN" "$detail"
fi

# U-44: tftp, talk 서비스 비활성화
check_u44() {
    local detail=""
    if [ -f /etc/xinetd.d/tftp ] && grep -q "disable.*=.*no" /etc/xinetd.d/tftp 2>/dev/null; then
        detail="$detail tftp"
    fi
    if [ -f /etc/xinetd.d/talk ] && grep -q "disable.*=.*no" /etc/xinetd.d/talk 2>/dev/null; then
        detail="$detail talk"
    fi
    if [ -z "$detail" ]; then return 0; fi
    detail="활성화된 서비스:$detail"
    return 1
}

if check_u44; then
    check_result "U-44" "tftp, talk 서비스 비활성화" "SAFE"
else
    check_result "U-44" "tftp, talk 서비스 비활성화" "VULN" "$detail"
fi

# U-52: Telnet 서비스 비활성화
check_u52() {
    local detail=""
    if systemctl is-active telnet.socket &>/dev/null; then
        detail="systemd telnet.socket 활성화"
        return 1
    fi
    if netstat -tlnp 2>/dev/null | grep -q ":23 "; then
        detail="Telnet(23) 포트 리스닝 중"
        return 1
    fi
    if [ -f /etc/xinetd.d/telnet ] && grep -q "disable.*=.*no" /etc/xinetd.d/telnet 2>/dev/null; then
        detail="xinetd telnet 활성화"
        return 1
    fi
    return 0
}

if check_u52; then
    check_result "U-52" "Telnet 서비스 비활성화" "SAFE"
else
    check_result "U-52" "Telnet 서비스 비활성화" "VULN" "$detail"
fi

# U-58: 불필요한 SNMP 서비스 구동 점검
check_u58() {
    if systemctl is-active snmpd &>/dev/null || ps -ef | grep -v grep | grep -q "snmpd"; then
        detail="SNMP 서비스(snmpd) 실행 중"
        return 1
    fi
    return 0
}

if check_u58; then
    check_result "U-58" "불필요한 SNMP 서비스 구동 점검" "SAFE"
else
    check_result "U-58" "불필요한 SNMP 서비스 구동 점검" "VULN" "$detail"
fi

# U-59: 안전한 SNMP 버전 사용
check_u59() {
    if ! systemctl is-active snmpd &>/dev/null; then
        check_result "U-59" "안전한 SNMP 버전 사용" "INFO" "SNMP 미사용"
        return
    fi
    if grep -qE "createUser|rouser|rwuser" /etc/snmp/snmpd.conf 2>/dev/null; then
        check_result "U-59" "안전한 SNMP 버전 사용" "SAFE" "SNMPv3 사용자 설정됨"
    else
        check_result "U-59" "안전한 SNMP 버전 사용" "VULN" "SNMP v3 미설정"
    fi
}

check_u59

# U-60: SNMP Community String 복잡성 설정
check_u60() {
    if [ ! -f /etc/snmp/snmpd.conf ]; then
        check_result "U-60" "SNMP Community String 복잡성 설정" "INFO" "SNMP 미사용"
        return
    fi
    local detail=""
    if grep -qE "(rocommunity|rwcommunity|com2sec).*public" /etc/snmp/snmpd.conf; then
        detail="$detail public 사용"
    fi
    if grep -qE "(rocommunity|rwcommunity|com2sec).*private" /etc/snmp/snmpd.conf; then
        detail="$detail private 사용"
    fi
    if [ -z "$detail" ]; then
        check_result "U-60" "SNMP Community String 복잡성 설정" "SAFE"
    else
        check_result "U-60" "SNMP Community String 복잡성 설정" "VULN" "$detail"
    fi
}

check_u60

# U-62: 로그인 시 경고 메시지 설정
check_u62() {
    if [ -s /etc/motd ] || [ -s /etc/issue ] || [ -s /etc/issue.net ]; then
        detail="경고 메시지 파일 존재"
        return 0
    fi
    detail="경고 메시지 미설정"
    return 1
}

if check_u62; then
    check_result "U-62" "로그인 시 경고 메시지 설정" "SAFE" "$detail"
else
    check_result "U-62" "로그인 시 경고 메시지 설정" "VULN" "$detail"
fi

# U-63: sudo 명령어 접근 관리
check_u63() {
    if [ ! -f /etc/sudoers ]; then
        check_result "U-63" "sudo 명령어 접근 관리" "INFO" "/etc/sudoers 없음"
        return
    fi
    local perm=$(stat -c "%a" /etc/sudoers)
    local owner=$(stat -c "%U" /etc/sudoers)
    detail="소유자=$owner, 권한=$perm"
    if [ "$owner" = "root" ] && { [ "$perm" = "440" ] || [ "$perm" = "640" ]; }; then
        check_result "U-63" "sudo 명령어 접근 관리" "SAFE" "$detail"
    else
        check_result "U-63" "sudo 명령어 접근 관리" "VULN" "$detail"
    fi
}

check_u63

################################################################################
# 4. 패치 관리 (U-64)
################################################################################
print_header "4. 패치 관리 (U-64)"

check_u64() {
    local detail=""
    if command -v yum &>/dev/null; then
        local count=$(yum check-update 2>/dev/null | grep -c "^\S" || echo 0)
        detail="yum 업데이트 가능 패키지: ${count}개"
    elif command -v apt &>/dev/null; then
        local count=$(apt list --upgradable 2>/dev/null | grep -c "upgradable" || echo 0)
        detail="apt 업데이트 가능 패키지: ${count}개"
    else
        detail="패키지 관리자 확인 필요"
    fi
    check_result "U-64" "주기적 보안 패치 및 벤더 권고사항 적용" "INFO" "$detail"
}

check_u64

################################################################################
# 5. 로그 관리 (U-65 ~ U-67)
################################################################################
print_header "5. 로그 관리 (U-65 ~ U-67)"

# U-65: NTP 및 시각 동기화 설정
check_u65() {
    local detail=""
    if systemctl is-active chronyd &>/dev/null; then
        detail="chronyd 활성화됨"
        return 0
    fi
    if systemctl is-active ntpd &>/dev/null; then
        detail="ntpd 활성화됨"
        return 0
    fi
    if [ -f /etc/ntp.conf ]; then
        if grep -qE "^server" /etc/ntp.conf; then
            detail="NTP 서버 설정됨"
            return 0
        fi
    fi
    detail="NTP 서비스 미실행"
    return 1
}

if check_u65; then
    check_result "U-65" "NTP 및 시각 동기화 설정" "SAFE" "$detail"
else
    check_result "U-65" "NTP 및 시각 동기화 설정" "VULN" "$detail"
fi

# U-66: 정책에 따른 시스템 로깅 설정
check_u66() {
    local detail=""
    if [ -f /etc/rsyslog.conf ] || [ -f /etc/syslog.conf ]; then
        if systemctl is-active rsyslog &>/dev/null || systemctl is-active syslog &>/dev/null; then
            detail="로깅 서비스 활성화됨"
            return 0
        fi
    fi
    detail="로깅 서비스 미실행"
    return 1
}

if check_u66; then
    check_result "U-66" "정책에 따른 시스템 로깅 설정" "SAFE" "$detail"
else
    check_result "U-66" "정책에 따른 시스템 로깅 설정" "VULN" "$detail"
fi

# U-67: 로그 디렉터리 소유자 및 권한 설정
check_u67() {
    local logdir="/var/log"
    local vuln=0
    for file in $(find "$logdir" -maxdepth 1 -type f 2>/dev/null); do
        local owner=$(stat -c "%U" "$file")
        local perm=$(stat -c "%a" "$file")
        if [ "$owner" != "root" ] || [ "$perm" -gt 644 ]; then
            vuln=$((vuln+1))
        fi
    done
    if [ "$vuln" -eq 0 ]; then return 0; fi
    detail="$logdir 내 권한 취약 파일 ${vuln}개"
    return 1
}

if check_u67; then
    check_result "U-67" "로그 디렉터리 소유자 및 권한 설정" "SAFE"
else
    check_result "U-67" "로그 디렉터리 소유자 및 권한 설정" "VULN" "$detail"
fi

################################################################################
# 최종 결과 요약
################################################################################
print_header "점검 결과 요약"
log ""
log "  총 점검 항목 : $TOTAL_CHECKS"
log "  ${GREEN}양호${NC}         : $SAFE_COUNT"
log "  ${RED}취약${NC}         : $VULN_COUNT"
log "  ${BLUE}정보${NC}         : $((TOTAL_CHECKS - SAFE_COUNT - VULN_COUNT))"
log ""
log "  상세 결과 파일 : $OUTPUT_FILE"
log "######################################################################"
log ""

exit 0