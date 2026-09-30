# I. Unix 서버

## 01. Unix 서버 취약점 분석 · 평가 항목

### 1. 계정 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| root 계정 원격 접속 제한 | 상 | U-01 |
| 비밀번호 관리정책 설정 | 상 | U-02 |
| 계정 잠금 임계값 설정 | 상 | U-03 |
| 비밀번호 파일 보호 | 상 | U-04 |
| root 이외의 UID가 '0' 금지 | 상 | U-05 |
| 사용자 계정 su 기능 제한 | 상 | U-06 |
| 불필요한 계정 제거 | 하 | U-07 |
| 관리자 그룹에 최소한의 계정 포함 | 중 | U-08 |
| 계정이 존재하지 않는 GID 금지 | 하 | U-09 |
| 동일한 UID 금지 | 중 | U-10 |
| 사용자 Shell 점검 | 하 | U-11 |
| 세션 종료 시간 설정 | 하 | U-12 |
| 안전한 비밀번호 암호화 알고리즘 사용 | 중 | U-13 |

### 2. 파일 및 디렉토리 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| root 홈, 패스 디렉터리 권한 및 패스 설정 | 상 | U-14 |
| 파일 및 디렉터리 소유자 설정 | 상 | U-15 |
| /etc/passwd 파일 소유자 및 권한 설정 | 상 | U-16 |
| 시스템 시작 스크립트 권한 설정 | 상 | U-17 |
| /etc/shadow 파일 소유자 및 권한 설정 | 상 | U-18 |
| /etc/hosts 파일 소유자 및 권한 설정 | 상 | U-19 |
| /etc/(x)inetd.conf 파일 소유자 및 권한 설정 | 상 | U-20 |
| /etc/(r)syslog.conf 파일 소유자 및 권한 설정 | 상 | U-21 |
| /etc/services 파일 소유자 및 권한 설정 | 상 | U-22 |
| SUID, SGID, Sticky bit 설정 파일 점검 | 상 | U-23 |
| 사용자, 시스템 환경변수 파일 소유자 및 권한 설정 | 상 | U-24 |
| world writable 파일 점검 | 상 | U-25 |
| /dev에 존재하지 않는 device 파일 점검 | 상 | U-26 |
| $HOME/.rhosts, hosts.equiv 사용 금지 | 상 | U-27 |
| 접속 IP 및 포트 제한 | 상 | U-28 |
| hosts.lpd 파일 소유자 및 권한 설정 | 하 | U-29 |
| UMASK 설정 관리 | 중 | U-30 |
| 홈 디렉토리 소유자 및 권한 설정 | 중 | U-31 |
| 홈 디렉토리로 지정한 디렉토리의 존재 관리 | 중 | U-32 |
| 숨겨진 파일 및 디렉토리 검색 및 제거 | 하 | U-33 |

### 3. 서비스 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| Finger 서비스 비활성화 | 상 | U-34 |
| 공유 서비스에 대한 익명 접근 제한 설정 | 상 | U-35 |
| r 계열 서비스 비활성화 | 상 | U-36 |
| crontab 설정파일 권한 설정 미흡 | 상 | U-37 |
| DoS 공격에 취약한 서비스 비활성화 | 상 | U-38 |
| 불필요한 NFS 서비스 비활성화 | 상 | U-39 |
| NFS 접근 통제 | 상 | U-40 |
| 불필요한 automountd 제거 | 상 | U-41 |
| 불필요한 RPC 서비스 비활성화 | 상 | U-42 |
| NIS, NIS+ 점검 | 상 | U-43 |
| tftp, talk 서비스 비활성화 | 상 | U-44 |
| 메일 서비스 버전 점검 | 상 | U-45 |
| 일반 사용자의 메일 서비스 실행 방지 | 상 | U-46 |
| 스팸 메일 릴레이 제한 | 상 | U-47 |
| expn, vrfy 명령어 제한 | 중 | U-48 |
| DNS 보안 버전 패치 | 상 | U-49 |
| DNS Zone Transfer 설정 | 상 | U-50 |
| DNS 서비스의 취약한 동적 업데이트 설정 금지 | 중 | U-51 |
| Telnet 서비스 비활성화 | 중 | U-52 |
| FTP 서비스 정보 노출 제한 | 하 | U-53 |
| 암호화되지 않는 FTP 서비스 비활성화 | 중 | U-54 |
| FTP 계정 Shell 제한 | 중 | U-55 |
| FTP 서비스 접근 제어 설정 | 하 | U-56 |
| Ftpusers 파일 설정 | 중 | U-57 |
| 불필요한 SNMP 서비스 구동 점검 | 중 | U-58 |
| 안전한 SNMP 버전 사용 | 상 | U-59 |
| SNMP Community String 복잡성 설정 | 중 | U-60 |
| SNMP Access Control 설정 | 상 | U-61 |
| 로그인 시 경고 메시지 설정 | 하 | U-62 |
| sudo 명령어 접근 관리 | 중 | U-63 |

### 4. 패치 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| 주기적 보안 패치 및 벤더 권고사항 적용 | 상 | U-64 |

### 5. 로그 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| NTP 및 시각 동기화 설정 | 중 | U-65 |
| 정책에 따른 시스템 로깅 설정 | 중 | U-66 |
| 로그 디렉터리 소유자 및 권한 설정 | 중 | U-67 |

---

## 1. 계정 관리

### U-01 (상) root 계정 원격 접속 제한

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 시스템 정책에 root 계정의 원격터미널 접속 차단 설정이 적용 여부 점검 |
| 점검 목적 | 관리자 계정 탈취로 인한 시스템 장악을 방지하기 위해 외부 비인가자의 root 계정 접근 시도를 원천적으로 차단하기 위함 |
| 보안 위험 | root 계정은 운영체제의 모든 기능을 설정 및 변경이 가능하여(프로세스, 커널 변경 등) root 계정을 탈취하여 외부에서 원격을 이용한 시스템 장악 및 각종 공격으로(무처별 대입 공격, 사전 대입 공격 등) 인한 root 계정 사용 불가 위험이 존재함 |
| 참고 | ※ root 계정: 여러 사용자가 사용하는 컴퓨터에서 모든 기능을 관리할 수 있는 총괄 권한을 가진 유일한 특별 계정. 유닉스 시스템의 루트(root)는 시스템 관리자인 운용 관리자(Super User)로서 윈도우의 Administrator보다 높은 System 계정에 해당하며, 사용자 계정을 생성하거나 소프트웨어를 설치하고, 환경 및 설정을 변경하거나 시스템의 동작을 감시 및 제어할 수 있음<br>※ 무처별 대입 공격(Brute Force Attack): 특정한 암호를 풀기 위해 가능한 모든 값을 대입하는 공격 방법<br>※ 사전 대입 공격(Dictionary Attack): 사전에 있는 단어를 입력하여 암호를 알아내거나 암호를 해독하는 데 사용되는 컴퓨터 공격 방법<br>※ tty(terminal-teletype): 서버와 연결된 모니터, 키보드 등을 통해 사용자가 콘솔로 직접 로그인함<br>※ pts(pseudo-terminal): 가상터미널을 뜻하며, Telnet, SSH 등을 이용하여 접속함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 원격터미널 서비스를 사용하지 않거나, 사용 시 root 직접 접속을 차단한 경우<br>**취약**: 원격터미널 서비스 사용 시 root 직접 접속을 허용한 경우 |
| 조치 방법 | 원격 접속 시 root 계정으로 접속할 수 없도록 파일 내용 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

[Telnet]
```
Step 1) /etc/default/login 파일 내에 CONSOLE 설정값 수정
CONSOLE=/dev/console
```

[SSH]
```
Step 1) /etc/ssh/sshd_config 파일 내의 PermitRootLogin 설정값 수정
PermitRootLogin No
```

**● LINUX**

[Telnet]
```
Step 1) /etc/pam.d/login 파일 내에 auth required /lib/security/pam_securetty.so 입력
Step 2) /etc/securetty 파일 내에 pts/ 설정값 주석 처리 및 제거
#pts/0
#pts/1
#pts/2

Step 3) /etc/pam.d/login 파일 내에 모듈 추가
auth required /lib/security/pam_securetty.so
```

> ※ /etc/securetty 파일 내 pts/x 관련 설정이 존재하는 경우 PAM 모듈 설정과 관계없이 root 계정 접속을 허용하므로 반드시 제거 필요
> ※ CentOS 8, Ubuntu 20.04 이상부터 /etc/securetty 파일이 존재하지 않으며 기본적으로 Telnet 서비스가 비활성화됨

[SSH]
```
Step 1) /etc/ssh/sshd_config 파일에 PermitRootLogin 값 수정
PermitRootLogin No
```

**● AIX**

[Telnet]
```
Step 1) /etc/security/user 파일에 rlogin 설정값 수정
rlogin = false
```

[SSH]
```
Step 1) /etc/ssh/sshd_config 파일에 PermitRootLogin 값 수정
PermitRootLogin No
```

**● HP-UX**

[Telnet]
```
Step 1) etc/securetty 파일 내에 console 값 수정
console
```

> ※ /etc/securetty 파일은 기본적으로 존재하지 않으므로 해당 파일이 존재하지 않는 경우 생성 후 설정할 것

[SSH]
```
Step 1) /opt/ssh/etc/sshd_config 파일 내에 PermitRootLogin 값 수정
PermitRootLogin No
```

---

### U-02 (상) 비밀번호 관리정책 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 비밀번호 관리 정책 설정 여부 점검 |
| 점검 목적 | 사용자의 비밀번호 복잡성과 주기적 변경을 통해 시스템 보안을 강화하기 위함 |
| 보안 위험 | 비밀번호 관련 정책이 설정되지 않을 경우, 비인가자의 각종 공격(무처별 대입 공격, 사전 대입 공격 등)에 의해 비밀번호가 노출될 위험이 존재함 |
| 참고 | ※ 비밀번호 관리 정책: 비밀번호 복잡성 및 길이, 변경 주기 등을 포함한 비밀번호 정책<br>※ 비밀번호 복잡성: 비밀번호 설정 시 영문, 숫자, 특수문자를 포함하여 최소 8자리 이상 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 비밀번호 관리 정책이 설정된 경우<br>**취약**: 비밀번호 관리 정책이 설정되지 않은 경우 |
| 조치 방법 | root 계정을 포함한 사용자 계정의 비밀번호를 영문, 숫자, 특수문자를 포함하여 최소 8자리 이상 및 최소 사용 기간 1일, 최대 사용 기간 90일, 최근 비밀번호 기억 4회 이상으로 설정 |
| 조치 시 영향 | 비밀번호 변경 시 Web, WAS, DB 연동 구간에서 문제가 발생할 수 있으므로 연동 구간에 미칠 수 있는 영향을 고려하여 적용 필요 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) /etc/default/passwd 파일 내에 비밀번호 설정값 수정
HISTORY=4
PASSLENGTH=8
MINDIGIT=1
MINUPPER=1
MINLOWER=1
MINSPECIAL=1
WHITESPACE=NO
```

| 권고값 | 기능 | 설명 |
| :--- | :--- | :--- |
| HISTORY= 10 | 이전 비밀번호 기억 개수 | 이전 10개의 암호를 기억함 |
| MINDIFF= 4 | 이전 암호와 차이 | 이전 암호와 4자 이상 차이 요구 |
| MINALPHA= 1 | 최소 문자 요구 | 최소 1자 이상 문자 요구 |
| MINNONALPHA= 1 | 최소 숫자 또는 특수문자 요구 | 숫자 또는 특수문자 1자 이상 요구 |
| MINUPPER= 1 | 최소 대문자 요구 | 최소 1자 이상 대문자 요구 |
| MINLOWER= 1 | 최소 소문자 요구 | 최소 1자 이상 소문자 요구 |
| MAXREPEATS= 0 | 연속 문자 사용 허용 | 0일 경우 문자 연속 사용이 불가 |
| MINSPECIAL= 1 | 최소 특수문자 요구 | 최소 1자 이상 특수문자 요구 |
| MINDIGIT= 1 | 최소 숫자 요구 | 최소 1자 이상 숫자 요구 |
| NAMECHECK= YES | 아이디와 비밀번호 동일 검증 | 아이디와 동일한 비밀번호 사용 불가 |
| MAXDAYS= 90 | 비밀번호 최대 유효일 수 | 최대 90일 비밀번호가 유효 |
| MINDAYS= 1 | 비밀번호 변경 최소일 수 | 비밀번호 최소 1일 후 변경 가능 |
| MAXWEEKS= 12 | 비밀번호 최대 유효 주 수 | 최대 12주 비밀번호가 유효 |
| MINWEEKS= 1 | 비밀번호 변경 최소일 수 | 비밀번호 최소 일주일 후 변경 가능 |
| WARNWEEKS= 1 | 비밀번호 만료 전 알림 주 수 | 비밀번호 만료 일주일 전 알림 |
| PASSLENGTH= 8 | 비밀번호 최소 길이 | 비밀번호 최소 길이 8 |
| WHITESPACE= NO | 비밀번호 공백문자 사용 여부 | 비밀번호에 공백문자 사용 금지 설정 |

> ※ MINDIGIT, MINSPECIAL 설정이 적용되어 있는 경우 MINNONALPHA 설정은 적용되지 않음
> ※ MINDAYS 설정이 적용되어야 MAXDAYS 설정이 적용됨
> ※ 비밀번호 유효일 설정과 비밀번호 유효 주 설정은 중복 설정 불가함
> ※ WHITESPACE 기본값: YES

**● LINUX**

[Redhat]
```
Step 1) /etc/login.defs 파일에 PASS_MAX_DAYS / PASS_MIN_DAYS 값 수정
PASS_MAX_DAYS 90
PASS_MIN_DAYS 0

Step 2) /etc/security/pwquality.conf 파일에 정책 값 수정
minlen = 8
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
enforce_for_root

Step 3) /etc/security/pwhistory.conf 파일에 값 추가 및 수정
enforce_for_root
remember=4
file = /etc/security/opasswd

Step 4) /etc/pam.d/system-auth 파일에 값 수정

Step 5) /etc/login.defs 파일에 PASS_MAX_DAYS / PASS_MIN_DAYS 값 수정
PASS_MAX_DAYS 90
PASS_MIN_DAYS 1
```

> ※ pam_pwquality.so, pam_pwhistory.so 모듈은 pam_unix.so 모듈 위에 위치해야 적용됨
> ※ /etc/security/pwquality.conf 파일과 /etc/pam.d/system-auth 파일 중 어느 하나라도 비밀번호 관리 정책이 설정되어 있으면 양호
> ※ 비밀번호 복잡성 설정에서 최소 요구 항목의 값은 반드시 -1로 설정되어야 함
> ※ /etc/pam.d/system-auth 파일에 enforce_for_root 추가

[Debian]
```
Step 1) /etc/security/pwquality.conf 파일에 정책 값 수정
minlen = 8
dcredit = -1
ucredit = -1
lcredit = -1
ocredit = -1
enforce_for_root

Step 2) /etc/pam.d/common-password 파일에 정책 값 수정
pam_pwquality.so, pam_pwhistory.so 모듈은 pam_unix.so 모듈 위에 위치해야 적용됨

Step 3) /etc/login.defs 파일에 값 수정
PASS_MAX_DAYS 90
PASS_MIN_DAYS 1
```

| 권고값 | 기능 | 설명 |
| :--- | :--- | :--- |
| difok = N | 기존 비밀번호와 비교 | 기존 비밀번호에 포함되지 않는 문자를 최소 N개 이상 포함하도록 설정 |
| minlen = 8 | 최소 비밀번호 길이 설정 | 최소 8자리 이상 설정 |
| dcredit = -1 | 최소 숫자 요구 | 최소 숫자 1자 이상 요구 |
| ucredit = -1 | 최소 대문자 요구 | 최소 대문자 1자 이상 요구 |
| lcredit = -1 | 최소 소문자 요구 | 최소 소문자 1자 이상 요구 |
| ocredit = -1 | 최소 특수문자 요구 | 최소 특수문자 1자 이상 요구 |
| remember = N | 최근 비밀번호 기억 | 최근 변경한 비밀번호를 N개 이상 기억하여 동일한 비밀번호로 변경하지 못하도록 설정 |
| PASS_MIN_DAYS = 1 | 비밀번호 최소 사용 기간 설정 | 비밀번호 최소 사용 기간 설정 (단위 : 일) |
| PASS_MAX_DAYS = 90 | 비밀번호 최대 사용 기간 설정 | 비밀번호 최대 사용 기간 설정 (단위 : 일) |

> ※ /etc/security/pwquality.conf 파일과 /etc/pam.d/common-password(/etc/pam.d/system-auth) 파일 중 어느 하나라도 비밀번호 관리 정책이 설정되어 있으면 양호
> ※ 비밀번호 복잡성 설정에서 최소 요구 항목의 값은 반드시 -1로 설정되어야 함
> ※ /etc/pam.d/system-auth 파일에 enforce_for_root 추가

**● AIX**

```
Step 1) etc/security/user 파일에 정책 값 수정
default :
minage = 1
maxage = 12
minalpha = 2
minother = 2
minspecialchar = 1
minlen = 8
mindiff = 4
histsize = 4
```

| 권고값 | 기능 | 설명 |
| :--- | :--- | :--- |
| histexpire= N | 동일한 비밀번호 재사용 기간 | 비밀번호 재사용에 필요한 시간 (단위 : 주) |
| histsize= 4 | 이전 비밀번호 기억 개수 | 허용 비밀번호 반복 횟수 |
| maxrepeats= 2 | 반복 가능한 동일 문자의 최대 수 | 비밀번호에서 반복될 수 있는 최대 문자 수 |
| minalpha= 2 | 최소 알파벳 문자 포함 | 비밀번호에 필요한 최소 영문자 수 |
| minother= 2 | 최소 알파벳 문자 이외의 문자 수 | 비밀번호에 필요한 최소 알파벳을 제외한 문자 수 |
| minspecialchar= 1 | 최소 특수문자 포함 | 비밀번호에 필요한 최소 특수문자 수 |
| mindiff= 4 | 이전 비밀번호와 동일 문자 수 | 이전 비밀번호와 구별되는 새 비밀번호의 최소 문자 수 |
| minlen= 8 | 비밀번호 최소 길이 | 최소 비밀번호 길이 |
| minage= 1 | 비밀번호 최소 사용 기간 | 비밀번호 변경에 필요한 최소 기간 (단위 : 주) |
| maxage= 12 | 비밀번호 최대 사용 기간 | 비밀번호 변경에 필요한 최대 시간 (단위 : 주) |

**● HP-UX**

```
Step 1) /etc/default/security 파일에 정책 값 수정
MIN_PASSWORD_LENGTH=8
PASSWORD_MIN_UPPER_CASE_CHARS=1
PASSWORD_MIN_LOWER_CASE_CHARS=1
PASSWORD_MIN_DIGIT_CASE_CHARS=1
PASSWORD_MIN_SPECIAL_CASE_CHARS=1
PASSWORD_MAXDAYS=90
PASSWORD_MINDAYS=1
HISTORY=4
```

| 권고값 | 기능 | 설명 |
| :--- | :--- | :--- |
| MIN_PASSWORD_LENG TH= 8 | 비밀번호 최소 길이 | 최소 비밀번호 길이 |
| PASSWORD_MIN_UPPE R_CASE_CHARS= 1 | 최소 대문자 필요 개수 | 비밀번호에 필요한 최소 대문자 수 |
| PASSWORD_MIN_LOWE R_CASE_CHARS= 1 | 최소 소문자 필요 개수 | 비밀번호에 필요한 최소 소문자 수 |
| PASSWORD_MIN_DIGIT_CHARS= 1 | 최소 숫자 필요 개수 | 비밀번호에 필요한 최소 숫자 수 |
| PASSWORD_MIN_SPECIAL_CHARS= 1 | 최소 특수문자 필요 개수 | 비밀번호에 필요한 최소 특수문자 수 |
| PASSWORD_MINDAYS= 1 | 비밀번호 최소 사용 기간 | 비밀번호 변경에 필요한 최소 기간 (단위 : 일) |
| PASSWORD_MAXDAYS= 90 | 비밀번호 최대 사용 기간 | 비밀번호 변경에 필요한 최대 시간 (단위 : 일) |
| HISTORY= 4 | 이전 비밀번호 기억 개수 | 허용 비밀번호 번복 횟수 |

#### [부적절한 비밀번호 유형]

- 사전에 나오는 단어나 이들의 조합
- 길이가 너무 짧거나 NULL(공백)인 비밀번호
- 키보드 자판의 일련의 나열(예시 : abcd, qwert 등)
- 사용자 계정 정보에서 유추 가능한 단어들(예시 : 지역명, 부서명, 계정명, 사용자 이름 이니셜, root, admin 등)

#### [비밀번호 관리 방법]

- 영문, 숫자, 특수문자를 조합하여 계정명과 다른 8자 이상의 비밀번호 설정
  1. 다음 각 항목의 문자 종류 중 2종류 이상을 조합하여 최소 10자리 이상 또는 3종류 이상을 조합하여 최소 8자리 이상의 길이로 구성
     - 가. 영문 대문자(26개)
     - 나. 영문 소문자(26개)
     - 다. 숫자(10개)
     - 라. 특수문자(32개)
  2. 시스템마다 다른 비밀번호 사용
  3. 비밀번호를 기록해 놓는 경우 변형하여 기록

---

### U-03 (상) 계정 잠금 임계값 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 사용자 계정 로그인 실패 시 계정 잠금 임계값이 설정 여부 점검 |
| 점검 목적 | 계정 탈취 목적의 무차별 대입 공격 시 해당 계정을 잠금으로써 인증 요청에 응답하는 리소스 낭비를 차단하고 대입 공격으로 인한 비밀번호 노출 공격을 무력화하기 위함 |
| 보안 위험 | 계정 잠금 임계값이 설정되어 있지 않을 경우, 비밀번호 탈취 공격(무차별 대입 공격, 사전 대입 공격, 추측 공격 등)의 인증 요청에 대해 설정된 비밀번호가 일치할 때까지 지속적으로 응답하여 해당 계정의 비밀번호가 유출될 위험이 존재함 |
| 참고 | ※ 사용자 로그인 실패 임계값: 시스템에 로그인 시 몇 번의 로그인 실패에 로그인을 차단할 것인지 결정하는 값 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 계정 잠금 임계값이 10회 이하의 값으로 설정된 경우<br>**취약**: 계정 잠금 임계값이 설정되어 있지 않거나, 10회 이하의 값으로 설정되지 않은 경우 |
| 조치 방법 | 계정 잠금 임계값을 10회 이하로 설정 |
| 조치 시 영향 | • HP-UX: Trusted Mode로 전환 시 파일 시스템 구조가 변경되어 운영 중인 서비스에 문제가 발생할 수 있으므로 충분한 테스트를 거친 후 Trusted Mode로의 전환이 필요함<br>• LINUX: /etc/pam.d/system-auth 파일 설정 시 라이브러리(/lib/security/pam_tally.so)가 해당 경로에 존재하는지 확인 필요 (존재하지 않는 파일의 경로로 설정하는 경우 시스템 로그인에 장애가 발생할 수 있음)<br>• PAM 모듈을 이용하여 설정할 때 해당 순서를 지키지 않을 경우, 로그인 실패 또는 인증 실패 등 예기치 못한 상황이 발생할 수 있으므로 반드시 순서에 맞게 설정해야 함 |

#### 점검 및 조치 사례

**● SOLARIS**

```
[5.9 미만 버전]
Step 1) /etc/default/login 파일에 RETRIES 값 수정
RETRIES=10

[5.9 이상 버전]
Step 1) /etc/security/policy.conf 파일에 LOCK_AFTER_RETRIES 값 수정
LOCK_AFTER_RETRIES=YES
UNLOCK_AFTER =2m
```

| 옵션 | 설명 |
| :--- | :--- |
| RETRIES | 로그인 시도 횟수 |
| LOCK_AFTER_RETRIES | 로그인 시도 횟수와 같거나 초과 되면 잠금 여부 |
| UNLOCK_AFTER | 잠금시간 분(m), 시(h), 일(d), w(주) 단위로 설정 가능 |

**● LINUX**

```
[Redhat 계열의 pam_tally.so 또는 pam_tally2.so]
Step 1) /etc/pam.d/system-auth 파일에 deny 값 수정
auth required /lib/security/pam_tally.so 또는 /lib/security/pam_tally2.so deny=10 unlock_time=120 no_magic_root
account required /lib/security/pam_tally.so 또는 /lib/security/pam_tally2.so no_magic_root reset
```

> ※ /etc/pam.d/system-auth 파일 수정 시 모듈이 해당 경로에 존재하지 않을 경우, 모든 계정의 로그인이 되지 않는 등 예기치 못한 상황이 발생할 수 있으므로 반드시 올바른 경로를 작성해야 함

```
[Redhat 계열의 authselect]
Step 1) # authselect enable-feature with-faillock 입력하여 faillock 적용
# authselect current
Profile ID: sssd
Enabled features:
- with-fingerprint
- with-silent-lastlog
- with-faillock

Step 2) etc/security/faillock.conf 파일에 정책 값 수정
silent
deny = 10
unlock_time = 120
```

```
[Redhat 계열의 pam_faillock.so]
Step 1) /etc/pam.d/system-auth 파일에 모듈 값 수정
auth required pam_faillock.so preauth silent audit deny=10 unlock_time=120

Step 2) /etc/pam.d/password-auth 파일에 모듈 값 수정
auth required pam_faillock.so preauth silent audit deny=10 unlock_time=120
```

> ※ RHEL 8 이상부터 authselect 명령어를 이용하여 설정하는 것을 권장함

```
[Debian 계열의 pam_tally.so 또는 pam_tally2.so]
Step 1) /etc/pam.d/common-auth 파일에 모듈 값 수정
auth required /lib/security/pam_tally.so 또는 /lib/security/pam_tally2.so deny=10 unlock_time=120 no_magic_root
account required /lib/security/pam_tally.so 또는 /lib/security/pam_tally2.so no_magic_root reset
```

```
[Debian 계열의 pam_faillock.so]
Step 1) /etc/pam.d/common-auth 파일에 pam_faillock.so 모듈 값 수정
# here are the per-package modules (the "Primary" block)
auth required pam_faillock.so preauth audit deny=10 unlock_time=120
auth [success=2 default=ignore] pam_unix.so nullok
auth [success=1 default=ignore] pam_sss.so use_first_pass
# here's the fallback if no module succeeds
auth [default=die] pam_faillock.so authfail audit deny=10 unlock_time=120
auth sufficient pam_faillock.so authsucc audit deny=10 unlock_time=120
auth requisite pam_deny.so
# prime the stack with a positive return value if there isn't one already;
# this avoids us returning an error just because nothing sets a success code
# since the modules above will each just jump around
auth required pam_permit.so
```

[ /etc/pam.d/common-auth ]

```
Step 2) etc/pam.d/common-account 파일에 pam_faillock.so 모듈 값 수정
account required pam_permit.so
# and here are more per-package modules (the "Additional" block)
account sufficient pam_localuser.so
account [default=bad success=ok user_unknown=ignore] pam_sss.so
# end of pam-auth-update config
account required pam_faillock.so
```

[ /etc/pam.d/common-account ]

> ※ /etc/pam.d/* 파일 수정 시 모듈이 해당 경로에 존재하지 않을 경우, 모든 계정의 로그인이 되지 않는 등 예기치 못한 상황이 발생할 수 있으므로 반드시 올바른 경로를 작성해야 함
> ※ no_magic_root, reset 옵션은 pam_failock.so 모듈에서 기본으로 작동함
> ※ audit : 실패한로그인시도, 잠금조치, 계정차단등의이벤트를로그에기록하는옵션
> ※ silent : 비밀번호 인증 실패 시 사용자에게 세부적인 오류 메시지를 표시하지 않는 옵션

**● AIX**

```
Step 1) /etc/security/user 파일에 loginmetrics 값 수정
loginmetrics = 3
```

**● HP-UX**

```
[11.v2 이하 버전]
Step 1) /tcb/files/auth/system/default 파일에 u_maxtries 값 수정
u_maxtries#3
```

> ※ HP-UX 서버에 계정 잠금 정책 설정을 위해서는 HP-UX 서버가 Trusted Mode로 동작하고 있어야 하므로 Trusted Mode로 전환 후 잠금 정책 적용

```
[11.v3 이상 버전]
Step 1) /etc/default/security 파일에 AUTH_MAXTRIES 값 수정
AUTH_MAXTRIES=3
```

> ※ Standard 모드와 Shadow 모드만 적용 가능

| 옵션 | 설명 |
| :--- | :--- |
| no_magic_root | root 계정은 비밀번호 잠금 설정을 적용하지 않음 |
| deny=N | N회 입력 실패 시 계정 잠금 |
| unlock_time | 계정이 잡긴 경우, 마지막 계정 실패 시간부터 설정된 시간이 지나면 자동으로 계정 잠금 해제 (단위 : 초) |
| reset | 접속 시도 성공 시 실패한 횟수 초기화 |

---

### U-04 (상) 비밀번호 파일 보호

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 시스템의 사용자 계정(root, 일반 사용자) 정보가 저장된 파일(/etc/passwd, /etc/shadow 등)에 사용자 계정 비밀번호가 암호화 저장 여부 점검 |
| 점검 목적 | 일부 오래된 시스템의 경우 /etc/passwd 파일에 비밀번호가 평문으로 저장되므로 사용자 계정 비밀번호가 암호화되어 저장되어 있는지 점검하여 비인가자의 비밀번호 파일 접근 시에도 사용자 계정 비밀번호가 안전하게 관리되고 있는지 확인하기 위함 |
| 보안 위험 | 사용자 계정 비밀번호가 저장된 파일이 유출 또는 탈취 시 평문으로 저장된 비밀번호 정보가 노출 위험이 존재함 |
| 참고 | ※ pwconv: 쉐도우 비밀번호 정책<br>※ pwunconv: 일반 비밀번호 정책 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 쉐도우 비밀번호를 사용하거나, 비밀번호를 암호화하여 저장하는 경우<br>**취약**: 쉐도우 비밀번호를 사용하지 않고, 비밀번호를 암호화하여 저장하지 않는 경우 |
| 조치 방법 | 비밀번호 암호화 저장·관리 설정 |
| 조치 시 영향 | HP-UX 경우 Trusted Mode로 전환 시 파일 시스템 구조가 변경되어 운영 중인 서비스에 문제가 발생할 수 있으므로 충분한 테스트를 거친 후 Trusted Mode로의 전환이 필요함 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX**

```
Step 1) /etc/passwd 입력 후 파일 내 두 번째 필드가 x 표시되는지 확인
root:x:0:0:root:/root:/bin/bash

Step 2) # pwconv 명령으로 쉐도우 비밀번호 적용
```

> ※ SOLARIS 11은 pwunconv 명령어가 존재하지 않음

**● AIX**

```
Step 1) /etc/security/passwd 파일에 암호화 여부 확인
```

> ※ AIX는 기본적으로 /etc/security/passwd 파일에 비밀번호를 암호화하여 저장·관리함

**● HP-UX**

```
Step 1) /etc/passwd 파일에 암호화 확인
Step 2) # pwconv 명령으로 쉐도우 비밀번호 적용
```

> ※ HP-UX 서버는 Trusted Mode로 전환할 경우 비밀번호를 암호화하여 /tcb/files/auth 디렉터리에 계정 이니셜과 계정 이름에 따라 파일로 저장·관리할 수 있으므로 Trusted Mode인지 확인 후 UnTrusted Mode인 경우 모드를 전환함
> ※ Trusted mode 전환 방법 : root계정으로 아래 명령어 실행
> ```
> # /etc/tsconvert
> ```
> ※ UnTrusted mode 전환 방법 : root계정으로 아래 명령어 실행
> ```
> # /etc/tsconvert -r
> ```
> ※ HP-UX 11.11의 경우 Shadow Password Bundle을 설치하여야 /etc/shadow 파일 생성됨

---

### U-05 (상) root 이외의 UID가 '0' 금지

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 사용자 계정 정보가 저장된 파일(/etc/passwd, /etc/shadow 등)에 root(UID=0) 계정과 동일한 UID를 가진 계정이 존재 여부 점검 |
| 점검 목적 | root 계정과 동일한 UID가 존재하는지 점검하여 root 권한이 일반 사용자 계정이나 비인가자의 접근 위험에 안전하게 보호되고 있는지 확인하기 위함 |
| 보안 위험 | • root 계정과 동일한 UID가 설정되어 있는 일반 사용자 계정도 root 권한을 부여받아 관리자가 실행할 수 있는 모든 작업이 가능한 위험이 존재함(서비스 시작, 중지, 재부팅, root 권한 파일 편집 등)<br>• root 계정과 동일한 UID를 사용하므로 사용자 감사 추적 시 어려움 발생 위험이 존재함 |
| 참고 | ※ UID(User Identification): 여러 명의 사용자가 동시에 사용하는 시스템에서 사용자가 자신을 대표하기 위해 쓰는 이름<br>※ OS마다 UID 체계가 달라 시스템 계정 및 일반 사용자 계정이 부여받는 값의 범위에 차이가 있으나, 관리자는 공통으로 UID=0을 부여받음 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: root 계정과 동일한 UID를 갖는 계정이 존재하지 않는 경우<br>**취약**: root 계정과 동일한 UID를 갖는 계정이 존재하는 경우 |
| 조치 방법 | • UID가 0으로 설정된 계정을 0 이외의 중복되지 않은 UID로 변경 또는 불필요한 계정인 경우 제거하도록 설정<br>• (사용 중인 계정인 경우 명령어를 통한 조치가 적용되지 않을 수 있으므로 /etc/passwd 파일을 통해 변경) |
| 조치 시 영향 | 해당 계정에 관리자 권한이 필요하지 않으면 일반적으로 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) usermod 명령어를 이용하여 # usermod -u <변경할 UID> <사용자 이름> 명령으로 0 이외의 중복되지 않는 UID로 변경
```

```
계정명    UID값   GID값          홈디렉터리 위치
Test : x : 500 : 500 : Gen-User : /home/test : /usr/bin/bash
       ↑        ↑
    패스워드    설명(comment)    지정된 쉘
```

> ※ “:”(콜콜)을 사용하여 필드를 구분함
> ※ 세 번째 필드(UID)가 0인 경우 슈퍼 유저 권한을 가지며, 0 이외의 계정은 일반, 시스템 계정으로 볼 수 있음

---

### U-06 (상) 사용자 계정 su 기능 제한

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | su 명령어 사용을 허용하는 사용자를 지정한 그룹이 설정 여부 점검 |
| 점검 목적 | su 관련 그룹만 su 명령어 사용 권한이 부여되어 있는지 점검하여 su 그룹에 포함되지 않은 일반 사용자의 su 명령 사용을 원천적으로 차단하는지 확인하기 위함 |
| 보안 위험 | 무분별한 사용자 변경으로 타 사용자 소유의 파일을 변경할 수 있으며 root 계정으로 변경하는 경우 관리자 권한을 획득할 수 있는 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: su 명령어를 특정 그룹에 속한 사용자만 사용하도록 제한된 경우<br>※ 일반 사용자 계정 없이 root 계정만 사용하는 경우 su 명령어 사용 제한 불필요<br>**취약**: su 명령어를 모든 사용자가 사용하도록 설정된 경우 |
| 조치 방법 | PAM 모듈 설정 또는 su 명령어 허용 그룹 생성 후 su 명령어 일반 사용자 권한 제거하도록 설정 |
| 조치 시 영향 | 그룹에 추가된 계정들은 모든 Session 종료 후 재 로그인 시 su 명령어 사용 가능 |

#### 점검 및 조치 사례

**● SOLARIS, AIX, HP-UX**

```
Step 1) /etc/group 파일 내 wheel 그룹 (su 명령어 사용 그룹) 및 그룹 내 구성원 존재 여부 확인
Step 2) ls -l /usr/bin/su 입력 후 wheel 그룹이 su 명령어를 사용할 수 있는지 설정 여부 확인
Step 3) wheel group 생성 (wheel 그룹이 존재하지 않는 경우)
# groupadd wheel

su 명령 그룹 변경
# chgrp wheel /usr/bin/su

su 명령어 권한 변경
# chmod 4750 /usr/bin/su

wheel 그룹에 su 명령 허용 계정 등록
# usermod -G wheel <username>

또는 직접 /etc/group 파일을 수정하여 필요한 계정 등록
wheel:x:10: -> wheel:x:10:root,admin
```

**● LINUX**

```
[PAM 모듈 이용 중이지 않을 경우]
Step 1) /etc/group 파일 내 wheel 그룹(su 명령어 사용 그룹) 확인
Step 2) ls 명령어를 이용하여 # ls -l /usr/bin/su 입력 후 su 명령어 그룹과 권한 확인
Step 3) wheel group 생성 (wheel 그룹이 존재하지 않는 경우)
# groupadd wheel

su 명령 그룹 변경
# chgrp wheel /usr/bin/su

su 명령어 권한 변경
# chmod 4750 /usr/bin/su

wheel 그룹에 su 명령 허용 계정 등록
# usermod -G wheel <username>
```

> ※ /etc/group 파일에서 기본 그룹의 경우 사용자 이름은 생략되며 자동으로 포함됨

```
[PAM 모듈 이용 중인 경우]
Step 1) /etc/group 입력 후 wheel 그룹(su 명령어 사용 그룹) 확인
예시) wheel:x:1002:

Step 2) etc/pam.d/su 파일 내 su 명령어 허용 그룹 확인
Step 3) usr/bin/su 파일 내 su 명령어 그룹과 권한 확인
Step 4) /etc/pam.d/su 파일에 모듈 값 수정
auth required pam_wheel.so use_uid

또는

auth required pam_wheel.so group=wheel
```

---

### U-07 (하) 불필요한 계정 제거

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 시스템 계정 중 불필요한 계정(퇴직, 전직, 휴직 등의 이유로 사용하지 않는 계정 및 장기적으로 사용하지 않는 계정 등)이 존재 여부 점검 |
| 점검 목적 | 불필요한 계정이 존재하는지 점검하여 관리되지 않은 계정에 의한 침입에 대비하는지 확인하기 위함 |
| 보안 위험 | 로그인이 가능하고 현재 사용하지 않는 불필요한 계정은 사용 중인 계정보다 상대적으로 관리가 취약하여 공격자의 목표가 되어 계정이 탈취될 수 있는 위험이 존재함(퇴직, 전직, 휴직 등의 사유 발생 시 즉시 권한을 회수하는 것을 권고함) |
| 참고 | ※ 기본 계정: OS나 Package 설치 시 기본적으로 생성되는 계정(ip, uucp, nuucp 등)<br>※ 불필요한 기본 계정 제거 시 발생할 업무 영향도를 파악한 후 제거 권고 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 불필요한 계정이 존재하지 않는 경우<br>**취약**: 불필요한 계정이 존재하는 경우 |
| 조치 방법 | 시스템에 존재하는 계정 확인 후 불필요한 계정 제거하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
[/etc/passwd 파일을 이용하여 점검]
Step 1) /etc/passwd 파일 내 계정을 확인 후 “# userdel <사용자 이름>” 명령으로 불필요한 사용자 계정 제거
```

> ※ AIX 경우 muser 명령어 사용
> ※ /etc/passwd 파일에서 계정 앞에 #을 삽입하여도 주석으로 처리되지 않으므로 조치 시에는 반드시 계정을 제거하도록 권고함

```
[log를 이용하여 점검]
Step 1) last 명령어로 불필요한 계정 확인 후 제거
```

---

### U-08 (중) 관리자 그룹에 최소한의 계정 포함

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 시스템 관리자 그룹에 최소한(root 계정과 시스템 관리에 허용된 계정)의 계정만 존재 여부 점검 |
| 점검 목적 | 관리자 그룹에 최소한의 필요 계정만 존재하는지 확인하여 불필요한 권한 남용을 점검하기 위함 |
| 보안 위험 | 시스템을 관리하는 root 계정이 속한 그룹은 시스템 운영 파일에 대한 접근 권한이 부여되어 있으므로 해당 관리자 그룹에 속한 계정이 비인가자에게 유출될 경우, 관리자 권한으로 시스템에 접근하여 계정정보 유출, 환경설정 파일 및 디렉터리 변조 등의 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 관리자 그룹에 불필요한 계정이 등록되어 있지 않은 경우<br>**취약**: 관리자 그룹에 불필요한 계정이 등록된 경우 |
| 조치 방법 | 관리자 그룹에 등록된 계정 확인 후 불필요한 계정 제거하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/group 파일에 root 그룹에 포함된 계정 확인
Step 2) 불필요한 계정을 그룹원에서 제거
# gpasswd -d <사용자 이름> root
```

> ※ AIX의 경우 chgrpmem -m - <사용자 이름> root 명령어 사용

---

### U-09 (하) 계정이 존재하지 않는 GID 금지

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 그룹 설정 파일(/etc/group)에 불필요한 그룹이 존재 여부 점검 |
| 점검 목적 | 시스템에 불필요한 그룹이 존재하는지 점검하여 불필요한 그룹의 소유권으로 설정된 파일의 노출로 인해 발생할 수 있는 위험에 대해 대비를 하기 위함 |
| 보안 위험 | 계정이 존재하지 않거나 불필요한 그룹이 존재하는 경우, 해당 그룹의 소유로 설정된 파일을 통한 권한 남용 또는 의도치 않은 권한 부여, 보안 감사 및 관리의 어려움 등의 위험이 존재함 |
| 참고 | ※ GID(Group Identification): 다수의 사용자가 특정 개체를 공유할 수 있게 연계시키는 특정 그룹의 이름으로 주로 계정처리 목적으로 사용되며, 한 사용자는 여러 개의 GID를 가질 수 있음 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 시스템 관리나 운용에 불필요한 그룹이 제거된 경우<br>**취약**: 시스템 관리나 운용에 불필요한 그룹이 존재하는 경우 |
| 조치 방법 | 불필요한 그룹이 존재하는 경우 관리자와 검토하여 제거하도록 설정<br>※ /etc/group 파일과 /etc/passwd 파일을 비교하여 점검하기를 권고함 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/group, /etc/ghshadow 파일에 계정이 존재하지 않거나, 불필요한 그룹 확인
Step 2) 불필요한 그룹 제거
# groupdel <그룹 이름>
```

> ※ 해당 그룹 제거 시 그룹 권한으로 존재하는 파일이 존재하는지 확인이 필요하며, 사용자가 없는 그룹이더라도 추후 권한 할당을 위해 그룹을 먼저 생성하였을 가능성도 존재하므로 확인 필요

---

### U-10 (중) 동일한 UID 금지

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | /etc/passwd 파일 내 UID가 동일한 사용자 계정 존재 여부 점검 |
| 점검 목적 | UID가 동일한 사용자 계정을 점검함으로써 타 사용자 계정 소유의 파일 및 디렉터리로의 악의적 접근 예방 및 침해사고 시 명확한 감사 추적을 하기 위함 |
| 보안 위험 | 중복된 UID가 존재할 경우, 시스템은 동일한 사용자로 인식하여 소유자의 권한이 중복되어 불필요한 권한이 부여되며 시스템 로그를 이용한 감사 추적 시 사용자가 구분되지 않는 위험이 존재함 |
| 참고 | ※ 비밀번호 파일 수정 변경 및 신규 사용자 추가 시 UID가 동일한 계정이 존재하는지 확인해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 동일한 UID로 설정된 사용자 계정이 존재하지 않는 경우<br>**취약**: 동일한 UID로 설정된 사용자 계정이 존재하는 경우 |
| 조치 방법 | 동일한 UID를 가진 사용자 계정의 UID를 중복되지 않도록 변경하도록 설정 |
| 조치 시 영향 | 운영 목적으로 동일한 UID 값을 부여하였다면 해당 계정이 사용하고 있는 파일 및 디렉터리를 검토하여 권한이 제거되어도 서비스 영향이 없는지 확인 필요 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/passwd 파일에 동일한 UID가 존재하는지 확인
Step 2) 명령으로 중복된 UID로 변경
# usermod -u <변경할 UID> <사용자 이름>
```

> ※ AIX의 경우 chuser id=<변경할 UID> <사용자 이름> 명령어 사용

---

### U-11 (하) 사용자 shell 점검

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 로그인이 불필요한 계정(adm, sys, daemon 등)에 셀 부여 여부 점검 |
| 점검 목적 | 로그인이 불필요한 계정에 부여된 셀을 제거하여, 로그인이 필요하지 않은 계정을 통한 시스템 명령어를 실행하지 못하게 하기 위함 |
| 보안 위험 | 로그인이 불필요한 계정에 셀이 부여될 경우, 비인가자가 해당 기본 계정으로 시스템에 접근 위험이 존재함 |
| 참고 | ※ 셀(Shell): 대화형 사용자 인터페이스로써, 운영체제(OS) 가장 외과계층에 존재하여 사용자의 명령어를 이해하고 실행함<br>※ /bin/false: 시스템 접근을 항상 실패로 처리해 로그인을 차단하고, 사용자에게 메시지를 출력하지 않으며, 서비스 계정의 직접 접근 차단에 사용됨<br>※ /sbin/nologin: 로그인 시 "This account is currently not available" 메시지를 출력하며 접근을 차단하고, FTP와 같은 일부 서비스의 접근은 허용됨 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 로그인이 필요하지 않은 계정에 /bin/false(/sbin/nologin) 셀이 부여된 경우<br>**취약**: 로그인이 필요하지 않은 계정에 /bin/false(/sbin/nologin) 셀이 부여되지 않은 경우 |
| 조치 방법 | 로그인이 필요하지 않은 계정에 대해 /bin/false(/sbin/nologin) 셀 부여 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/passwd 파일을 참고하여 로그인이 불필요한 계정에 /bin/false(/sbin/nologin) 셀 부여 여부 확인
# cat /etc/passwd | grep -E "^daemon|\^bin|\^sys|\^adm|\^listen|\^nobody|\^nobody4|\^noaccess|\^diag|\^operator|\^ games|\^gopher" | grep -v admin

Step 2) 로그인이 불필요한 계정에 /bin/false 또는 /sbin/nologin 셀 부여
# usermod -s /bin/false <계정명>
# usermod -s /sbin/nologin <계정명>
```

**로그인이 불필요한 계정 목록**

```
deamon, bin, sys, adm, listen, nobody, nobody4, noaccess, diag, operator, games, gopher
```

---

### U-12 (하) 세션 종료 시간 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 사용자 쉘에 대한 환경설정 파일에서 Session Timeout 설정 여부 점검 |
| 점검 목적 | 사용자의 고의 또는 실수로 시스템에 계정이 접속된 상태로 방치됨을 차단하기 위함 |
| 보안 위험 | Session timeout 값이 설정되지 않을 경우, 유휴 시간 내 비인가자가 시스템에 접근하여 불필요한 내부 정보를 노출할 위험이 존재함 |
| 참고 | ※ Session: 프로세스를 사이에 통신을 수행하기 위해서 메시지 교환을 통해 서로를 인식한 이후부터 통신을 마칠 때까지의 시간 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: Session Timeout이 600초(10분) 이하로 설정된 경우<br>**취약**: Session Timeout이 600초(10분) 이하로 설정되지 않은 경우 |
| 조치 방법 | 600초(10분) 동안 입력이 없는 경우 접속된 Session을 골도록 설정 |
| 조치 시 영향 | 모니터링 용도일 경우 세션 타입 설정 시 모니터링 업무가 불가할 수 있으므로 예외 처리 필요 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
[sh, ksh, bash]
Step 1) /etc/profile 파일 내 TMOUT 값 설정
TMOUT=600
export TMOUT

[cs]
Step 1) /etc/csh.cshrc 또는 /etc/csh.login 파일 내 autologout 값 설정
set autologout=10
```

---

### U-13 (중) 안전한 비밀번호 암호화 알고리즘 사용

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 안전한 비밀번호 암호화 알고리즘을 사용 여부 점검 |
| 점검 목적 | 안전한 비밀번호 암호화 알고리즘을 사용하여 사용자 계정정보를 보호하기 위함 |
| 보안 위험 | 취약한 비밀번호 암호화 알고리즘을 사용할 경우, 노출된 계정에 대해 비인가자가 암호 복호화 공격을 통해 비밀번호를 획득할 위험이 존재함 |
| 참고 | ※ 비밀번호 암호화 알고리즘 저장 방식을 바꾸어도 passwd 명령을 이용하여 재설정해야 변경된 비밀번호 암호화 알고리즘이 적용되므로 취약한 비밀번호 암호화 알고리즘을 사용하고 있는 모든 계정 비밀번호 재설정 필요<br>※ 비밀번호 암호화 알고리즘: $1 : MD5 / $2 : Blowfish / $5 : SHA-256 / $6 : SHA-512 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: SHA-2 이상의 안전한 비밀번호 암호화 알고리즘을 사용하는 경우<br>**취약**: 취약한 비밀번호 암호화 알고리즘을 사용하는 경우 |
| 조치 방법 | SHA-2 이상의 안전한 비밀번호 암호화 알고리즘 적용 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) /etc/passwd 파일 내 암호화 필드 값 확인
Step 2) /etc/security/policy.conf 파일 내 CRYPT_DEFAULT 값 설정
CRYPT_DEFAULT = 5 또는 6
```

> ※ CRYPT_DEFAULT = 5: SHA-256 / 6 : SHA-512

**● LINUX**

```
[Redhat]
Step 1) /etc/shadow(또는 /etc/passwd) 파일 내 암호화 필드 값 확인
Step 2) /etc/login.defs 파일 내 ENCRYPT_METHOD 값 설정
ENCRYPT_METHOD <SHA-2 이상 암호화 알고리즘(SHA-256 또는 SHA-512)>

[Debian]
Step 1) /etc/shadow(또는 /etc/passwd) 파일 내의 암호화 필드 값 확인
Step 2) /etc/login.defs 파일 내 ENCRYPT_METHOD 값 설정
ENCRYPT_METHOD <SHA-2 이상 암호화 알고리즘(SHA-256 또는 SHA-512 또는 yescrypt)>
Step 3) /etc/pam.d/common-password 파일 내 안전한 알고리즘 설정
password[success=2 default=ignore] pam_unix.so <SHA-2 이상 암호화 알고리즘>
```

**● AIX**

```
Step 1) /etc/security/passwd 파일 내 비밀번호 암호화 알고리즘 확인
password = {<암호화 알고리즘>} <해시값>
Step 2) 안전한 암호화 알고리즘 설정
# chsec -f /etc/security/login.cfg -s usw -a pwd_algorithm=<SHA-2 이상 암호화 알고리즘(SHA-256 또는 SHA-512)>
```

> ※ /etc/security/pwdalg.cfg 파일을 참조하여 OS에서 정의된 암호화 알고리즘 확인 가능

**● HP-UX**

```
Step 1) /etc/shadow 파일 내의 암호화 필드 값 확인
Step 2) /etc/default/security 파일 내 CRYPT_DEFAULT 값 설정
CRYPT_DEFAULT = 5 또는 6
```

> ※ HP-UX 11i v2 이상이며, PHI 및 shadow password를 사용하지 않는 경우 취약
> ※ CRYPT_DEFAULT = 5: SHA-256 / 6 : SHA-512

---

## 2. 파일 및 디렉토리 관리

### U-14 (상) root 홈, 패스 디렉터리 권한 및 패스 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | root 계정의 PATH 환경변수에 ".(마침표)이 포함 여부 점검 |
| 점검 목적 | 비인가자가 불법적으로 생성한 디렉터리 및 명령어를 우선으로 실행되지 않도록 설정하기 위함 |
| 보안 위험 | root 계정의 PATH 환경변수에 정상적인 관리자 명령어(ls, mv, cp 등)의 디렉터리 경로보다 현재 디렉터리를 지정하는 "." 표시가 우선하면 현재 디렉터리에 변조된 명령어를 삽입하여 관리자 명령어 입력 시 악의적인 기능이 실행될 수 있는 위험이 존재함 |
| 참고 | ※ 환경변수: 프로세스가 컴퓨터에서 동작하는 방식에 영향을 미치는 동적인 값들의 집합으로 PATH 환경변수는 실행 파일을 찾는 경로에 대한 변수를 뜻함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: PATH 환경변수에 "." 이 맨 앞이나 중간에 포함되지 않은 경우<br>**취약**: PATH 환경변수에 "." 이 맨 앞이나 중간에 포함된 경우 |
| 조치 방법 | root 계정의 환경설정 파일(/profile, /bashrc 등)과 시스템 환경설정 파일(/etc/profile 등)에 설정된 PATH 환경변수에서 현재 디렉터리를 나타내는 "."을 PATH 환경변수의 마지막으로 이동하도록 설정 ※ /etc/profile 파일, root 계정, 일반 사용자 계정의 환경설정 파일을 순차적으로 검색하여 확인 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) PATH 환경변수 확인
# echo $PATH

Step 2) 환경설정 파일 내 PATH 변수값 수정
PATH=$PATH:$HOME/bin:<상대 경로> 또는 상대 경로 삭제
```

| Shell 종류별 환경설정 파일 |
| :--- |
| Bourne Shell(sh) /etc/profile, $HOME/.profile |
| C Shell(csh) /etc/csh.cshrc, /etc/csh.login, $HOME/.cshrc, $HOME/.login |
| Korn Shell(ksh) /etc/profile, $HOME/.profile, $HOME/.kshrc |
| Bash Shell(bash) /etc/profile, $HOME/.bash_profile, $HOME/.bashrc, /etc/bash.bashrc |

---

### U-15 (상) 파일 및 디렉터리 소유자 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 소유자가 존재하지 않는 파일 및 디렉터리의 존재 여부 점검 |
| 점검 목적 | 소유자가 존재하지 않는 파일 및 디렉터리를 제거 또는 관리하여 임의의 사용자가 해당 파일을 열람, 수정하는 행위를 사전에 차단하기 위함 |
| 보안 위험 | 소유자가 존재하지 않는 파일의 UID와 동일한 값으로 특정 계정의 UID를 변경하면 해당 파일의 소유자가 되어 모든 작업이 가능한 위험이 존재함 |
| 참고 | ※ 소유자가 존재하지 않는 파일 및 디렉터리는 일반적으로 퇴직자의 자료, 관리 소홀로 인해 생긴 파일 또는 해당으로 인한 공격자가 만들어 놓은 악의적인 파일임 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 소유자가 존재하지 않는 파일 및 디렉터리가 존재하지 않는 경우<br>**취약**: 소유자가 존재하지 않는 파일 및 디렉터리가 존재하는 경우 |
| 조치 방법 | 소유자가 존재하지 않는 파일 및 디렉터리 제거 또는 소유자 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) 소유자와 그룹이 존재하지 않는 파일 및 디렉터리 확인
# find / \ (-nouser -o -nogroup \) -xdev -ls 2>/dev/null

Step 2) 소유자가 존재하지 않는 파일 또는 디렉터리 제거
# rm <파일 이름>
# rm -r <디렉터리 이름>

Step 3) 사용 중인 파일 및 디렉터리의 경우 소유자 및 그룹 변경
# chown <사용자 이름> <파일 및 디렉터리 이름>
# chgrp <그룹 이름> <파일 및 디렉터리 이름>
```

> ※ 소유자 또는 그룹이 존재하지 않는 파일은 파일 속성의 해당 필드에 UID, GID가 숫자로 표시됨

---

### U-16 (상) /etc/passwd 파일 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | /etc/passwd 파일 권한 적절성 여부 점검 |
| 점검 목적 | /etc/passwd 파일을 관리자만 제어할 수 있게 하여 비인기자들의 임의적인 파일 번조를 방지하기 위함 |
| 보안 위험 | 비인기자가 /etc/passwd 파일의 사용자 정보를 변조하여 Shell 변경, 사용자 추가/제거 등 root 계정을 포함한 사용자 권한 획득 위험이 존재함 |
| 참고 | ※ /etc/passwd: 사용자의 ID, UID, GID, 홈 디렉터리, 쉘 정보를 담고 있는 파일 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: /etc/passwd 파일의 소유자가 root이고, 권한이 644 이하인 경우<br>**취약**: /etc/passwd 파일의 소유자가 root가 아니거나, 권한이 644 이하가 아닌 경우 |
| 조치 방법 | /etc/passwd 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/passwd 파일 소유자 및 권한 확인
# ls -l /etc/passwd

Step 2) /etc/passwd 파일 소유자 및 권한 변경
# chown root /etc/passwd
# chmod 644 /etc/passwd
```

---

*(Part 1 끝. 다음 Part 2에서 U-17부터 이어집니다.)*