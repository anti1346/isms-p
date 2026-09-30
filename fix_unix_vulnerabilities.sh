#!/bin/bash
################################################################################
# 파일명   : fix_unix_vulnerabilities.sh
# 목적     : Unix 서버 취약점 자동 조치 (안전한 항목만)
# 주의     : 운영 서버 적용 전 반드시 테스트 환경에서 검증하세요!
# 백업     : 조치 전 자동으로 /var/backup/vuln_fix_YYYYMMDD_HHMMSS 생성
# 사용법   : sudo ./fix_unix_vulnerabilities.sh [--dry-run]
################################################################################

set -u

# ==================== 설정 ====================
DRY_RUN=false
[ "${1:-}" = "--dry-run" ] && DRY_RUN=true

BACKUP_DIR="/var/backup/vuln_fix_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="/var/log/vuln_fix_$(date +%Y%m%d_%H%M%S).log"

# 색상
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# ==================== 함수 ====================
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        local backup_path="${BACKUP_DIR}${file}"
        mkdir -p "$(dirname "$backup_path")"
        cp -p "$file" "$backup_path"
        log "[백업] $file → $backup_path"
    fi
}

do_cmd() {
    if [ "$DRY_RUN" = true ]; then
        log "[DRY-RUN] $*"
    else
        log "[실행] $*"
        eval "$@"
    fi
}

check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "이 스크립트는 root 권한으로 실행해야 합니다."
        exit 1
    fi
}

# ==================== 시작 ====================
check_root

log "######################################################################"
log "#  Unix 서버 취약점 자동 조치 스크립트                              #"
log "#  모드        : $([ "$DRY_RUN" = true ] && echo 'DRY-RUN (미리보기)' || echo '실제 조치')"
log "#  백업 디렉터리: $BACKUP_DIR"
log "#  로그 파일   : $LOG_FILE"
log "######################################################################"

mkdir -p "$BACKUP_DIR"

################################################################################
# U-01: root 계정 원격 접속 제한
################################################################################
log ""
log "[U-01] root 계정 원격 접속 제한 조치 중..."
if [ -f /etc/ssh/sshd_config ]; then
    if grep -qE "^#?PermitRootLogin" /etc/ssh/sshd_config; then
        backup_file /etc/ssh/sshd_config
        do_cmd "sed -i 's/^#\\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config"
        do_cmd "systemctl restart sshd 2>/dev/null || service ssh restart 2>/dev/null || true"
        log "${GREEN}[조치완료] PermitRootLogin no 설정${NC}"
    fi
fi

################################################################################
# U-02: 비밀번호 관리정책 설정
################################################################################
log ""
log "[U-02] 비밀번호 관리정책 조치 중..."
if [ -f /etc/login.defs ]; then
    backup_file /etc/login.defs
    do_cmd "sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs"
    do_cmd "sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   1/' /etc/login.defs"
    do_cmd "sed -i 's/^PASS_MIN_LEN.*/PASS_MIN_LEN    8/' /etc/login.defs"
    do_cmd "sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE   7/' /etc/login.defs"
    log "${GREEN}[조치완료] PASS_MAX_DAYS=90, PASS_MIN_DAYS=1, PASS_MIN_LEN=8${NC}"
fi

################################################################################
# U-12: 세션 종료 시간 설정
################################################################################
log ""
log "[U-12] 세션 종료 시간 설정 조치 중..."
if [ -f /etc/profile ]; then
    if ! grep -q "^TMOUT" /etc/profile; then
        backup_file /etc/profile
        do_cmd "echo '' >> /etc/profile"
        do_cmd "echo '# Session Timeout' >> /etc/profile"
        do_cmd "echo 'TMOUT=600' >> /etc/profile"
        do_cmd "echo 'export TMOUT' >> /etc/profile"
        log "${GREEN}[조치완료] TMOUT=600 추가${NC}"
    fi
fi

################################################################################
# U-16: /etc/passwd 파일 소유자 및 권한 설정
################################################################################
log ""
log "[U-16] /etc/passwd 파일 소유자 및 권한 조치 중..."
do_cmd "chown root:root /etc/passwd"
do_cmd "chmod 644 /etc/passwd"
log "${GREEN}[조치완료] /etc/passwd 소유자 root:root, 권한 644${NC}"

################################################################################
# U-18: /etc/shadow 파일 소유자 및 권한 설정
################################################################################
log ""
log "[U-18] /etc/shadow 파일 소유자 및 권한 조치 중..."
if [ -f /etc/shadow ]; then
    do_cmd "chown root:root /etc/shadow"
    do_cmd "chmod 400 /etc/shadow"
    log "${GREEN}[조치완료] /etc/shadow 소유자 root:root, 권한 400${NC}"
fi

################################################################################
# U-19: /etc/hosts 파일 소유자 및 권한 설정
################################################################################
log ""
log "[U-19] /etc/hosts 파일 소유자 및 권한 조치 중..."
do_cmd "chown root:root /etc/hosts"
do_cmd "chmod 644 /etc/hosts"
log "${GREEN}[조치완료] /etc/hosts 소유자 root:root, 권한 644${NC}"

################################################################################
# U-22: /etc/services 파일 소유자 및 권한 설정
################################################################################
log ""
log "[U-22] /etc/services 파일 소유자 및 권한 조치 중..."
if [ -f /etc/services ]; then
    do_cmd "chown root:root /etc/services"
    do_cmd "chmod 644 /etc/services"
    log "${GREEN}[조치완료] /etc/services 소유자 root:root, 권한 644${NC}"
fi

################################################################################
# U-30: UMASK 설정 관리
################################################################################
log ""
log "[U-30] UMASK 설정 조치 중..."
if [ -f /etc/profile ]; then
    if ! grep -qE "^umask 022" /etc/profile; then
        backup_file /etc/profile
        do_cmd "echo '' >> /etc/profile"
        do_cmd "echo '# UMASK Setting' >> /etc/profile"
        do_cmd "echo 'umask 022' >> /etc/profile"
        log "${GREEN}[조치완료] umask 022 추가${NC}"
    fi
fi

################################################################################
# U-63: sudo 명령어 접근 관리
################################################################################
log ""
log "[U-63] sudoers 파일 권한 조치 중..."
if [ -f /etc/sudoers ]; then
    do_cmd "chown root:root /etc/sudoers"
    do_cmd "chmod 440 /etc/sudoers"
    log "${GREEN}[조치완료] /etc/sudoers 소유자 root:root, 권한 440${NC}"
fi

################################################################################
# U-67: 로그 디렉터리 소유자 및 권한 설정
################################################################################
log ""
log "[U-67] 로그 디렉터리 권한 조치 중..."
for file in $(find /var/log -maxdepth 1 -type f 2>/dev/null); do
    owner=$(stat -c "%U" "$file")
    perm=$(stat -c "%a" "$file")
    if [ "$owner" != "root" ] || [ "$perm" -gt 644 ]; then
        do_cmd "chown root:root '$file'"
        do_cmd "chmod 644 '$file'"
    fi
done
log "${GREEN}[조치완료] /var/log 내 파일 권한 정리${NC}"

################################################################################
# 완료
################################################################################
log ""
log "######################################################################"
log "#  자동 조치 완료                                                    #"
log "#  백업 위치: $BACKUP_DIR"
log "#  로그 파일: $LOG_FILE"
log "######################################################################"
log ""
log "${YELLOW}⚠️  다음 항목은 서비스 영향이 있어 수동 조치가 필요합니다:${NC}"
log "  - U-34 (Finger 서비스): 서비스 미사용 확인 후 중지"
log "  - U-36 (r 계열 서비스): 서비스 미사용 확인 후 중지"
log "  - U-52 (Telnet): SSH 전환 후 중지"
log "  - U-58 (SNMP): 모니터링 영향 확인 후 중지"
log ""
log "롤백: ./rollback_unix_vulnerabilities.sh $BACKUP_DIR"
log ""

exit 0