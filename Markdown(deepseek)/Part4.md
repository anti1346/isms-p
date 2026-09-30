### U-51 (중) DNS 서비스의 취약한 동적 업데이트 설정 금지

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | DNS 서비스의 취약한 동적 업데이트 설정 여부 점검 |
| 점검 목적 | DNS 서비스의 동적 업데이트를 비활성화함으로써 신뢰할 수 없는 원본으로부터 업데이트를 받아들이는 위험을 차단하기 위함 |
| 보안 위험 | DNS 서버에서 동적 업데이트를 사용할 경우, 악의적인 사용자에 의해 신뢰할 수 없는 데이터가 받아들여질 위험이 존재함 |
| 참고 | ※ DNS 동적 업데이트: DNS 정보에 변경 사항이 있을 때마다 DNS 클라이언트 컴퓨터가 자신의 리소스 레코드(zone 파일)를 DNS 서버에 자동으로 업데이트하는 기능으로 영역 레코드 수동 관리 작업을 줄일 수 있음 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: DNS 서비스의 동적 업데이트 기능이 비활성화되었거나, 활성화 시 적절한 접근통제를 수행하고 있는 경우<br>**취약**: DNS 서비스의 동적 업데이트 기능이 활성화 중이며 적절한 접근통제를 수행하고 있지 않은 경우 |
| 조치 방법 | • DNS 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• DNS 서비스 사용 시 일반적으로 동적 업데이트 기능이 필요 없으나 확인 필요함 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
[DNS 동적 업데이트가 필요하지 않은 경우]
Step 1) allow-update 설정 확인
# cat /etc/named.conf| grep allow-update 또는 # cat /etc/bind/named.conf.options | grep allow-update

Step 2) /etc/(bind)/named.conf 파일의 allow-update 설정값 수정
allow-update { none; };

Step 3) DNS 서비스 재시작

[DNS 동적 업데이트가 필요한 경우]
Step 1) allow-update 설정 확인
# cat /etc/named.conf| grep allow-update” 또는 # cat /etc/bind/named.conf.options | grep allow-update

Step 2) /etc(/bind)/named.conf 파일의 allow-update 설정값 수정
allow-update { <DNS update를 허용할 IP>; };

Step 3) DNS 서비스 재시작
```

> ※ DNS 서비스 Zone 파일명은 임의 지정이 가능하므로 DNS 설정 파일의 Include 구문으로 참조하는 파일명 점검

---

### U-52 (중) Telnet 서비스 비활성화

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 원격 접속 시 Telnet 프로토콜 사용 여부 점검 |
| 점검 목적 | 취약한 Telnet 프로토콜을 비활성화함으로써 계정 및 중요 정보 유출 방지하기 위함 |
| 보안 위험 | 원격 접속 시 Telnet 프로토콜을 사용할 경우, 데이터가 평문으로 전송되어 비인가자가 스니핑을 통해 계정 및 중요 정보를 외부로 유출할 위험이 존재함 |
| 참고 | ※ 스니핑: 컴퓨터 네트워크상에 흘러 다니는 트래픽을 도청하는 행위 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 원격 접속 시 Telnet 프로토콜을 비활성화하고 있는 경우<br>**취약**: 원격 접속 시 Telnet 프로토콜을 사용하는 경우 |
| 조치 방법 | Telnet, FTP 등 안전하지 않은 서비스 사용을 중지하고 SSH 설치 및 사용하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) Telnet 서비스 활성화 여부 확인
# svcs -a | grep telnet

Step 2) Telnet 서비스 비활성화
# svcadm disable svc:/network/telnet:default

Step 3) SSH 서비스 실행
# svcadm enable ssh
```

**● LINUX**

```
[inetd]
Step 1) /etc/inetd.conf 파일 내 Telnet 서비스 활성화 여부 확인
Step 2) 해당 옵션이 허용된 경우 설정 제거
예시) telnet stream tcp nowait root /usr/sbin/in.telnetd 주석 처리 혹은 명령어 줄 삭제

Step 3) inetd 서비스 재시작
# service inetd restart

Step 4) SSH 서비스 실행
# service sshd start

[xinetd]
Step 1) /etc/xinetd.d/telnet 파일 내 Telnet 서비스 활성화 여부 확인
# cat /etc/xinetd.d/telnet

Step 2) /etc/xinetd.d/telnet 파일의 disable 설정값 수정
disable = yes

Step 3) 설정 적용 및 서비스 재시작
# systemctl restart xinetd

Step 4) SSH 서비스 실행
# systemctl start sshd

[systemd]
Step 1) Telnet 서비스 활성화 여부 확인
# systemctl list-units --type=socket | grep telnet

Step 2) Telnet 서비스 중지
# systemctl stop telnet.socket

Step 3) Telnet 서비스 비활성화
# systemctl disable telnet.socket

Step 4) SSH 서비스 실행
# systemctl start sshd
```

**● AIX**

```
Step 1) /etc/inetd.conf 파일 내 Telnet 서비스 활성화 여부 확인
Step 2) 해당 옵션이 허용된 경우 설정 제거
예시) telnet stream tcp6 nowait root /usr/sbin/telnet telnetd -a 주석 처리 혹은 명령어 줄 삭제

Step 3) inetd 설정 적용
# refresh –s inetd

Step 4) SSH 서비스 실행
# startsrc -s sshd
```

**● HP-UX**

```
Step 1) /etc/inetd.conf 파일 내 Telnet 서비스 활성화 여부 확인
# cat /etc/inetd.conf | grep telnet

Step 2) 해당 옵션이 허용된 경우 설정 제거
# telnet stream tcp6 nowait root /usr/sbin/telnetd telnetd -a 주석 처리 혹은 명령어 줄 삭제

Step 3) inetd 설정 적용
# inetd -c

Step 4) SSH 서비스 실행
# /sbin/init.d/secsh start
```

---

### U-53 (하) FTP 서비스 정보 노출 제한

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | FTP 서비스 정보 노출 여부 점검 |
| 점검 목적 | FTP 서비스 접속 배너를 통한 불필요한 정보 노출을 방지하기 위함 |
| 보안 위험 | 서비스 접속 배너가 차단되지 않을 경우, 비인가자가 FTP 접속 시도 시 노출되는 접속 배너 정보를 수집하여 악의적인 공격에 이용할 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: FTP 접속 배너에 노출되는 정보가 없는 경우<br>**취약**: FTP 접속 배너에 노출되는 정보가 있는 경우 |
| 조치 방법 | • FTP 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• FTP 서비스 사용 시 FTP 설정 파일을 통해 접속 배너 설정<br>※ 접속 배너에 서비스 이름이나 버전 정보를 노출하지 않는 것을 권고 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX**

```
[vsFTP]
Step 1) 배너 설정 확인
# cat /etc/vsftpd.conf | grep ftpd_banner 또는
# cat /etc/vsftpd/vsftpd.conf | grep ftpd_banner

Step 2) 해당 옵션이 설정되지 않은 경우 주석 제거 및 옵션 설정
# ftpd_banner=<변경할 배너>

Step 3) vsFTP 서비스 재시작
# systemctl restart vsftpd

[ProFTP]
Step 1) 배너 설정 확인
# cat /etc/proftpd.conf | grep ServerIdent 또는 # cat /etc/proftpd/proftpd.conf | grep ServerIdent

Step 2) /etc(/proftpd)/proftpd.conf 파일의 ServerIdent 설정값 수정
ServerIdent off 또는 ServerIdent on “<변경할 배너>”

Step 3) ProFTP 서비스 재시작
# systemctl restart proftpd
```

**● AIX**

```
[FTP]
Step 1) 메시지 카탈로그 파일 추출
# dspcat -g /usr/lib/nls/msg/en_US/ftpd.cat > /tmp/ftpd.msg

Step 2) 배너 설정 확인
# cat /tmp/ftpd.msg “(%s) FTP server (%s) ready.”

Step 3) /tmp/ftpd.msg 파일 내 배너 설정 변경
“<변경할 배너>”

Step 4) ftpd.cat 파일 생성
# gencat /usr/lib/nls/msg/en_US/ftpd.cat /tmp/ftpd.msg

[vsFTP]
Step 1) 배너 설정 확인
# cat /etc/vsftpd.conf| grep ftpd_banner

Step 2) 해당 옵션이 설정되지 않은 경우 주석 제거 및 옵션 설정
ftpd_banner=<변경할 배너>

Step 3) vsFTP 서비스 PID 확인
# ps -ef| grep vsftp

Step 4) vsFTP 서비스 재시작
# kill -l <PID>

[ProFTP]
Step 1) 배너 설정 확인
# cat /etc/proftpd.conf | grep ServerIdent

Step 2) /etc/proftpd.conf 파일 내 ServerIdent 설정값 변경
ServerIdent off 또는 ServerIdent on “<변경할 배너>”

Step 3) ProFTP 서비스 PID 확인
# ps -ef | grep proftp

Step 4) ProFTP 서비스 재시작
# kill -l <PID>
```

**● HP-UX**

```
[FTP]
Step 1) FTP 설정 파일 경로 확인
# cat /etc/inetd.conf | grep ftp

Step 2) ftpaccess 설정 확인
# cat /etc/ftpd/ftpaccess
Wu-ftpd v2.4 미만 : suppresshostname, suppressversion, banner <파일 경로> 설정 확인
Wu-ftpd v2.4 이상 : greeting, banner <파일 경로> 설정 확인

Step 3) 배너 설정 확인
# cat <기본 FTP 배너 설정 파일 경로>

Step 4) /etc/inetd.conf 파일 설정값 변경
ftp stream tcp nowait root /usr/libn/ftpd ftpd -a /etc/ftpd/ftpaccess

Step 5) 배너 파일 수정
vi 편집기를 이용하여 배너 파일을 열어 변경할 배너 작성

Step 6) /etc/ftpd/ftpaccess 파일의 suppresshostname, suppressversion, greeting 옵션 설정값 변경
Wu-ftpd v2.4 미만 : suppresshostname yes
suppressversion yes
banner <경고 메시지가 작성된 파일 경로>
Wu-ftpd v2.4 이상 : greeting terse
banner <경고 메시지가 작성된 파일 경로>

Step 7) inted 설정 적용
# inted -c
```

> ※ 해당 파일이 존재하지 않는 경우 “cp /usr/newconfig/etc/ftpd/examples/ftpaccess /etc/ftpd/ftpaccess” 명령으로 파일 생성

```
[vsFTP]
Step 1) 배너 설정 확인
# cat /etc/vsftpd.conf | grep ftpd_banner

Step 2) /etc/vsftpd.conf 파일의 ftpd_banner 설정값 변경
ftpd_banner=<변경할 배너>

Step 3) vsFTP 서비스 PID 확인
# ps -ef | grep vsftp

Step 4) vsFTP 서비스 재시작
# kill -1 <PID>

[ProFTP]
Step 1) 배너 설정 확인
# cat /etc/proftpd.conf | grep ServerIdent

Step 2) /etc/proftpd.conf 파일의 설정값 변경
ServerIdent off 또는 ServerIdent on “<변경할 배너>”

Step 3) ProFTP 서비스 PID 확인
# ps -ef | grep proftp

Step 4) ProFTP 서비스 재시작
# kill -1 <PID>
```

---

### U-54 (중) 암호화되지 않는 FTP 서비스 비활성화

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 암호화되지 않은 FTP 서비스 비활성화 여부 점검 |
| 점검 목적 | 암호화되지 않은 FTP 서비스 비활성화함으로써 계정 및 중요 정보 유출 방지하기 위함 |
| 보안 위험 | 암호화되지 않은 FTP 서비스 사용할 경우, 데이터가 평문으로 전송되어 비인가자가 스니핑을 통해 계정 및 중요 정보를 외부로 유출할 위험이 존재함 |
| 참고 | ※ 기반시설 시스템에서 FTP 서비스의 이용은 원칙적으로 금지하나, 불가피하게 사용 시 SFTP 사용 권고<br>※ 암호화되지 않은 FTP 서비스 종류 : FTP<br>※ 암호화되어 있는 FTP 서비스 종류 : SFTP, FTP over SSH(Secure FTP), FTPS |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 암호화되지 않은 FTP 서비스가 비활성화된 경우<br>**취약**: 암호화되지 않은 FTP 서비스가 활성화된 경우 |
| 조치 방법 | 암호화되지 않은 FTP 서비스 중지 및 비활성화 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
[vsFTP]
Step 1) FTP 서비스 활성화 여부 확인
# svcs -a | grep vsftpd

Step 2) FTP 서비스 비활성화
# svcadm disable vsftpd

[ProFTP]
Step 1) FTP 서비스 활성화 여부 확인
# svcs -a | grep proftpd

Step 2) FTP 서비스 비활성화
# svcadm disable proftpd
```

**● LINUX**

```
[inetd]
Step 1) /etc/inetd.conf 파일 내 FTP 서비스 활성화 여부 확인
Step 2) /etc/inetd.conf 파일의 설정값 변경(주석 처리)
# ftp stream tcp nowait root /usr/sbin/tcpd /usr/sbin/in.ftpd

Step 3) inetd 서비스 재시작
# service inetd restart

[xinetd]
Step 1) /etc/xinetd.d/ftp 파일 내 FTP 서비스 활성화 여부 확인
service ftp 단락 확인

Step 2) /etc/xinetd.d/ftp 파일의 설정값 변경
service ftp{disable = yes}

Step 3) 설정 적용 및 재시작
# systemctl restart xinetd

[vsFTP]
Step 1) FTP 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep vsftpd

Step 2) FTP 서비스 중지
# systemctl stop vsftpd

Step 3) FTP 서비스 비활성화
# systemctl disable vsftpd

[ProFTP]
Step 1) FTP 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep proftp

Step 2) FTP 서비스 중지
# systemctl stop proftpd

Step 3) FTP 서비스 비활성화
# systemctl disable portfpd
```

**● AIX, HP-UX**

```
[FTP]
Step 1) /etc/inetd.conf 파일 내 FTP 서비스 활성화 여부 확인
# cat /etc/inetd.conf

Step 2) /etc/inetd.conf 파일의 설정값 변경(주석 처리)
# ftp stream tcp nowait root /usr/sbin/tcpd /usr/sbin/in.ftpd

Step 3) inetd 설정 적용
# refresh -s inetd

[vsFTP]
Step 1) vsFTP 서비스 활성화 여부 확인
# ps -ef | grep vsftp

Step 2) vsFTP 서비스 PID 확인
# ps -ef | grep vsftp

Step 3) vsFTP 서비스 중지
# kill -9 <PID>

[ProFTP]
Step 1) ProFTP 서비스 활성화 여부 확인
# ps -ef | grep proftp

Step 2) ProFTP 서비스 PID 확인
# ps -ef | grep proftp

Step 3) ProFTP 서비스 중지
# kill -9 <PID>
```

---

### U-55 (중) FTP 계정 shell 제한

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | FTP 기본 계정에 쉘 설정 여부 점검 |
| 점검 목적 | FTP 계정의 쉘을 통한 시스템 접근을 차단하기 위함 |
| 보안 위험 | FTP 기본 계정에 쉘이 부여될 경우, 비인기자가 해당 기본 계정으로 시스템에 접근할 위험이 존재함 |
| 참고 | ※ 기반시설 시스템에서 FTP 서비스의 이용은 원칙적으로 금지하나, 불가피하게 사용 시 shell 제한 등의 보안 조치를 반드시 적용해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: FTP 계정에 /bin/false(/sbin/nologin) 쉘이 부여된 경우<br>**취약**: FTP 계정에 /bin/false(/sbin/nologin) 쉘이 부어되어 있지 않은 경우 |
| 조치 방법 | • FTP 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• FTP 서비스 사용 시 FTP 계정에 /bin/false 쉘 부여 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) ftp 계정의 일급 번째 필드에 등록된 로그인 쉘 확인
# cat /etc/passwd | grep ftp
예시) ftp:x:134:65534::/srv/ftp:/usr/sbin/nologin

Step 2) ftp 계정 로그인 쉘 변경
/etc/passwd 파일 직접 수정 : ftp:x:134:65534::/srv/ftp:/bin/false 또는 /sbin/nologin

usermod 명령어를 사용하여 수정
# usermod -s /bin/false <계정>
```

---

### U-56 (하) FTP 서비스 접근 제어 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | FTP 서비스에 비인가자의 접근 가능 여부 점검 |
| 점검 목적 | 접근 권한이 없는 비인가자의 접근을 통제하기 위함 |
| 보안 위험 | FTP 서비스의 접근제한 설정이 적절하지 않을 경우, 인증 절차 없이 비인가자가 디렉터리나 파일에 접근할 수 있어 중요 파일 변조 및 유출을 시도할 위험이 존재함 |
| 참고 | ※ 기반시설 시스템에서 FTP 서비스의 이용은 원칙적으로 금지하나, 불가피하게 사용 시 접근 제어 설정 등의 보안 조치를 반드시 적용해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 특정 IP주소 또는 호스트에서만 FTP 서버에 접속할 수 있도록 접근 제어 설정을 적용한 경우<br>**취약**: FTP 서버에 접근 제어 설정을 적용하지 않은 경우 |
| 조치 방법 | • FTP 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• FTP 서비스 사용 시 접근 제어 설정 |
| 조치 시 영향 | 특정 IP주소 또는 호스트에서만 FTP 접속이 가능함 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
[FTP - ftpusers]
Step 1) ftpusers 파일 소유자 및 권한 확인
# ls -l /etc/ftpusers 또는 # ls -l /etc/ftpd/ftpusers

Step 2) 접근 제한 설정 확인
# cat /etc/ftpusers 또는 # cat /etc/ftpd/ftpusers

Step 3) 파일 소유자를 root로 변경
# chown root /etc/ftpusers 또는 # chown root /etc/ftpd/ftpusers

Step 4) 파일 권한을 640으로 변경
# chmod 640 /etc/ftpusers 또는 # chmod 640 /etc/ftpd/ftpusers

Step 5) /etc(/ftpd)/ftpusers 파일에 FTP 서비스에 접근을 차단할 사용자 설정
```

```
[vsFTP - ftpusers]
Step 1) userlist_enable 설정값 확인
# cat /etc/vsftpd.conf | grep userlist_enable 또는 # cat /etc/vsftpd/vsftpd.conf | grep userlist_enable"
userlist_enable = NO

Step 2) 파일 소유자 및 권한 확인
# ls -l /etc/vsftpd.ftpusers 또는 # ls -l /etc/vsftpd/ftpusers

Step 3) 접근 제한 설정 확인
# cat /etc/vsftpd.ftpusers 또는 # cat /etc/vsftpd/ftpusers

Step 4) 파일 소유자를 root로 변경
# chown root /etc/vsftpd.ftpusers 또는 # chown root /etc/vsftpd/ftpuser

Step 5) 파일 권한을 640으로 변경
# chmod 640 /etc/vsftpd.ftpusers 또는 # chmod 640 /etc/vsftpd/ftpusers

Step 6) /etc/vsftpd.ftpusers 또는 /etc/vsftpd/ftpusers 파일에 FTP 서비스에 접근을 차단할 사용자 설정

[vsFTP - user_list]
Step 1) userlist_enable 설정값 확인
# cat /etc/vsftpd.conf| grep userlist_enable 또는 # cat /etc/vsftpd/vsftpd.conf| grep userlist_enable
userlist_enable = YES

Step 2) 파일 소유자 및 권한 확인
# ls -l /etc/vsftpd.user_list 또는 # ls -l /etc/vsftpd/user_list

Step 3) 접근 제한 설정 확인
# cat /etc/vsftpd.user_list 또는 # cat /etc/vsftpd/user_list

Step 4) 파일 소유자를 root로 변경
# chown root /etc/vsftpd.user_list 또는 # chown root /etc/vsftpd/user_list

Step 5) 파일 권한을 640으로 변경
# chmod 640 /etc/vsftpd.user_list 또는 # chmod 640 /etc/vsftpd/user_list

Step 6) /etc(vsftpd)/vsftpd.conf 파일의 userlist_deny 옵션 설정
user_list에 등록된 사용자만 접속 허가 : userlist_deny=no
user_list에 등록된 사용자 접속 차단 : userlist_deny=yes

Step 7) /etc(vsftpd)/vsftpd.conf 파일에 FTP 서비스에 접근을 허가/차단할 사용자 설정
```

```
[ProFTP – ftpusers]
Step 1) UseFtpUsers 설정 확인
# cat /etc/proftpd.conf| grep UseFtpUsers 또는 # cat /etc/proftpd/proftpd.conf| grep UseFtpUsers
UseFtpUsers on (기본 설정 : on)

Step 2) 파일 소유자 및 권한 확인
# ls -l /etc/ftpusers 또는 # ls -l /etc/ftpd/ftpusers

Step 3) 접근 제한 설정 확인
# cat /etc/ftpusers 또는 # cat /etc/ftpd/ftpusers

Step 4) 파일 소유자를 root로 변경
# chown root /etc/ftpusers 또는 # chown root /etc/ftpd/ftpusers

Step 5) 파일 권한을 640으로 변경
# chmod 640 /etc/ftpusers 또는 # chmod 640 /etc/ftpd/ftpusers

Step 6) /etc/(/ftpd)ftpusers 파일에 FTP 서비스에 접근을 차단할 사용자 설정

[ProFTP – proftpd.conf]
Step 1) UseFtpUsers 설정 확인
# cat /etc/proftpd.conf| grep UseFtpUsers 또는 # cat /etc/proftpd/proftpd.conf| grep UseFtpUsers
UseFtpUsers off

Step 2) 파일 소유자 및 권한 확인
# cat /etc/proftpd.conf 또는 # cat /etc/proftpd/proftpd.conf

Step 3) 접근 제한 설정 확인
# sed -n ‘/<Limit LOGIN>/,’/<Limit>/p’ /etc/proftpd.conf 또는 # sed -n ‘/<Limit LOGIN>/,’/<Limit>/p’
/etc/proftpd/proftpd.conf”

Step 4) 파일 소유자를 root로 변경
# chown root /etc/proftpd.conf 또는 # chown root /etc/proftpd/proftpd.conf

Step 5) 파일 권한을 640으로 변경
# chmod 640 /etc/proftpd.conf 또는 # chmod 640 /etc/proftpd/proftpd.conf

Step 6) /etc/(proftpd)/proftpd.conf 파일 수정 및 삽입
<Limit LOGIN>
Order Deny,Allow
AllowUser <사용자 이름> 또는 Allow from <IP주소>
DenyUser <사용자 이름> 또는 Deny from <IP주소>
</Limit>

Step 7) ProFTP 서비스 재시작
```

> ※ Order : 먼저 정의된 설정 우선 적용

---

### U-57 (중) Ftpusers 파일 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | FTP 서비스에 root 계정 접근 제한 설정 여부 점검 |
| 점검 목적 | root 계정의 FTP 직접 접속을 제한하여 root 비밀번호 정보 노출을 방지하기 위함 |
| 보안 위험 | FTP 서비스에 root 계정으로 접근할 경우, 데이터가 평문으로 전송되어 비인가자가 스니핑을 통해 관리자 계정 및 중요 정보를 외부로 유출할 위험이 존재함 |
| 참고 | ※ 기반시설 시스템에서 FTP 서비스의 이용은 원칙적으로 금지하나, 불가피하게 사용 시 root 계정 접근 제한 등의 보안 조치를 반드시 적용해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: root 계정 접속을 차단한 경우<br>**취약**: root 계정 접속을 허용한 경우 |
| 조치 방법 | • FTP 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• FTP 서비스 사용 시 root 계정으로 직접 접속할 수 없도록 설정 |
| 조치 시 영향 | 애플리케이션에서 root 계정으로 직접 접속하여 FTP를 사용하고 있는 경우 확인 필요 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
[기본 FTP - ftpusers]
Step 1) root 계정 접근 제한 설정 확인
# cat /etc/ftpusers 또는 # cat /etc/ftpd/ftpusers

Step 2) /etc(/ftpdf)/ftpusers 파일의 설정값 변경(#root 주석 제거)

[vsFTP - ftpusers]
Step 1) userlist_enable 설정 확인
# cat /etc/vsftpd.conf| grep userlist_enable 또는 # cat /etc/vsftpd/vsftpd.conf| grep userlist_enable
userlist_enable = NO

Step 2) root 계정 접근제한 설정 확인
# cat /etc/ftpusers 또는 # cat /etc/vsftpd/ftpusers
```

```
[vsFTP - user_list]
Step 1) userlist_enable 설정 확인
# cat /etc/vsftpd.conf| grep userlist_enable 또는 # cat /etc/vsftpd/vsftpd.conf| grep userlist_enable
userlist_enable = YES

Step 2) root 계정 접근제한 설정 확인
# cat /etc/vsftpd/user_list 또는 # cat /etc/vsftpd/user_list

[ProFTP]
Step 1) UseFtpUsers 설정 확인
# cat /etc/proftpd.conf| grep UseFtpUsers 또는 # cat /etc/proftpd/proftpd.conf| grep UseFtpUsers
UseFtpUsers on (기본 설정 : on)

Step 2) root 계정 접근제한 설정 확인
# cat /etc/ftpusers 또는 # cat /etc/ftpd/ftpusers
```

---

### U-58 (중) 불필요한 SNMP 서비스 구동 점검

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | SNMP 서비스 활성화 여부 점검 |
| 점검 목적 | 불필요한 SNMP 서비스를 비활성화하여 필요 이상의 정보가 노출되는 것을 방지하기 위함 |
| 보안 위험 | SNMP 서비스가 활성화되어 있을 경우, 비인가자가 시스템의 중요 정보를 유출하거나 불법적으로 수정할 위험이 존재함 |
| 참고 | ※ SNMP(Simple Network Management Protocol): TCP/IP 기반 네트워크상의 각 호스트에서 정기적으로 여러 정보를 자동으로 수집하여 네트워크 관리를 하기 위한 프로토콜을 의미함<br>※ 기반시설 시스템에서 SNMP 서비스의 이용은 원칙적으로 금지하나, 불가피하게 사용 시 기본 Community String 변경, 네트워크 모니터링 등의 보안 조치를 반드시 적용해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: SNMP 서비스를 사용하지 않는 경우<br>**취약**: SNMP 서비스를 사용하는 경우 |
| 조치 방법 | SNMP 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS(5.9 이하 버전)**

```
Step 1) SNMP 서비스 활성화 여부 및 경로 확인
# ps -ef | grep snmp

Step 2) 서비스 중지 및 이름 변경
# /etc/init.d/init.snmpdx stop
# mv /etc/rc3.d/S76snmpdx /etc/rc3.d/ S76snmpdx
```

> ※ rc*/ S**snmpdx 의 *수치는 각각 다름

**● SOLARIS(5.10 이상 버전)**

```
Step 1) SNMP 서비스 활성화 여부 확인
# svcs -a | grep snmp

Step 2) 불필요한 SNMP 서비스가 활성화 중인 경우 데몬 중지
# svcadm disable svc:/application/management/snmpd:default
```

**● LINUX**

```
Step 1) SNMP 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep snmpd

Step 2) 불필요한 SNMP 서비스가 활성화(loaded active running)인 경우 서비스 중지 및 비활성화
# systemctl stop snmpd
# systemctl disable snmpd
```

**● AIX**

```
Step 1) SNMP 서비스 활성화 여부 확인
# lssrc -a | grep snmp

Step 2) 불필요한 SNMP 서비스가 활성화(active) 중인 경우 서비스 중지
# stopsrc -s snmpd

Step 3) /etc/rc.tcpip 파일 내에 SNMP설정값 주석 처리
# start /usr/sbin/snmpd $src_running

Step 4) 설정 적용
# /etc/rc.tcpip
```

**● HP-UX**

```
Step 1) SNMP 서비스 활성화 여부 확인
# ps -ef | grep snmp

Step 2) 불필요한 SNMP 서비스가 활성화(active) 중인 경우 서비스 중지
# /sbin/init.d/snmpd stop
```

---

### U-59 (상) 안전한 SNMP 버전 사용

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 안전한 SNMP 버전 사용 여부 점검 |
| 점검 목적 | 안전한 SNMP 버전 사용으로 전송되는 데이터를 보호하기 위함 |
| 보안 위험 | SNMP 버전이 기준보다 낮을 경우, 응답 패킷이 평문으로 전송되어 스니핑 위험이 존재함 |
| 참고 | ※ SNMP(Simple Network Management Protocol): TCP/IP 기반 네트워크상의 각 호스트에서 정기적으로 여러 정보를 자동으로 수집하여 네트워크 관리를 하기 위한 프로토콜을 의미하며 v1, v2, v3 세 가지 버전이 존재하는데 v1, v2는 요청 및 응답 패킷이 평문으로 전송되기 때문에 스니핑이 가능하지만 v3 이상부터는 HMAC-MD5 또는 HMAC-SHA 알고리즘 기반의 인증을 제공함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: SNMP 서비스를 v3 이상으로 사용하는 경우<br>**취약**: SNMP 서비스를 v2 이하로 사용하는 경우 |
| 조치 방법 | • SNMP 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• SNMP 서비스 사용 시 SNMP 버전을 v3 이상으로 적용하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) SNMP v3 사용 여부 확인
# snmpwalk -v3 -l authPriv -u <사용자 이름> -a <사용자 인증 프로토콜> -A <사용자 인증 암호> -x <사용자 암호화 프로토콜> -X <사용자 암호화 암호> <SNMP 서버 IP주소>
(SHA 인증 프로토콜, AES 암호화 프로토콜 사용 예시)
# snmpwalk -v3 -l authPriv -u myuser -a SHA -A myauthpass -x AES -X myprivpass 192.168.18.190

Step 2) 사용하지 않을 경우 snmp v3 사용자 생성
# net-snmp-create-v3-user -ro -A <사용자 인증 암호> -X <사용자 암호화 암호> -a <사용자 인증 프로토콜> -x <사용자 암호화 프로토콜> <사용자 이름>
예시) # net-snmp-create-v3-user -ro -A myauthpass -X myprivpass -a SHA -x AES myuser

Step 3) /etc/snmp/snmpd.conf 파일 내의 SNMPv3 사용자 추가
# createUser <사용자 이름> <사용자 인증 프로토콜> <사용자 인증 암호> <사용자 암호화 프로토콜> <사용자 암호화 암호>
SHA 인증 프로토콜, AES 암호화 프로토콜 사용 예시)
# createUser myuser SHA myauthpass AES myprivpass

Step 4) SNMPv3 사용자 읽기/쓰기 권한 추가
<읽기/쓰기 권한> <사용자 이름>
# rouser myuser

Step 5) SNMP 서비스 실행
```

---

### U-60 (중) SNMP Community String 복잡성 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | SNMP Community String 복잡성 설정 여부 점검 |
| 점검 목적 | SNMP 서비스의 Community String의 복잡성 설정을 통해 비인가자의 비밀번호 추측 공격에 대비하기 위함 |
| 보안 위험 | Community String에 복잡성 설정이 되어 있지 않을 경우, 비인가자가 비밀번호 추측 공격을 통해 계정 탈취 시 환경설정 파일 열람 및 수정, 각종 정보수집, 관리자 권한 획득 등 다양한 위험이 존재함 |
| 참고 | ※ NMS(Network Management System): 네트워크상의 모든 장비의 중앙 감시 체제를 구축하여 모니터링, 플래닝, 분석을 시행하고 관련 데이터를 보관하여 필요 즉시 활용할 수 있게 하는 관리 시스템을 말함<br>※ Community String: SNMP는 MIB라는 정보를 주고받기 위해 인증 과정에서 일종의 비밀번호인 Community String을 사용함<br>※ 기반시설 시스템에서 SNMP 서비스의 이용은 원칙적으로 금지하나, 불가피하게 사용 시 기본 Community String 변경, 네트워크 모니터링 등의 보안 조치를 반드시 적용해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: SNMP Community String 기본값인 "public", "private"이 아닌 영문자, 숫자 포함 10자리 이상 또는 영문자, 숫자, 특수문자 포함 8자리 이상인 경우<br>※ SNMP v3의 경우 별도 인증 기능을 사용하고, 해당 비밀번호가 복잡도를 만족하는 경우 양호<br>**취약**: 아래의 내용 중 하나라도 해당되는 경우<br>1. SNMP Community String 기본값인 "public", "private"일 경우<br>2. 영문자, 숫자 포함 10자리 미만인 경우<br>3. 영문자, 숫자, 특수문자 포함 8자리 미만인 경우 |
| 조치 방법 | • SNMP 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• SNMP 서비스 사용 시 SNMP Community String 기본값인 "public", "private"이 아닌 영문자, 숫자 포함 10자리 이상 또는 영문자, 숫자, 특수문자 포함 8자리 이상으로 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS(9 이하 버전)**

```
Step 1) /etc/snmp/conf/snmpd.conf 파일 내의 Community String 설정 값 수정
read-community <변경 값>
write-community <변경 값>

Step 2) SNMP 서비스 재시작
```

**● SOLARIS(10 버전)**

```
Step 1) /etc/snmp/conf/snmpd.conf 파일 내의 Community String 설정 값 수정
rocommunity <변경 값>
rwcommunity <변경 값>

Step 2) 출력여부 확인
# svcs -a | grep snmpdx
에시) svcadm enable svc:/application/management/snmpdx:default
```

**● SOLARIS(11 버전)**

```
Step 1) /etc/net-snmp/snmp/snmpd.conf 파일 내의 Community String 설정 값 수정
rocommunity <변경 값> default
rwcommunity <변경 값> default

Step 2) 설정 적용 및 SNMP 서비스 재시작
# svcadm refresh net-snmp
```

**● LINUX**

```
[Redhat 계열]
Step 1) /etc/snmp/snmpd.conf 파일 내의 Community String 설정 값 수정
com2sec notConfigUser default <변경 값>

Step 2) 설정 적용 및 SNMP 서비스 재시작
# systemctl restart snmpd

[Debian 계열]
Step 1) /etc/snmp/snmpd.conf 파일 내의 Community String 설정 값 수정
rocommunity <변경 값> default
rwcommunity <변경 값> default

Step 2) 설정 적용 및 SNMP 서비스 재시작
# systemctl restart snmpd
```

**● AIX**

```
Step 1) /etc/snmpdv3.conf 파일 내의 Community String 설정 값 수정
COMMUNITY <새로운 Community String> <새로운 Community String> noAuthNoPriv 0.0.0.0 0.0.0.0 -

Step 2) SNMP 서비스 중지 및 실행
# stopsrc -s snmpd
# startsrc -s snmpd
```

**● HP-UX**

```
Step 1) /etc/snmpd.conf 파일 내의 Community String 설정 값 수정
get-community-name : <변경 값>
set-community-name : <변경 값>

Step 2) SNMP 서비스 재시작
```

---

### U-61 (상) SNMP Access Control 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | SNMP 접근 제어 설정 여부 점검 |
| 점검 목적 | SNMP 접근 제어 설정을 통해 비인가자의 접근을 차단하기 위함 |
| 보안 위험 | SNMP 서비스에 접근 제어가 설정되어 있지 않을 경우, 비인가자의 접근, 네트워크 정보 유출, 시스템 및 네트워크 설정 변경, DoS 공격 등의 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: SNMP 서비스에 접근 제어 설정이 되어 있는 경우<br>**취약**: SNMP 서비스에 접근 제어 설정이 되어 있지 않은 경우 |
| 조치 방법 | • SNMP 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• SNMP 서비스 사용 시 SNMP 접근 제어 설정하도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) /etc/net-snmp/snmp/snmpd.conf 파일 내의 SNMP 접근 제어 설정
rocommunity <String> <허용할 네트워크 주소 추가>
rwcommunity <String> <허용할 네트워크 주소 추가>

Step 2) 설정 적용 및 SNMP 서비스 재시작
# svcadm restart net-snmp
```

**● LINUX**

```
[Redhat 계열]
Step 1) /etc/snmp/snmpd.conf 파일 내의 SNMP 접근 제어 설정
com2sec notConfigUser <허용할 네트워크 주소 추가> <String>

Step 2) 설정 적용 및 SNMP 서비스 재시작
# systemctl restart snmpd

[Debian 계열]
Step 1) /etc/snmp/snmpd.conf 파일 내의 SNMP 접근 제어 설정
rocommunity <String> <허용할 네트워크 주소 추가>
rwcommunity <String> <허용할 네트워크 주소 추가>

Step 2) 설정 적용 및 SNMP 서비스 재시작
# systemctl restart snmpd
```

**● AIX**

```
Step 1) /etc/snmpdv3.conf 파일 내의 SNMP 접근 제어 설정
COMMUNITY <String> <String> noAuthNoPriv <허용할 네트워크 주소> <허용할 넥마스크 주소>

Step 2) SNMP 서비스 중지 및 실행
# stopsrc -s snmpd
# startsrc -s snmpd
```

**● HP-UX**

```
Step 1) /etc/snmpd.conf 파일 내의 SNMP 접근 제어 설정
trap-dest : <허용할 네트워크 주소 추가>

Step 2) SNMP 서비스 재시작
```

---

### U-62 (하) 로그인 시 경고 메시지 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 서버 및 서비스에 로그온 시 불필요한 정보 차단 설정 및 불법적인 사용에 대한 경고 메시지 출력 여부 점검 |
| 점검 목적 | 비인가자들에게 서버에 대한 불필요한 정보를 제공하지 않고, 서버 접속 시 관계자만 접속해야 한다는 경각심을 심어 주기 위함 |
| 보안 위험 | 로그온 시 경고 메시지가 설정되어 있지 않을 경우, 기본 설정값에 서버 OS 버전 및 서비스 버전이 비인가자에게 노출되어 해당 정보를 통해 서비스의 취약점을 이용하여 공격을 시도할 위험이 존재함 |
| 참고 | ※ 로그온 시 경고 메시지는 공격자의 활동을 주시하고 있다는 생각을 상기시킴으로써 간접적으로 공격 피해를 감소시키는 효과를 줄 수 있음 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 서버 및 Telnet, FTP, SMTP, DNS 서비스에 로그온 시 경고 메시지가 설정된 경우<br>**취약**: 서버 및 Telnet, FTP, SMTP, DNS 서비스에 로그온 시 경고 메시지가 설정되어 있지 않은 경우 |
| 조치 방법 | Telnet, FTP, SMTP, DNS 서비스를 사용하는 경우 설정 파일을 통해 로그온 시 경고 메시지 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
[서버]
Step 1) /etc/motd 파일과 /etc/issue 파일 내에 로그온 시 경고 메시지 입력

[Telnet]
Step 1) /etc/issue.net 파일 내에 로그온 시 경고 메시지 입력
Step 2) /etc/default/telnetd 파일 내에 배너 경고 메시지 수정
BANNER=<로그온 시 경고 메시지>

[SSH]
Step 1) /etc/motd 파일 내 로그온 시 경고 메시지 입력
Step 2) /etc/ssh/sshd_config 파일 내에 배너 경고 메시지 수정
Banner <경고 메시지가 작성된 파일 경로>

Step 3) <SSH Banner 설정 파일 경로> 파일 내에 로그온 경고 메시지 수정
(일반적으로 /etc/issue 또는 /etc/issue.net 파일 사용)

[Sendmail]
Step 1) /etc/mail/sendmail.cf 파일 내에 SmtpGreetingMessage 로그온 경고 메시지 수정
SmtpGreetingMessage=<로그온 시 경고 메시지>

Step 2) 설정 적용 및 재시작
# svcadm refresh sendmail

[Postfix]
Step 1) /etc/postfix/main.cf 파일 내에 SMTP 서버 로그온 경고 메시지 수정
smtpd_banner = <로그온 시 경고 메시지>

Step 2) 설정 적용 및 재시작
# svcadm refresh postfix

[Exim]
Step 1) /exim/exim.conf 파일 내에 SMTP 서버 로그온 경고 메시지 수정
smtp_banner = <로그온 시 경고 메시지>

Step 2) 설정 적용 및 재시작
# svcadm refresh exim

[기본 FTP]
Step 1) /etc/default/ftpd 파일 내에 경고 메시지 수정
BANNER="<로그온 시 경고 메시지>"

[vsFTP]
Step 1) /etc/vsftpd/vsftpd.conf 파일 내에 FTP 서버 로그온 경고 메시지 수정
ftpd_banner=<변경할 배너>

Step 2) 설정 적용 및 재시작
# svcadm refresh vsftpd

[ProFTP]
Step 1) /etc/proftpd/proftpd.conf 파일 내에 welcome.msg 파일 경로 확인 및 수정
DisplayLogin <welcome.msg 파일 경로>

Step 2) <welcome.msg 파일 경로> 파일 내에 설정된 FTP 서버 로그온 경고 메시지 수정

Step 3) 설정 적용 및 재시작
# svcadm refresh proftpd
```

**● LINUX**

```
[serh]
Step 1) /etc/motd, /etc/issue 파일 내에 경고 메시지 수정

[Telnet]
Step 1) /etc/issue.net 파일 내에 로그온 경고 메시지 수정

[SSH]
Step 1) /etc/ssh/sshd_config 파일 내에 설정된 배너 경고 메시지 파일 경로 확인 및 수정
Banner /etc/issue.net <경고 메시지가 작성된 파일 경로>

Step 2) <SSH 배너 설정 파일 경로> 파일 내에 경고 메시지 수정
(일반적으로 /etc/issue 또는 /etc/issue.net 파일 사용)

Step 3) 설정 적용 및 재시작
# systemctl restart sshd

[Sendmail]
Step 1) /etc/mail/sendmail.cf 파일 내에 설정된 SMTP 서버 로그온 시 경고 메시지 수정
SmtpGreetingMessage=<경고 메시지>

Step 2) 설정 적용 및 재시작
# systemctl restart sendmail

[Postfix]
Step 1) /etc/postfix/main.cf 파일 내에 설정된 SMTP 서버 로그온 시 경고 메시지 수정
smtpd_banner = <경고 메시지>

Step 2) 설정 적용 및 재시작
# systemctl restart postfix

[Exim]
Step 1) /exim/exim.conf 또는 /exim4/exim4.conf 파일 내에 설정된 SMTP 서버 로그온 시 경고 메시지 수정
Step 2) /exim/exim.conf 또는 /exim4/exim4.conf 파일 내에 설정된 SMTP 경고 메시지 수정
smtp_banner = <경고 메시지>

Step 3) 설정 적용 및 재시작
# systemctl restart exim

[vsFTP]
Step 1) /etc/vsftpd.conf 또는 /etc/vsftpd/vsftpd.conf 파일 내에 설정된 FTP 서버 로그온 시 경고 메시지 수정
ftpd_banner=<경고 메시지>

Step 2) 설정 적용 및 재시작
# systemctl restart vsftpd

[ProFTP]
Step 1) /etc/proftpd.conf 또는 /etc/proftpd/proftpd.conf 파일 내에 설정된 welcome.msg 파일 경로 확인 및 수정
DisplayLogin <welcome.msg 파일 경로>

Step 2) <welcome.msg 파일 경로> 파일 내에 설정된 FTP 서버 로그온 시 경고 메시지 수정

Step 3) 설정 적용 및 재시작
# systemctl restart proftpd

[DNS]
Step 1) /etc/named.conf 또는 /etc/bind/named.conf.options 파일 내에 설정된 경고 메시지 수정
version <경고 메시지>;

Step 2) 설정 적용 및 재시작
# systemctl restart named
```

**● AIX**

```
[서버]
Step 1) /etc/motd, /etc/issue 파일 내에 설정된 서버 로그온 경고 메시지 수정

[Telnet]
Step 1) /etc/security/login.cfg 파일 내에 설정된 경고 메시지 수정
default:
~~이하 생략~~
herald=<경고 메시지>

[SSH]
Step 1) /etc/ssh/sshd_config 파일 내에 설정된 경고 메시지 파일 경로 확인 및 수정
Banner <경고 메시지가 작성된 파일 경로>

Step 2) <SSH 배너 설정 파일 경로> 파일 내에 설정된 경고 메시지 수정
(일반적으로 /etc/issue 또는 /etc/issue.net 파일 사용)

Step 3) SSH 서비스 중지 및 실행
# stopsrc -s sshd
# startsrc -s sshd

[Sendmail]
Step 1) /etc/mail/sendmail.cf 파일 내에 설정된 SMTP 서버 로그온 시 경고 메시지 수정
SmtpGreetingMessage=<경고 메시지>

Step 2) Sendmail 서비스 중지 및 실행
# stopsrc -s sendmail
# startsrc -s sendmail

[Postfix]
Step 1) /etc/postfix/main.cf 파일 내에 설정된 SMTP 서버 로그온 시 경고 메시지 수정
smtpd_banner = <경고 메시지>

Step 2) Postfix 서비스 재시작
# kill -1 <PID>

[Exim]
Step 1) /exim/exim.conf 파일 내에 설정된 SMTP 서버 로그온 시 경고 메시지 수정
smtp_banner = <경고 메시지>

Step 2) Exim 서비스 재시작
# kill -l <PID>

[기본 FTP]
Step 1) 메시지 카탈로그 파일 생성
# dspcat -g /usr/lib/nls/msg/en_US/ftpd.cat > /tmp/ftpd.msg

Step 2) /tmp/ftpd.msg 파일 내에 설정된 FTP 서버 로그온 시 경고 메시지 수정
<변경할 배너>

Step 3) ftpd.cat 파일 생성
# gencat /usr/lib/nls/msg/en_US/ftpd.cat /tmp/ftpd.msg

[vsFTP]
Step 1) /etc/vsftpd.conf 파일 내에 설정된 FTP 서버 로그온 시 경고 메시지 수정
ftpd_banner=<경고 메시지>

Step 2) vsFTP 서비스 재시작
# kill -l <PID>

[ProFTP]
Step 1) /etc/proftpd.conf 파일 내에 설정된 welcome.msg 파일 경로 확인 및 수정
DisplayLogin <welcome.msg 파일 경로>

Step 2) <welcome.msg 파일 경로> 파일 내에 설정된 FTP 서버 로그온 시 경고 메시지 수정

Step 3) ProFTP 서비스 재시작
# kill -l <PID>

[DNS]
Step 1) /etc/named.conf 파일 내에 설정된 경고 메시지 수정
version <경고 메시지>;

Step 2) DNS 서비스 중지 및 실행
# stopsrc –s named
# startsrc -s named
```

**● HP-UX**

```
[서버]
Step 1) /etc/motd, /etc/issue 파일 내에 설정된 로그온 경고 메시지 수정

[Telnet]
Step 1) /etc/inetd.conf 파일 내에 설정된 경고 메시지 파일 경로 확인 및 수정
telnet stream tcp6 nowait root /usr/lbin/telnetd telnetd -b /etc/issue 또는 <Telnet 배너 설정 파일 경로>

Step 2) <Telnet 배너 설정 파일 경로> 파일 내에 설정된 경고 메시지 수정
(일반적으로 /etc/issue 파일 사용)

Step 3) inetd 설정 적용
# inetd –c

[SSH]
Step 1) /etc/ssh/sshd_config 파일 내에 설정된 경고 메시지 파일 경로 확인 및 수정
Banner <경고 메시지가 작성된 파일 경로>

Step 2) <SSH 배너 설정 파일 경로> 파일 내에 설정된 경고 메시지 수정
(일반적으로 /etc/issue 또는 /etc/issue.net 파일 사용)

Step 3) SSH 서비스 재시작
# kill -l <PID>

[Sendmail]
Step 1) /etc/mail/sendmail.cf 파일 내에 설정된 SMTP 서버 로그온 시 경고 메시지 수정
SmtpGreetingMessage=<경고 메시지>

Step 2) Sendmail 서비스 재시작
# kill –l <PID>

[Postfix]
Step 1) /etc/postfix/main.cf 파일 내에 설정된 SMTP 서버 로그온 시 경고 메시지 수정
smtpd_banner = <경고 메시지>

Step 2) Postfix 서비스 재시작
# kill -l <PID>

[Exim]
Step 1) /exim/exim.conf 파일 내에 설정된 SMTP 서버 로그온 시 경고 메시지 수정
smtp_banner = <경고 메시지>

Step 2) Exim 서비스 재시작
# kill -l <PID>

[기본 FTP]
Step 1) /etc/inetd.conf 파일 내에 설정된 FTP 설정 파일 경로 확인 및 수정
ftp stream tcp nowait root /usr/lib/ftpd ftpd -a /etc/ftpd/ftpaccess

Step 2) <기본 FTP 배너 설정 파일 경로> 파일 내에 경고 메시지 수정

Step 3) /etc/ftpd/ftpaccess 파일 내에 설정값 수정
[Wu-ftpd v2.4 미만인 경우]
suppresshostname yes
suppressversion yes
banner <경고 메시지가 작성된 파일 경로>

[Wu-ftpd v2.4 이상인 경우]
greeting terse
banner <경고 메시지가 작성된 파일 경로>

# cp /usr/newconfig/etc/ftpd/examples/ftpaccess /etc/ftpd/ftpaccess

Step 4) inetd 설정 적용
# inetd -c

[vsFTP]
Step 1) /etc/vsftpd.conf 파일 내에 설정된 FTP 서버 로그온 시 경고 메시지 수정
ftpd_banner=<경고 메시지>

Step 2) vsFTP 서비스 재시작
# kill -1 <PID>

[ProFTP]
Step 1) /etc/proftpd.conf 파일 내에 설정된 welcome.msg 파일 경로 확인 및 수정
DisplayLogin <welcome.msg 파일 경로>

Step 2) <welcome.msg 파일 경로> 파일 내에 설정된 FTP 서버 로그온 시 경고 메시지 수정

Step 3) ProFTP 서비스 재시작
# kill -1 <PID>

[DNS]
Step 1) /etc/named.conf 파일 내에 설정된 경고 메시지 확인
version <경고 메시지>;

Step 2) DNS 서비스 실행
# kill -1 <PID>
```

---

### U-63 (중) sudo 명령어 접근 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | /etc/sudoers 파일 권한 적절성 여부 점검 |
| 점검 목적 | 비인가자가 관리자 권한을 남용하여 시스템 손상, 악성 코드 실행, 민감한 데이터 유출 등의 보안 위험을 방지하기 위함 |
| 보안 위험 | sudo 명령어 접근을 제한하지 않을 경우, 비인가자가 관리자 권한으로 허가되지 않은 명령어를 사용하여 루트 권한 오용, 악성 코드 실행, 데이터 유출 등의 시도를 할 위험이 존재함 |
| 참고 | ※ sudo(SuperUser DO): root 권한으로 명령어를 실행함<br>※ /etc/sudoers: sudo 명령을 사용하여 다른 명령을 실행할 수 있는 사용자를 지정하는 파일 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: /etc/sudoers 파일 소유자가 root이고, 파일 권한이 640인 경우<br>**취약**: /etc/sudoers 파일 소유자가 root가 아니거나, 파일 권한이 640을 초과하는 경우 |
| 조치 방법 | /etc/sudoers 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) /etc/sudoers 파일 소유자 및 권한 확인
# ls -l /etc/sudoers

Step 2) /etc/sudoers 파일 소유자를 root, 권한 640으로 변경
# chown root /etc/sudoers
# chmod 640 /etc/sudoer
```

---

## 4. 패치 관리

### U-64 (상) 주기적 보안 패치 및 벤더 권고사항 적용

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 시스템에서 최신 패치가 적용 여부 점검 |
| 점검 목적 | 주기적인 패치 적용을 통해 시스템 안정성 및 보안성을 확보하기 위함 |
| 보안 위험 | 최신 보안패치가 적용되지 않을 경우, 이미 알려진 취약점을 통하여 공격자에 의해 시스템 침해사고 발생할 위험이 존재함 |
| 참고 | ※ 최신 버전의 Kernel을 사용하도록 권고하고 있으나, 시스템 운영상 적용이 어려운 경우 최신 버전이 아닌 취약점이 존재하지 않는 Kernel 버전도 허용하고 있음 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 패치 적용 정책을 수립하여 주기적으로 패치 관리를 하고 있으며, 패치 관련 내용을 확인하고 적용하였을 경우<br>**취약**: 패치 적용 정책을 수립하지 않고 주기적으로 패치 관리를 하지 않거나, 패치 관련 내용을 확인하지 않고 적용하지 않고 있는 경우 |
| 조치 방법 | OS 관리자, 서비스 개발자가 패치 적용에 따른 서비스 영향 정도를 파악하여 OS 관리자 및 벤더에서 적용하도록 설정<br>※ OS 패치의 경우 지속해서 취약점이 발표되고 있으므로 O/S 관리자, 서비스 개발자가 패치 적용에 따른 서비스 영향 정도를 정확히 파악하여 주기적인 패치 적용 정책을 수립하여 적용해야 함 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
[Oracle support]이 존재하지 않는 경우
Step 1) IFO에 ‘i’가 있는 곳에 설치된 패키지 확인
# pkg list -af entire | head -5 IFO
예시) NAME (PUBLISHER) VERSION IFO
entire 11.4-11.4.42.0.0.11.0 i--
entire 11.4-11.4.0.0.1.15.0 ---
entire 0.5.11-0.175.3.1.0.5.3 ---
entire 0.5.11-0.175.3.1.0.5.2 ---

Step 2) 최신 패키지 확인
# pkg list -af entire@latest
예시) NAME (PUBLISHER) VERSION INFO
entire 11.4-11.4.42.0.0.11.0 i--

Step 3) OS 버전으로 업데이트 후 재부팅
# pkg update --accept

[Oracle support]이 존재하는 경우
Step 1) IFO에 ‘i’ 가 있는 곳에 설치된 패키지 확인
# pkg list -af entire | head -5
예시) NAME (PUBLISHER) VERSION INFO
entire 11.4-11.4.42.0.0.11.0 i--
entire 11.4-11.4.0.0.1.15.0 ---
entire 0.5.11-0.175.3.1.0.5.3 ---
entire 0.5.11-0.175.3.1.5.2 ---

Step 2) 최신 패키지 확인
# pkg list -af entire@latest
예시) NAME (PUBLISHER) VERSION INFO
entire 11.4-11.4.42.0.0.11.0 i--

Step 3) 업데이트 프리뷰
# pkg update --nv entire@버전 이름

Step 4) 업데이트 후 재부팅
# pkg update --accept entire@버전 이름
```

> ※ Oracle support 있는지 구분하려면 pkg publisher 명령어를 사용하여 support 리포지토리(repository)가 있어야 https://pkg.oracle.com/solaris/support/
> ※ Oracle support 없으면 분기별로만 업데이트가 가능함
> ※ Oracle support 있다면 매달 업데이트(SRU)와 Critical Patch Updates가 support 리포지토리에 담겨 있음
> ※ Critical Patch Updates에 대하여 자세한 사항은 아래 링크 참고
> https://docs.oracle.com/en/operating-systems/solaris/oracle-solaris/11.4/update-sys-add-sw/critical-patch-update-packages.html
> ※ 자세한 Oracle support 내용은 아래 링크 참고

```
Step 1) OS 및 커널 버전 확인
# hostnamectl

Step 2) EOL 상태가 아닌 Linux OS 버전으로 업데이트
Step 3) 최신 보안 패치가 적용된 Kernel 버전으로 업데이트
```

**● AIX**

```
[패치 적용 방법]
Step 1) 설치된 OS 또는 버전 확인
# oslevel -s

Step 2) 서버에 적용되어 있는 패치 리스트 확인
# instfix -i | grep ML
# instfix -i | grep SP

Step 3) 아래 사이트에 접속하여 최신 패치를 찾아 업데이트
https://www.ibm.com/support/fixcentral

Step 4) 최신 패치를 다운로드 받은 후 OS 패치 설치 진행
# smitty installp

Step 5) Install Software 선택 후 INPUT device / directory for software 항목에 패치 파일 경로 입력

Step 6) SOFTWARE to install 항목에서 all-latest 선택

Step 7) ACCEPT new license agreements 항목을 yes로 설정 후 설치 진행
```

> ※ 패치 진행 중 문제가 발생한 경우, Apply 설치만 기본 버전으로 재설정 가능
> ※ Apply, Commit 된 패키지 확인은 ls|pp -l 명령어로 확인 가능

```
[패치 블레 적용 방법]
Step 1) 설치된 OS 또는 버전 확인
# oslevel -s

Step 2) 서버에 적용되어 있는 패치 리스트 확인
# instfix -i | grep ML
# instfix -i | grep SP

Step 3) OS 패치 블백 진행
# smitty install_reject

Step 4) SOFTWARE name 항목에서 Apply 설치된 OS Patch 선택 Preview 항목 Yes로 설정

Step 5) 소프트웨어 제거에 문제가 없는지 확인 후 진행
```

**● HP-UX**

```
[패치 적용 방법]
Step 1) 서버에 적용된 패치 리스트 확인
# swlist -l product

Step 2) 아래 사이트에 접속 후 패치를 찾아 업데이트
https://support.hpe.com/hpsc/patch/content?action=home

Step 3) patch 파일을 /tmp 디렉터리 내 저장
예시) /tmp/patch_10

Step 4) HP-UX에서 shell archive를 품
# sh patch_10 - patch_10.depot, patch_10.text가 생성됨

Step 5) patch_10.depot 설치
# swinstall -s /tmp/patch_10.depot (절대경로 입력)
# swinstall -x autoreboot=true -x patch_match_target=true \
-s /tmp/patch_10.depot
```

---

## 5. 로그 관리

### U-65 (중) NTP 및 시각 동기화 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | NTP 및 시각 동기화 설정 여부 점검 |
| 점검 목적 | 인증 및 감사 목적을 위한 시간 동기화는 필수적이며, 안전하고 승인된 NTP 서비스와 동기화하기 위함 |
| 보안 위험 | 시스템 간 시간 동기화 미흡으로 보안 사고 및 장애 발생 시 로그에 대한 신뢰도 확보 미흡 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: NTP 및 시각 동기화 설정이 기준에 따라 적용된 경우<br>**취약**: NTP 및 시각 동기화 설정이 기준에 따라 적용되어 있지 않은 경우 |
| 조치 방법 | NTP 설정 및 동기화 주기 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, AIX, HP-UX**

```
Step 1) 동기화된 NTP 서버 확인
# ntpq -pn
예시) <IP 주소1> <IP 주소2> 3 u 67 64 12 3.11 -425167 7877.17

Step 2) /etc/ntp.conf 파일 내의 NTP 설정값 수정(필요시 기존 서버 제거 후 새로운 NTP 서버 추가)
server <NTP 서버>

Step 3) NTP 서비스 재시작
```

**● LINUX**

```
[NTP]
Step 1) NTP 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep ntp

Step 2) 동기화된 NTP 서버 확인
# ntpq -pn
예시) *<IP 주소1> 133.243.238.244 2u 53 64 377 5.730 +2.025 8.323
+<IP 주소2> <IP 주소3> 3u 49 64 377 5.838 -16.050 16.484
-<IP 주소4> <IP 주소5> 2u 2 64 377 187.934 -8.059 81.846
(이하 생략)

Step 3) /etc/ntp.conf 파일 내에 NTP 서버 추가
server <NTP 서버>

Step 4) 설정 적용 및 재시작
# systemctl restart ntp
```

> ※ Redhat 계열 리눅스는 RHEL 8 버전부터 Chonry 서비스로 변경

```
[Chrony]
Step 1) Chrony 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep chrony

Step 2) 동기화된 Chrony 서버 확인
# chronyc sources
예시) ^- <IP 주소> 3 6 37 4 -135us[ +209us] +/- 56ms
^<IP 주소> 3 6 37 5 +841us[+1184us] +/- 57ms
(이하 생략)

Step 3) /etc/chrony.conf 파일 내에 NTP 서버 추가
server <NTP 서버>

Step 4) 설정 적용 및 재시작
# systemctl restart chrony
```

---

### U-66 (중) 정책에 따른 시스템 로깅 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 내부 정책에 따른 시스템 로깅 설정 여부 검정 |
| 점검 목적 | 보안 사고 발생 시 원인 파악 및 각종 침해 사실 확인을 하기 위함 |
| 보안 위험 | 로깅 설정이 되어 있지 않을 경우, 원인 규명이 어려우며 법적 대응을 위한 충분한 증거로 사용할 수 없는 위험이 존재함 |
| 참고 | ※ 감사 설정이 너무 높으면 보안 로그에 불필요한 항목이 많이 기록되어 매우 중요한 항목과 혼동할 수 있으며 시스템 성능에도 심각한 영향을 줄 수 있으므로 법적 요구 사항과 조직의 정책에 따라 필요한 로그를 남기도록 설정해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 로그 기록 정책이 보안 정책에 따라 설정되어 수립되어 있으며, 로그를 남기고 있는 경우<br>**취약**: 로그 기록 정책 미수립 또는 정책에 따라 설정되어 있지 않거나, 로그를 남기고 있지 않은 경우 |
| 조치 방법 | 로그 기록 정책을 수립하고, 정책에 따라 (/syslog.conf 파일을 설정 |
| 조치 시 영향 | 아래 제시한 모든 로그를 설정할 경우, 시스템 성능과 로그 저장에 따른 서버 용량 부족 문제가 발생할 수 있으므로 시스템 운영 환경과 특성을 고려하여 적용 |

#### 점검 및 조치 사례

**● SOLARIS**

```
[syslog]
Step 1) /etc/syslog.conf 파일 내에 설정된 로그 기록 정책 수정

| 로그 | 로그 파일 경로 |
| :--- | :--- |
| mail.debug | /var/log/mail.log |
| *.info | /var/log/syslog.log |
| *.alert | /var/log/syslog.log |
| *.alert | /dev/console |
| *.alert | root |
| *.emerg | * |

Step 2) 설정 적용 및 재시작
# svcadm refresh svc:/system/system-log:default

[rsyslog]
Step 1) /etc/rsyslog.conf 파일 내에 설정된 로그 기록 정책 수정

| 로그 | 로그 파일 경로 |
| :--- | :--- |
| *.info:mail.none:authpriv.none:cron.none | /var/log/messages |
| authpriv.* | /var/log/auth.log |
| mail.* | /var/log/mail.log |
| cron.* | /var/log/cron.log |
| alert.* | /dev/console |
| emerg.* | * |

Step 2) 설정 적용 및 재시작
# svcadm refresh svc:/system/system-log:rsyslog
```

**● LINUX**

```
Step 1) /etc/rsyslog.conf 또는 /etc/rsyslog.d/default.conf 파일 내에 설정된 로그 기록 정책 수정

| 로그 | 로그 파일 경로 |
| :--- | :--- |
| *.info:mail.none:authpriv.none:cron.none | /var/log/messages |
| auth,authpriv.* | /var/log/secure |
| mail.* | /var/log/maillog |
| cron.* | /var/log/cron |
| *.alert | /dev/console |
| *.emerg | * |

Step 2) 설정 적용 및 재시작
# systemctl restart rsyslog
```

**● AIX**

```
Step 1) /etc/syslog.conf 파일 내에 설정된 로그 기록 정책 수정

| 로그 | 로그 파일 경로 |
| :--- | :--- |
| *.emerg | * |
| *.alert | /dev/console |
| *.alert | /var/adm/alert.log |
| *.err | /var/adm/error.log |
| mail.info | /var/adm/mail.log |
| auth.info | /var/adm/auth.log |
| daemon.info | /var/adm/daemon.log |
| *.emerg;*.alert;*.crit;*.err;*.warning;*.notice;*.info | /var/adm/messages |

Step 2) 설정 적용 및 재시작
# refresh -s syslogd
```

**● HP-UX**

```
Step 1) /etc/syslog.conf 파일 내에 설정된 로그 기록 정책 수정

| 로그 | 로그 파일 경로 |
| :--- | :--- |
| *.emerg | * |
| *.alert | /dev/console |
| *.alert | root |
| *.err | /var/adm/syslog/error.log |
| mail.info | /var/adm/syslog/mail.log |
| auth.info | /var/adm/syslog/auth.log |
| *.emerg;*.alert;*.crit;*.err;*.warning;*.notice;*.info | /var/adm/syslog/syslog.log |

Step 2) SYSLOG 설정 적용
```

| 구분 | 왼쪽 필드 | 오른쪽 필드 | 형식 |
| :--- | :--- | :--- | :--- |
| 예시 | mail.debug: cron.crit:auth.info | /var/log/syslog.log | A, B |
| 설명 | A 서비스 데몬의 B 로그 레벨 이상 | A 서비스 데몬의 B 로그 레벨 이상 | C |

#### [syslog.conf 파일 형식]

#### [오른쪽 필드 로그 형식 종류]

- `/var/log/syslog.log` : 해당 파일에 로그를 기록
- `/dev/console` : 모니터 화면과 같은 지정된 콘솔로 메시지 출력
- `user` : 지정된 사용자의 화면에 메시지 출력
- `*` : 현재 로그인되어 있는 모든 사용자의 화면에 메시지 출력
- `@192.168.0.1` : 지정된 호스트로 로그 전송

| 서비스 데몬 종류 | 설명 |
| :--- | :--- |
| auth | 로그인 등의 인증 프로그램 유형에서 발행된 메시지 |
| authpriv | 개인 인증을 요구하는 프로그램 유형에서 발행된 메시지 |
| cron | cron, at 데몬에서 발행된 메시지 |
| daemon | Telnet, FTP 등 데몬에서 발행한 메시지 |
| kern | 커널에서 발행된 메시지 |
| lpr | 프린터 유형의 프로그램에서 발행된 메시지 |
| mail | 메일 시스템에서 발행된 메시지 |
| news | 유즈넷 뉴스 프로그램에서 발행된 메시지 |
| syslog | syslog 프로그램 유형에서 발행된 메시지 |
| user | 사용자 프로세스 관련 메시지 |
| uucp | 시스템에서 발행된 메시지 |
| local0 | 여분으로 남겨둔 유형 |

| 메시지 우선 순위 | 등급 | 설명 |
| :--- | :--- | :--- |
| 4 (높음) | Emergency[emerg] | 매우 위험한 상황 |
| 3 | Alert[alert] | 즉각적인 조치를 해야 하는 상황 |
| 2 | Critical[crit] | 하드웨어 등의 심각한 오류가 발생한 상황 |
| 1 | Error[err] | 에러 발생 시 |
| 0 | Warning[warning] | 주의를 요구하는 메시지 |
| -1 | Notice[notice] | 에러가 아닌 알림에 관한 메시지 |
| -2 | Information[info] | 단순한 프로그램에 대한 정보 메시지 |
| -3 (낮음) | Debug[Dedug] | 프로그램 실행 오류 발생 시 |

---

### U-67 (중) 로그 디렉터리 소유자 및 권한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 로그에 대한 접근 통제 및 관리 여부 점검 |
| 점검 목적 | 로그 파일을 관리자만 제어할 수 있게 하여 비인가자의 임의적인 파일 훼손 및 변조를 방지하기 위함 |
| 보안 위험 | 로그에 대한 접근 통제가 미흡할 경우, 비인가자가 로그에서 정보를 획득하거나 로그 자체를 변조할 수 있는 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 디렉터리 내 로그 파일의 소유자가 root이고, 권한이 644 이하인 경우<br>**취약**: 디렉터리 내 로그 파일의 소유자가 root가 아니거나, 권한이 644를 초과하는 경우 |
| 조치 방법 | 디렉터리 내 로그 파일 소유자 및 권한 변경 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX**

```
Step 1) /var/log/ 디렉터리 내 로그 파일의 소유자 및 권한 변경
# chown root /var/log/<파일 이름>
# chmod 644 /var/log/<파일 이름>
```

**● AIX**

```
Step 1) /var/adm/ 디렉터리 내 로그 파일의 소유자 및 권한 변경
# chown root /var/adm/<파일 이름>
# chmod 644 /var/adm/<파일 이름>
```

**● HP-UX**

```
Step 1) /var/adm/syslog/ 디렉터리 내 로그 파일의 소유자 및 권한 변경
# chown root /var/adm/syslog/<파일 이름>
# chmod 644 /var/adm/syslog/<파일 이름>
```

---

*(Part 4 끝. 이상으로 Unix 서버 파트가 완료되었습니다. 다음 Part 5에서는 Windows 서버 파트가 시작됩니다.)*