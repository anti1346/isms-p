### U-17 (상) 시스템 시작 스크립트 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 시스템 시작 스크립트 파일 권한 적절성 여부 점검 |
| 점검 목적 | 시스템 시작 스크립트 파일을 관리자만 제어할 수 있게 하여 비인가자들의 임의적인 파일 변조를 방지하기 위함 |
| 보안 위험 | 시스템 시작 스크립트 파일의 소유권 및 권한 설정이 미흡할 경우, 비인가자가 스크립트의 내용 변경 등을 통해 시스템 침입 등 악용할 위험이 존재함 |
| 참고 | ※ 시스템 시작 스크립트: 운영체제 부팅 시 자동으로 실행되어 시스템 초기화 작업을 수행하고, 필요한 서비스와 대응을 시작하는 스크립트 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 시스템 시작 스크립트 파일의 소유자가 root이고, 일반 사용자의 쓰기 권한이 제거된 경우<br>**취약**: 시스템 시작 스크립트 파일의 소유자가 root가 아니거나, 일반 사용자의 쓰기 권한이 부여된 경우 |
| 조치 방법 | 시스템 시작 스크립트 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) 시스템 시작 스크립트 파일 소유자 및 권한 확인
# ls -al 'readlink -f /etc/rc*.d/ | sed 's/$/*/'

Step 2) 시스템 시작 스크립트 파일 소유자 및 권한 변경
# chown root <파일 이름>
# chmod o-w <파일 이름>
```

**● LINUX**

```
[init]
Step 1) 시스템 시작 스크립트 파일 소유자 및 권한 확인
# ls -al 'readlink -f /etc/rc.d/*/* | sed 's/$/*/'

Step 2) 시스템 시작 스크립트 파일 소유자 및 권한 변경
# chown root <파일 이름>
# chmod o-w <파일 이름>

[systemd]
Step 1) 시스템 시작 스크립트 파일 소유자 및 권한 확인
# ls -al `readlink -f /etc/systemd/system/* | sed ‘s/\(\)*’/’

Step 2) 시스템 시작 스크립트 파일 소유자 및 권한 변경
# chown root /etc/systemd/system/<파일 이름>
# chmod o-w /etc/systemd/system/<파일 이름>
```

**● AIX**

```
Step 1) 시스템 시작 스크립트 파일 소유자 및 권한 확인
# find /etc/rc.d/*/* -type l -exec ls -l {} +

Step 2) 시스템 시작 스크립트 파일 소유자 및 권한 변경
# chown root <파일 이름>
# chmod o-w <파일 이름>
```

**● HP-UX**

```
Step 1) 시스템 시작 스크립트 파일 소유자 및 권한 확인
# find /sbin/rc*.d/ -type l -exec ls -l {} +

Step 2) 시스템 시작 스크립트 파일 소유자 및 권한 변경
# chown root <파일 이름>
# chmod o-w <파일 이름>
```

---

### U-18 (상) /etc/shadow 파일 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | /etc/shadow 파일 권한 적절성 여부 점검 |
| 점검 목적 | /etc/shadow 파일을 관리자만 제어할 수 있게 하여 비인가자들의 임의적인 파일 변조를 방지하기 위함 |
| 보안 위험 | /etc/shadow 파일에 저장된 암호화된 해시값을 복호화하여(크래킹) 비밀번호를 탈취할 위험이 존재함 |
| 참고 | ※ /etc/shadow: 시스템에 등록된 모든 계정의 비밀번호를 암호화된 형태로 저장 및 관리하는 파일 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: /etc/shadow 파일의 소유자가 root이고, 권한이 400 이하인 경우<br>**취약**: /etc/shadow 파일의 소유자가 root가 아니거나, 권한이 400 이하가 아닌 경우 |
| 조치 방법 | /etc/shadow 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향을 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX**

```
Step 1) /etc/shadow 파일 소유자 및 권한 변경
# chown root /etc/shadow
# chmod 400 /etc/shadow
```

**● AIX**

```
Step 1) /etc/security/passwd 파일 소유자 및 권한 변경
# chown root /etc/security/passwd
# chmod 400 /etc/security/passwd
```

**● HP-UX**

```
Step 1) /tcbfiles/auth/ 디렉터리 소유자 및 권한 변경
# chown root /tcbfiles/auth
# chmod 400 /tcbfiles/auth
```

---

### U-19 (상) /etc/hosts 파일 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | /etc/hosts 파일의 권한 적절성 여부 점검 |
| 점검 목적 | /etc/hosts 파일을 관리자만 제어할 수 있게 하여 비인가자들의 임의적인 파일 변조를 방지하기 위함 |
| 보안 위험 | • /etc/hosts 파일에 비인가자가 쓰기 권한이 부여된 경우, 공격자는 /etc/hosts 파일에 악의적인 시스템을 등록하여, 이를 통해 정상적인 DNS를 우회하여 악성 사이트로의 접속을 유도하는 파일(Pharming) 공격 등에 악용될 수 있는 위험이 존재함<br>• /etc/hosts 파일에 소유자의 쓰기 권한이 부여된 경우, 일반 사용자 권한으로 /etc/hosts 파일에 변조된 IP주소를 등록하여 정상적인 DNS를 방해하고 악성 사이트로의 접속을 유도하는 파일(Pharming) 공격 등에 악용될 수 있는 위험이 존재함 |
| 참고 | ※ /etc/hosts: IP주소와 호스트 이름을 매핑하는 파일. 일반적으로 인터넷 통신 시 주소를 찾기 위해 도메인 네임 서비스(DNS)보다 /etc/hosts 파일을 먼저 참조함. /etc/hosts 파일은 문자열 주소로부터 IP주소를 수신받는 DNS 서버와는 달리 파일 내에 직접 문자열 주소와 IP주소를 매핑하여 기록하며, DNS 서버 접근 이전에 확인하여 해당 문자열 주소가 목록에 존재할 시 그 문자열 주소에 해당하는 IP주소로 연결함<br>※ 파일(Pharming): 사용자의 DNS 또는 /etc/hosts 파일을 변조함으로써 정상적인 사이트로 오인하여 접속하도록 유도한 뒤 개인정보를 훔치는 새로운 컴퓨터 범죄 수법 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: /etc/hosts 파일의 소유자가 root이고, 권한이 644 이하인 경우<br>**취약**: /etc/hosts 파일의 소유자가 root가 아니거나, 권한이 644 이하가 아닌 경우 |
| 조치 방법 | /etc/hosts 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | /etc/hosts 파일에 시스템 정보가 설정된 경우 해당 파일을 참조하는 서비스에 영향을 미칠 수 있음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/hosts 파일 소유자 및 권한 변경
# chown root /etc/hosts
# chmod 644 /etc/hosts
```

---

### U-20 (상) /etc(/x)inetd.conf 파일 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | /etc(/x)inetd.conf 파일 권한 적절성 여부 점검 |
| 점검 목적 | /etc(/x)inetd.conf 파일을 관리자만 제어하여 비인가자들의 임의적인 파일 변조를 방지하기 위함 |
| 보안 위험 | /etc(/x)inetd.conf 파일에 소유자 외 쓰기 권한이 부여된 경우, 일반 사용자 권한으로 해당 파일에 등록된 서비스를 변조하거나 악의적인 프로그램(서비스)을 등록할 수 있는 위험이 존재함 |
| 참고 | ※ (x)inetd(슈퍼데몬): 자주 사용하지 않는 서비스가 상시 실행되어 메모리를 점유하는 것을 방지하기 위해 (x)inetd(슈퍼데몬)에 자주 사용하지 않는 서비스를 등록하여 요청이 있을 시에만 해당 서비스를 실행하고 요청이 끝나면 서비스를 종료하는 역할 수행 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: /etc(/x)inetd.conf 파일의 소유자가 root이고, 권한이 600 이하인 경우<br>**취약**: /etc(/x)inetd.conf 파일의 소유자가 root가 아니거나, 권한이 600 이하가 아닌 경우 |
| 조치 방법 | /etc(/x)inetd.conf 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, AIX, HP-UX**

```
Step 1) /etc/inetd.conf 파일 소유자 및 권한 변경
# chown root /etc/inetd.conf
# chmod 600 /etc/inetd.conf
```

**● LINUX**

```
[inetd]
Step 1) /etc/inetd.conf 파일 소유자 및 권한 변경
# chown root /etc/inetd.conf
# chmod 600 /etc/inetd.conf

[xinetd]
Step 1) /etc/xinetd.conf 파일 소유자 및 권한 변경
# chown root /etc/xinetd.conf
# chmod 600 /etc/xinetd.conf

Step 2) /etc/xinetd.d/ 디렉터리 내 모든 파일의 소유자 및 권한 변경
# chown -R root /etc/xinetd.d/
# chmod - R 600 /etc/xinetd.d/

[systemd]
Step 1) /etc/systemd/system.conf 파일 소유자 및 권한 변경
# chown root /etc/systemd/system.conf
# chmod 600 /etc/systemd/system.conf

Step 2) /etc/systemd/ 디렉터리 내 모든 파일의 소유자 및 권한 변경
# chown -R root /etc/systemd/
# chmod - R 600 /etc/systemd/
```

---

### U-21 (상) /etc/(r)syslog.conf 파일 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | /etc/(r)syslog.conf 파일 권한 적절성 여부 점검 |
| 점검 목적 | /etc/(r)syslog.conf 파일의 권한 적절성을 점검하여, 비인가자의 임의적인 /etc/(r)syslog.conf 파일 변조를 방지하기 위한 |
| 보안 위험 | /etc/(r)syslog.conf 파일의 설정 내용을 참조하여 로그의 저장 위치가 노출되며 로그를 기록하지 않도록 설정하거나 대량의 로그를 기록하기 하여 시스템 파부하를 유도할 수 있는 위험이 존재함 |
| 참고 | ※ /etc/(r)syslog.conf: (r)syslogd 데몬 실행 시 참조되는 설정 파일로 시스템 로그 기록의 종류, 위치 및 Level을 설정할 수 있음 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: /etc/(r)syslog.conf 파일의 소유자가 root(또는 bin, sys)이고, 권한이 640 이하인 경우<br>**취약**: /etc/(r)syslog.conf 파일의 소유자가 root(또는 bin, sys)가 아니거나, 권한이 640 이하가 아닌 경우 |
| 조치 방법 | /etc/(r)syslog.conf 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/(r)syslog.conf 파일 소유자 및 권한 변경
# chown root /etc/(r)syslog.conf
# chmod 640 /etc/(r)syslog.conf
```

---

### U-22 (상) /etc/services 파일 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | /etc/services 파일 권한 적절성 여부 점검 |
| 점검 목적 | /etc/services 파일을 관리자만 제어할 수 있게 하여 비인기자들의 임의적인 파일 변조를 방지하기 위함 |
| 보안 위험 | /etc/services 파일의 접근 권한이 적절하지 않을 경우, 비인가 사용자가 운영 포트 번호를 변경하여 정상적인 서비스를 제한하거나 허용되지 않은 포트를 오픈하여 악성 서비스를 의도적으로 실행할 수 있는 위험이 존재함 |
| 참고 | ※ /etc/services: 서비스 관리를 위해 사용되는 파일. 해당 파일에 서버에서 사용하는 모든 포트에 대해 정의되어 있으며, 필요시 서비스 기본 사용 포트를 변경하여 네트워크 서비스를 운용할 수 있음 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: /etc/services 파일의 소유자가 root(또는 bin, sys)이고, 권한이 644 이하인 경우<br>**취약**: /etc/services 파일의 소유자가 root(또는 bin, sys)가 아니거나, 권한이 644 이하가 아닌 경우 |
| 조치 방법 | /etc/services 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/services 파일 소유자 및 권한 변경
# chown root /etc/services
# chmod 644 /etc/services
```

---

### U-23 (상) SUID, SGID, Sticky bit 설정 파일 점검

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 불필요하거나 악의적인 파일에 SUID, SGID, Sticky bit 설정 여부 점검 |
| 점검 목적 | 불필요한 SUID, SGID, Sticky bit 설정 제거로 악의적인 사용자의 권한 상승을 방지하기 위함 |
| 보안 위험 | SUID, SGID, Sticky bit 설정이 적절하지 않을 경우, SUID, SGID, Sticky bit가 설정된 파일로 특정 명령어를 실행하여 root 권한 획득이 가능한 위험이 존재함 |
| 참고 | ※ SUID: 설정된 파일 실행 시, 특정 작업 수행을 위하여 일시적으로 파일 소유자의 권한을 얻게 됨<br>※ SGID: 설정된 파일 실행 시, 특정 작업 수행을 위하여 일시적으로 파일소유 그룹의 권한을 얻게 됨<br>※ Sticky bit: 설정된 파일의 수정/삭제는 소유자만 가능한 권한 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 주요 실행 파일의 권한에 SUID와 SGID에 대한 설정이 부여되어 있지 않은 경우<br>**취약**: 주요 실행 파일의 권한에 SUID와 SGID에 대한 설정이 부여된 경우 |
| 조치 방법 | • 불필요한 SUID, SGID 권한 또는 해당 파일 제거하도록 설정<br>• 애플리케이션에서 생성한 파일이나 사용자가 임의로 생성한 파일 등 의심스럽거나 특이한 파일에 SUID 권한이 부여된 경우 제거하도록 설정 |
| 조치 시 영향 | SUID, SGID, Sticky bit 설정 파일 제거 시, OS 및 응용프로그램 등 서비스 정상 작동 확인 필요 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) SUID, SGID가 설정된 파일 확인
# find / -user root -type f \( -perm -04000 -o -perm -02000 \)-xdev -exec ls -al {} \;

Step 2) 불필요한 특수 권한 제거
# chmod -s <파일 이름>

Step 3) 반드시 사용이 필요한 경우 특정 그룹에서만 사용하도록 제한하여 일반 사용자의 Setuid 사용 제한
# chgrp <그룹 이름> <SUID를 설정할 파일>
# chmod 4750 <SUID를 설정할 파일>
```

---

### U-24 (상) 사용자, 시스템 환경변수 파일 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 홈 디렉터리 내의 환경변수 파일에 대한 소유자 및 접근 권한이 관리자 또는 해당 계정으로 설정 여부 점검 |
| 점검 목적 | 비인가자의 환경변수 조작으로 인한 보안 위험이 존재함 |
| 보안 위험 | 홈 디렉터리 내의 사용자 파일 및 사용자별 시스템 시작 파일 등과 같은 환경변수 파일의 접근 권한 설정이 적절하지 않을 경우, 비인가자가 환경변수 파일을 변조하여 정상 사용 중인 사용자의 서비스가 제한될 수 있는 위험이 존재함 |
| 참고 | ※ 환경변수 파일 종류: .profile, .kshrc, .cshrc, .bashrc, .bash_profile, .login, .exrc, .netrc 등 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되어 있고, 홈 디렉터리 환경변수 파일이 root 계정과 소유자만 쓰기 권한이 부여된 경우<br>**취약**: 홈 디렉터리 환경변수 파일 소유자가 root 또는 해당 계정으로 지정되지 않거나, 홈 디렉터리 환경변수 파일이 root 계정과 소유자 외에 쓰기 권한이 부여된 경우 |
| 조치 방법 | 환경변수 파일의 일반 사용자 쓰기 권한 제거하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) 홈 디렉터리 환경변수 파일 소유자 및 권한 확인
# ls -l<홈 디렉터리 환경변수 파일>

환경변수 파일 종류: .profile, .kshrc, .cshrc, .bashrc, .bash_profile, .login, .exrc, .netrc 등

Step 2) 홈 디렉터리 환경변수 파일 소유자 및 권한 변경
# chown <root 또는 파일 소유자> <홈 디렉터리 환경변수 파일>
# chmod o-w <홈 디렉터리 환경변수 파일>
```

---

### U-25 (상) world writable 파일 점검

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 불필요한 world writable 파일 여부 점검 |
| 점검 목적 | world writable 파일을 이용한 시스템 접근 및 악의적인 코드 실행을 방지하기 위함 |
| 보안 위험 | 시스템 파일과 같은 중요 파일에 world writable이 적용될 경우, 일반 사용자 및 비인가자가 해당 파일을 임의로 수정, 제거할 위험이 존재함 |
| 참고 | ※ world writable 파일: 모든 사용자에게 쓰기 권한이 부여된 파일 (예시: -rwxrwxrwx root root (파일명)) |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: world writable 파일이 존재하지 않거나, 존재 시 설정 이유를 인지하고 있는 경우<br>**취약**: world writable 파일이 존재하나 설정 이유를 인지하지 못하고 있는 경우 |
| 조치 방법 | world writable 파일 존재 여부를 확인하고 불필요한 경우 제거하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
[일반 사용자 쓰기 권한 제거]
Step 1) world writable 파일 확인
# find / -type f -perm -2 -exec ls -l {} \;

Step 2) 일반 사용자 쓰기 권한 제거
# chmod o-w <파일 이름>

Step 3) 불필요한 world writable 파일 제거
# rm <파일 이름>
```

---

### U-26 (상) /dev에 존재하지 않는 device 파일 점검

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 허용할 호스트에 대한 접속 IP주소 제한 및 포트 제한 설정 여부 점검 |
| 점검 목적 | 허용한 호스트만 서비스를 사용하게 하여 서비스 취약점을 이용한 외부자 공격을 방지하기 위함 |
| 보안 위험 | 공격자는 rootkit 설정 파일들을 서버 관리자가 쉽게 발견하지 못하도록 /dev 디렉터리에 device 파일인 것처럼 위장하는 수법을 사용하는 위험이 존재함 |
| 참고 | ※ /dev 디렉터리: 논리적 장치 파일을 담고 있는 디렉터리이며 /devices 디렉터리에 있는 물리적 장치 파일에 대한 심볼릭 링크임. 예를 들어 rm0를 rm0로 잘못 입력한 경우, rm0 파일이 새로 생성되는 것과 같이 디바이스 이름 입력 오류 시 root 파일 시스템이 에러를 일으킬 때까지 /dev 디렉터리에 계속해서 파일을 생성함<br>※ /dev 디렉터리 내 mqueue, shm 파일은 시스템에서 생성 또는 제거가 주기적으로 일어나므로 예외 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: /dev 디렉터리에 대한 파일 점검 후 존재하지 않는 device 파일을 제거한 경우<br>**취약**: /dev 디렉터리에 대한 파일 미점검 또는 존재하지 않는 device 파일을 방지한 경우 |
| 조치 방법 | major, minor number를 가지지 않는 device 파일 제거하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /dev 디렉터리 내 불필요하거나 존재하지 않는 device 파일 확인 및 삭제
# find /dev -type f -exec ls -l {} \;
# rm <파일 이름>
```

---

### U-27 (상) $HOME/.rhosts, hosts.equiv 사용 금지

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | $HOME/.rhosts 및 /etc/hosts.equiv 파일에 대해 적절한 소유자 및 접근 권한 설정 여부 점검 |
| 점검 목적 | r-command를 통한 별도의 인증 없는 관리자 권한 원격 접속을 차단하기 위함 |
| 보안 위험 | • r-command(rlogin, rsh 등)에 보안 설정이 적용되지 않을 경우, 원격지의 공격자가 관리자 권한으로 목표 시스템상 임의의 명령을 수행시킬 수 있으며, 명령어 원격실행을 통해 중요 정보유출 및 시스템 장애를 유발 또는 공격자의 백도어 등으로도 활용될 수 있는 위험이 존재함<br>• 해당 파일은 r-command 서비스의 접근통제에 관련된 파일이며, 권한 설정이 부적절한 경우 r-command 서비스 사용 권한을 임의로 등록하여 무단 사용 위험이 존재함 |
| 참고 | ※ /etc/hosts.equiv: 서버 설정 파일<br>※ $HOME/.rhosts: 개별 사용자의 설정 파일<br>※ ++: 모든 호스트의 계정 신뢰<br>※ + (사용자 이름): 모든 호스트의 해당 사용자 계정 신뢰<br>※ (호스트 이름) +: 해당 호스트의 모든 계정 신뢰 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: rlogin, rsh, rexec 서비스를 사용하지 않거나, 사용 시 아래와 같은 설정이 적용된 경우<br>1. /etc/hosts.equiv 및 $HOME/.rhosts 파일 소유자가 root 또는 해당 계정인 경우<br>2. /etc/hosts.equiv 및 $HOME/.rhosts 파일 권한이 600 이하인 경우<br>3. /etc/hosts.equiv 및 $HOME/.rhosts 파일 설정에 "+" 설정이 없는 경우<br>**취약**: rlogin, rsh, rexec 서비스를 사용하며 아래와 같은 설정이 적용되지 않은 경우<br>1. /etc/hosts.equiv 및 $HOME/.rhosts 파일 소유자가 root 또는 해당 계정이 아닌 경우<br>2. /etc/hosts.equiv 및 $HOME/.rhosts 파일 권한이 600을 초과한 경우<br>3. /etc/hosts.equiv 및 $HOME/.rhosts 파일 설정에 "+" 설정이 존재하는 경우 |
| 조치 방법 | /etc/hosts.equiv, $HOME/.rhosts 파일 소유자 및 권한 변경, 허용 호스트 및 계정 등록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/hosts.equiv, $HOME/.rhosts 파일 소유자 및 권한 변경
# chown <root 또는 해당 계정> /etc/hosts.equiv
# chmod 600 /etc/hosts.equiv
# chown <root 또는 해당 계정> $HOME/.rhosts
# chmod 600 $HOME/.rhosts

Step 2) /etc/hosts.equiv, $HOME/.rhosts 파일 내 “+” 옵션이 부여된 계정 확인
Step 3) /etc/hosts.equiv, vi $HOME/.rhosts 파일 내 “+” 옵션 제거 후 허용 호스트 및 계정 등록
```

---

### U-28 (상) 접속 IP 및 포트 제한

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 허용할 호스트에 대한 접속 IP주소 제한 및 포트 제한 설정 여부 점검 |
| 점검 목적 | 허용한 호스트만 서비스를 사용하게 하여 서비스 취약점을 이용한 외부자 공격을 방지하기 위함 |
| 보안 위험 | 허용할 호스트에 대한 IP 및 포트 제한이 적용되지 않을 경우, Telnet, FTP 같은 보안에 취약한 네트워크 서비스를 통하여 불법적인 접근 및 시스템 침해사고가 발생할 수 있는 위험이 존재함 |
| 참고 | ※ TCP Wrapper: 네트워크 서비스에 관련한 트래픽을 제어하고 모니터링할 수 있는 UNIX 기반의 방화벽 툴<br>※ IPFilter: 유닉스 계열에서 사용하는 공개형 방화벽 프로그램으로써 Packet Filter로 시스템 및 네트워크 보안에 아주 강력한 기능을 보유한 프로그램<br>※ IPtables: 리눅스 커널 방화벽이 제공하는 테이블들과 그것을 저장하는 체인, 규칙들을 구성할 수 있게 해주는 응용프로그램 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 접속을 허용할 특정 호스트에 대한 IP주소 및 포트 제한을 설정한 경우<br>**취약**: 접속을 허용할 특정 호스트에 대한 IP주소 및 포트제한을 설정하지 않은 경우 |
| 조치 방법 | OS에 기본으로 제공하는 방화벽 애플리케이션이나 TCP Wrapper와 같은 호스트별 서비스 제한 애플리케이션을 사용하여 접근 허용 IP 등록 설정 |
| 조치 시 영향 | 허용되지 않은 IP는 서비스 사용이 불가함 |

#### 점검 및 조치 사례

**● SOLARIS**

```
[TCP Wrapper]
Step 1) TCP Wrapper에 설정된 접근제한 확인
Step 2) 서비스 차단 및 허용 설정값 수정
# vi /etc/hosts.deny
ALL:ALL

# vi /etc/hosts.allow
<허용할 서비스>: <허용할 IP주소>
예시) sshd : 192.168.18.129, 192.168.18.180
```

> ※ TCP Wrapper 접근제어 가능 서비스 : SYSTAT, FINGER, FTP, TELNET, RLOGIN, RSH, TALK, EXEC, TFTP, SSH
> ※ hosts.allow, hosts.deny 두 파일이 존재하지 않는 경우 모든 접근을 허용함

```
[Packet Filter]
Step 1) Packet Filter에 설정된 접근제한 확인 및 수정
Step 2) /etc/firewall/pf.conf 파일에 허용할 IP 및 포트 정책 추가
예시) SSH 서비스 제한
# pass in quick proto tcp from 192.168.1.0/24 to any port = 22 keep state
# block in quick proto tcp from any to any port = 22 keep state

Step 3) 설정한 접근제한 정책 적용
# svcadm refresh svc:/network/firewall:default
```

**● LINUX**

```
[TCP Wrapper]
Step 1) TCP Wrapper에 설정된 접근제한 확인
Step 2) 서비스 차단 및 허용 설정값 수정
# vi /etc/hosts.deny
ALL:ALL

# vi /etc/hosts.allow
<허용할 서비스> : <허용할 IP주소>
예시) sshd : 192.168.18.129, 192.168.18.180
```

> ※ TCP Wrapper 접근제어 가능 서비스 : SYSTAT, FINGER, FTP, TELNET, RLOGIN, RSH, TALK, EXEC, TFTP, SSH
> ※ hosts.allow, hosts.deny 두 파일이 존재하지 않는 경우 모든 접근을 허용함

```
[Iptables]
Step 1) Iptables에 설정된 접근제한 확인
# iptables -L

Step 2) Iptables에 허용할 IP 및 포트 정책 추가
# iptables -A INPUT -p <프로토콜> -s <IP주소> --dport <목적지 포트> -j ACCEPT

Step 3) 설정한 접근제한 정책 적용
# iptables-save
```

```
[Firewall]
Step 1) Firewall에 설정된 접근제한 확인
# firewall-cmd --list-all

Step 2) 허용할 IP 및 포트 정책 추가
# firewall-cmd --permanent --add-rich-rule="rule family="ipv4" source address="<IP주소>" port protocol ="<프로토콜>" port="<포트 번호>" accept"

Step 3) 설정한 접근제한 정책 적용
# firewall-cmd --reload
```

```
[UFW]
Step 1) UFW에 설정된 접근제한 확인
# ufw status numbered

Step 2) 허용할 IP 및 포트 정책 추가
# ufw allow from <IP주소> to any <포트 번호>

Step 3) 설정한 접근제한 정책 적용
# ufw reload
```

**● AIX**

```
[TCP Wrapper]
Step 1) TCP Wrapper에 설정된 접근제한 확인
Step 2) 서비스 차단 및 허용 설정값 수정
# vi /etc/hosts.deny
ALL:ALL

# vi /etc/hosts.allow
<허용할 서비스> : <허용할 IP주소>
예시) sshd : 192.168.18.129, 192.168.18.180
```

> ※ TCP Wrapper 접근제어 가능 서비스 : SYSTAT, FINGER, FTP, TELNET, RLOGIN, RSH, TALK, EXEC, TFTP, SSH
> ※ hosts.allow, hosts.deny 두 파일이 존재하지 않는 경우 모든 접근을 허용함

```
[IPfilter]
Step 1) IPfilter에 설정된 접근제한 확인 및 수정
# vi /etc/ipf/ipf.conf

Step 2) /etc/ipf/ipf.conf 파일에 허용할 IP 및 포트 정책 추가
예시) SSH 서비스 제한
# pass in quick proto tcp from 192.168.1.0/24 to any port = 22 keep state
# block in quick proto tcp from any to any port = 22 keep state

Step 3) IPfilter 서비스 재시작
```

**● HP-UX**

```
[/var/adm/inetd.sec]
Step 1) inetd.sec에 설정된 접근제한 확인 및 수정
# vi /var/adm/inetd.sec

Step 2) 아래와 같이 수정 또는 삽입
특정 서비스로의 모든 IP 접근 차단 시 : <서비스> deny *.*.*.*
특정 서비스로의 일부 IP 접근 허용 시 : <서비스> allow < 접속을 허용할 IP주소>

[TCP Wrapper]
Step 1) TCP Wrapper에 설정된 접근제한 확인
Step 2) 서비스 차단 및 허용 설정값 수정
# vi /etc/hosts.deny
ALL:ALL

# vi /etc/hosts.allow
<허용할 서비스>: <허용할 IP주소>
예시) sshd : 192.168.18.129, 192.168.18.180
```

> ※ TCP Wrapper 접근제어 가능 서비스 : SYSTAT, FINGER, FTP, TELNET, RLOGIN, RSH, TALK, EXEC, TFTP, SSH
> ※ hosts.allow, hosts.deny 두 파일이 존재하지 않는 경우 모든 접근을 허용함

```
[IPfilter]
Step 1) IPfilter에 설정된 접근제한 확인
Step 2) /etc/ipf/ipf.conf 파일에 허용할 IP 및 포트 정책 추가
예시) SSH 서비스 제한
# pass in quick proto tcp from 192.168.1.0/24 to any port = 22 keep state
# block in quick proto tcp from any to any port = 22 keep state

Step 3) IPfilter 서비스 재시작
```

---

### U-29 (하) hosts.lpd 파일 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | /etc/hosts.lpd 파일의 제거 및 권한 적절성 여부 점검 |
| 점검 목적 | 비인가자의 임의적인 /etc/hosts.lpd 변조를 막기 위해 /etc/hosts.lpd 파일 제거 또는 소유자 및 권한 관리하기 위함 |
| 보안 위험 | /etc/hosts.lpd 파일의 접근 권한이 적절하지 않을 경우, 비인가자가 /etc/hosts.lpd 파일을 수정하여 허용된 사용자의 서비스를 방해할 수 있으며, 호스트 정보를 획득할 수 있는 위험이 존재함 |
| 참고 | ※ /etc/hosts.lpd 파일: 로컬 프린트 서비스를 사용할 수 있는 허가된 호스트(사용자) 정보를 담고 있는 파일 (hostname 또는 IP주소를 포함하고 있음) |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: /etc/hosts.lpd 파일이 존재하지 않거나, 불가피하게 사용 시 /etc/hosts.lpd 파일의 소유자가 root이고, 권한이 600 이하인 경우<br>**취약**: /etc/hosts.lpd 파일이 존재하며, 파일의 소유자가 root가 아니거나, 권한이 600 이하가 아닌 경우 |
| 조치 방법 | /etc/hosts.lpd 파일 제거 또는 /etc/hosts.lpd 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/hosts.lpd 파일 소유자 및 권한 확인 및 수정
# ls -l /etc/hosts.lpd
# chown root /etc/hosts.lpd
# chmod 600 /etc/hosts.lpd
```

---

### U-30 (중) UMASK 설정 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 시스템 UMASK 값이 022 이상 설정 여부 점검 |
| 점검 목적 | 잘못 설정된 UMASK 값으로 인해 신규 파일에 대한 권한이 과도하게 부여되는 것을 방지하기 위함 |
| 보안 위험 | 잘못 설정된 UMASK로 인해 파일 및 디렉터리 생성 시 과도한 권한이 부여되어 무단 액세스 및 데이터 유출의 위험이 존재함 |
| 참고 | ※ UMASK: 파일 및 디렉터리 생성 시 기본 권한을 지정해 주는 명령어<br>※ 시스템 내에서 사용자가 새로 생성하는 파일의 접근 권한은 UMASK 값에 따라 정해지며, 계정의 환경설정 파일에 설정을 변경하면 사용자가 로그인한 후에도 변경된 UMASK 값을 적용받게 됨<br>※ Start Profile: /etc/profile, /etc/default/login, .cshrc, .kshrc, .bashrc, .login, .profile 등 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: UMASK 값이 022 이상으로 설정된 경우<br>**취약**: UMASK 값이 022 미만으로 설정된 경우 |
| 조치 방법 | 설정 파일에 UMASK 값을 022로 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
[/etc/profile]
Step 1) /etc/profile 파일 내 UMASK 설정 확인 및 수정
# vi /etc/profile
umask 022
export umask

[/etc/default/login]
Step 1) /etc/default/login 파일 내 UMASK 설정 확인 및 수정
# vi /etc/default/login
UMASK=022
```

**● LINUX**

```
[/etc/profile]
Step 1) /etc/profile 파일 내 UMASK 설정 확인 및 수정
# vi /etc/profile
umask 022
export umask

[/etc/login.defs]
Step 1) /etc/login.defs 파일 내 UMASK 설정 확인 및 수정
# vi /etc/login.defs
UMASK 022
```

**● AIX**

```
[/etc/profile]
Step 1) /etc/profile 파일 내 UMASK 설정 확인 및 수정
# vi /etc/profile
umask 022
export umask

[/etc/security/user]
Step 1) /etc/security/user 파일 내 UMASK 설정 확인 및 수정
# vi /etc/security/user
default : umask = 022 또는 <사용자 이름> : umask = 022
```

**● HP-UX**

```
[/etc/profile]
Step 1) /etc/profile 파일 내 UMASK 설정 확인 및 수정
# vi /etc/profile
umask 022
export umask

[/etc/default/secureitz]
```

---

### U-31 (중) 홈디렉토리 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 홈 디렉토리의 소유자 외 타 사용자가 해당 홈 디렉토리를 수정할 수 없도록 제한 설정 여부 점검 |
| 점검 목적 | 사용자 홈 디렉토리 내 설정 파일이 비인가자에 의한 변조를 방지하기 위함 |
| 보안 위험 | 홈 디렉토리 내 설정 파일 변조 시 정상적인 서비스 이용이 제한될 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 홈 디렉토리 소유자가 해당 계정이고, 타 사용자 쓰기 권한이 제거된 경우<br>**취약**: 홈 디렉토리 소유자가 해당 계정이 아니거나, 타 사용자 쓰기 권한이 부여된 경우 |
| 조치 방법 | 사용자별 홈 디렉토리 소유주를 해당 계정으로 변경하고, 타 사용자의 쓰기 권한 제거하도록 설정 (/etc/passwd 파일에서 홈 디렉토리 확인, 사용자 홈 디렉토리 외 개별적으로 만들어 사용하는 사용자 디렉토리 존재 여부 확인하여 점검) |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) 사용자별 홈 디렉토리 확인
# cat /etc/passwd

Step 2) 사용자별 홈 디렉토리 소유자 및 권한 확인
# ls -ald <사용자 홈 디렉토리>

Step 3) 사용자별 홈 디렉토리 소유자를 해당 사용자로 변경 및 일반 사용자 권한 제거
# chown <사용자 이름> <사용자 홈 디렉토리>
# chmod o-w <사용자 홈 디렉토리>
```

---

### U-32 (중) 홈 디렉토리로 지정한 디렉토리의 존재 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 사용자 계정과 홈 디렉토리의 일치 여부 점검 |
| 점검 목적 | /home 디렉토리 이외의 사용자의 홈 디렉토리 존재 여부를 점검하여 비인가자가 시스템 명령어의 무단 사용을 방지하기 위한 |
| 보안 위험 | /etc/passwd 파일에 설정된 홈 디렉토리가 존재하지 않는 경우, 해당 계정으로 로그인 시 홈 디렉토리가 루트 디렉토리(/)/로 할당되어 접근이 가능한 위험이 존재함 |
| 참고 | ※ 홈 디렉토리: 사용자가 로그인한 후 작업을 수행하는 디렉토리<br>※ 일반 사용자의 홈 디렉토리 위치: /home/<user 명> |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 홈 디렉토리가 존재하지 않는 계정이 발견되지 않는 경우<br>**취약**: 홈 디렉토리가 존재하지 않는 계정이 발견된 경우 |
| 조치 방법 | 홈 디렉토리가 존재하지 않는 계정에 홈 디렉토리 설정 또는 계정 제거하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) 사용자별 홈 디렉토리 확인
# cat /etc/passwd

Step 2) 홈 디렉토리가 존재하지 않는 사용자 계정이 불필요한 계정일 경우, 해당 계정 삭제
# userdel <사용자 이름>

Step 3) 사용중인 계정일 시, 해당 계정의 홈 디렉토리 설정
# vi /etc/passwd
예시) example:x:1000:1000::/home/example:/bin/bash
```

---

### U-33 (하) 숨겨진 파일 및 디렉토리 검색 및 제거

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 숨겨진 파일 및 디렉토리 내 의심스러운 파일 존재 여부 점검 |
| 점검 목적 | 숨겨진 파일 및 디렉토리 중 의심스러운 내용은 정상 사용자가 아닌 공격자에 의해 생성되었을 가능성이 높으므로 이를 제거하여 보안 위험을 방지하기 위함 |
| 보안 위험 | 숨겨진 파일 및 디렉토리를 방지할 경우, 비인가자가 생성한 악성 파일 또는 백도어 등을 탐지하지 못할 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 불필요하거나 의심스러운 숨겨진 파일 및 디렉토리를 제거한 경우<br>**취약**: 불필요하거나 의심스러운 숨겨진 파일 및 디렘토리를 제거하지 않은 경우 |
| 조치 방법 | ls -al 명령어로 숨겨진 파일 존재 파악 후 불법적이거나 의심스러운 파일을 제거하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) 특정 디렉토리 내 불필요한 파일 확인
# ls -al <디렉토리 이름>

Step 2) 숨겨진 파일 및 디렉토리 확인
# find / -type f -name “.*”
# find / -type d -name “.*”

Step 3) 불필요하거나 의심스러운 숨겨진 파일 및 디렉토리 제거
# rm <파일 이름>
# rm -r <디렉토리 이름>
```

---

*(Part 2 끝. 다음 Part 3에서 U-34부터 이어집니다.)*