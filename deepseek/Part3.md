## 3. 서비스 관리

### U-34 (상) Finger 서비스 비활성화

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | Finger 서비스 비활성화 여부 점검 |
| 점검 목적 | Finger 서비스를 통해 네트워크 외부에서 해당 시스템에 등록된 사용자 정보를 확인할 수 있어 비인가자에게 사용자 정보가 조회되는 것을 방지하기 위함 |
| 보안 위험 | Finger 서비스가 활성화되어 있을 경우, 비인가자가 Finger 서비스를 사용하여 사용자 정보를 조회한 후 비밀번호 공격을 통해 계정을 탈취할 위험이 존재함 |
| 참고 | ※ Finger(사용자 정보 확인 서비스): who 명령어가 현재 사용 중인 사용자들에 대한 간단한 정보만을 보여주는 데 반해 Finger 명령은 옵션에 따른 시스템에 등록된 사용자뿐만 아니라 네트워크를 통하여 연결되어 있는 다른 시스템에 등록된 사용자들에 대한 자세한 정보를 보여줌 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: Finger 서비스가 비활성화된 경우<br>**취약**: Finger 서비스가 활성화된 경우 |
| 조치 방법 | Finger 서비스 비활성화 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS(5.9 이하 버전)**

```
Step 1) /etc/inetd.conf 파일 내 Finger 서비스 활성화 여부 확인 및 비활성화
Finger 서비스 항목 주석 처리
예시) #finger stream tcp nowait bin /usr/libin/fingered finger

Step 2) inetd 서비스 재시작
```

**● SOLARIS(5.10 이상 버전)**

```
Step 1) Finger 서비스 활성화 여부 확인
# inetadm | grep finger

Step 2) Finger 서비스 데몬 중지
#inetadm -d svc:/network/finger:default
```

**● LINUX**

```
[inetd]
Step 1) /etc/inetd.conf 파일 내 Finger 서비스 활성화 여부 확인 및 비활성화
Finger 서비스 항목 주석 처리
예시) #finger stream tcp nowait bin /usr/libin/fingered fingerd

Step 2) inetd 서비스 재시작

[xinetd]
Step 1) /etc/xinetd.d/finger 파일 내 Finger 서비스 활성화 여부 확인 및 비활성화
finger의 disable 옵션을 yes로 수정

Step 2) 설정 적용 및 xinetd 서비스 재시작
# systemctl restart xinetd
```

**● AIX, HP-UX**

```
Step 1) /etc/inetd.conf 파일 내 Finger 서비스 활성화 여부 확인 및 비활성화
Finger 서비스 항목 주석 처리
예시) #finger stream tcp nowait bin /usr/libin/fingered fingerd

Step 2) inetd 서비스 재시작
```

---

### U-35 (상) 공유 서비스에 대한 익명 접근 제한 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 공유 서비스의 익명 접근 제한 설정 여부 점검 |
| 점검 목적 | 공유 서비스의 익명 접근을 제한하여 중요 정보의 노출을 방지하기 위함 |
| 보안 위험 | 공유 서비스의 익명 접근을 허용할 경우, 비인가자의 무단 접근으로 인한 중요 정보 탈취 또는 변조, 악성 코드 유포 등의 위험이 존재함 |
| 참고 | ※ 익명 접속이 허용된 서버에 익명 사용자에 대해 쓰기 권한이 부여되어 있는 경우, 정상 파일에 대해 변조가 가능하므로 공개된 디렉터리 내 중요 데이터 여부를 주기적으로 확인해야 함<br>※ 공유 서비스를 사용하지 않는 경우 양호 또는 N/A |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 공유 서비스에 대해 익명 접근을 제한한 경우<br>**취약**: 공유 서비스에 대해 익명 접근을 허용한 경우 |
| 조치 방법 | 공유 서비스의 익명 접근 제한 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
[기본 FTP]
Step 1) FTP 계정 확인
# cat /etc/passwd | grep ftp
# cat /etc/passwd | grep anonymous

Step 2) FTP 계정 제거
# userdel ftp
# userdel anonymous

[vsFTP]
Step 1) Anonymous FTP 활성화 여부 확인
# cat /etc/vsftpd/vsftpd.conf | grep anonymous_enable

Step 2) Anonymous FTP 비활성화
# vi /etc/vsftpd/vsftpd.conf
anonymous_enable 옵션을 NO로 수정

[ProFTP]
Step 1) Anonymous FTP 활성화 여부 확인
# sed -n ‘/<Anonymous ~ftp>/,/</Anonymous>/p’ /etc/proftpd/proftpd.conf

Step 2) Anonymous FTP 비활성화
# vi /etc/proftpd/proftpd.conf
Anonymous 필드 주석 처리
```

> ※ User, UserAlias 옵션이 설정된 경우 익명 접근이 활성화되어 있는 상태

```
[NFS]
Step 1) 익명 접근 활성화 여부 확인
# cat /etc/dfs/dfstab | grep anon

Step 2) 익명 접근 비활성화
# vi /etc/dfs/dfstab
anon 옵션을 -1로 수정
예시) share -F nfs -o rw, anon=-1 /home/example

Step 3) NFS 서비스 재시작
# exportfs -u
# exportfs -a

[Samba]
Step 1) 익명 접근 허용 여부 확인
# cat /etc/samba/smb.conf | grep “guset ok”

Step 2) 익명 사용자 접근 비활성화
# vi /etc/samba/smb.conf
guest ok 옵션을 no로 수정

Step 3) 변경된 설정 적용 및 재시작
```

**● LINUX**

```
[기본 FTP]
Step 1) FTP 계정 확인
# cat /etc/passwd | grep ftp
# cat /etc/passwd | grep anonymous

Step 2) FTP 계정 제거
# userdel ftp
# userdel anonymous

[vsFTP]
Step 1) Anonymous FTP 활성화 여부 확인
# cat /etc/vsftpd.conf | grep anonymous_enable
# cat /etc/vsftpd/vsftpd.conf | grep anonymous_enable

Step 2) Anonymous FTP 비활성화
# vi /etc/vsftpd/vsftpd.conf
anonymous_enable 옵션을 NO로 수정

Step 3) 변경된 설정 적용 및 재시작
# systemctl restart vsftpd

[ProFTP]
Step 1) Anonymous FTP 활성화 여부 확인
# sed -n ‘/<Anonymous ~ftp>/</Anonymous>/p’ /etc/proftpd.conf
# sed -n ‘/<Anonymous ~ftp>/</Anonymous>/p’ /etc/proftpdp/proftpd.conf

Step 2) Anonymous FTP 비활성화
# vi /etc/proftpd/proftpd.conf
Anonymous 필드 주석 처리

Step 3) 변경된 설정 적용 및 재시작
# systemctl restart proftpd
```

> ※ User, UserAlias 옵션이 설정된 경우 익명 접근이 활성화되어 있는 상태

```
[NFS]
Step 1) 익명 접근 활성화 여부 확인
# cat /etc/exports | grep anon

Step 2) 익명 접근 비활성화
# vi /etc/exports
anon 옵션을 -1로 수정
예시) /home/example -sec=sys:krb5p:krb5i:krb5:dh,ro=host1, access=host1, anon=-1

Step 3) NFS 서비스 재시작
# exportfs -u
# exportfs -a
```

> ※ anon 옵션이 -1이 아닌 경우 익명 접근이 활성화되어 있는 상태

```
[Samba]
Step 1) 익명 접근 허용 여부 확인
# cat /usr/lib/smb.conf| grep “guset ok”

Step 2) 익명 사용자 접근 비활성화
# vi /usr/lib/smb.conf
guest ok 옵션을 no로 수정

Step 3) Samba 서비스 중지 및 재실행
# stopsrc –s smbd
# startsrc -s smbd
```

**● HP-UX**

```
[기본 FTP]
Step 1) FTP 계정 확인
# cat /etc/passwd | grep ftp
# cat /etc/passwd | grep anonymous

Step 2) FTP 계정 제거
# userdel ftp
# userdel anonymous

[vsFTP]
Step 1) Anonymous FTP 활성화 여부 확인
# cat /etc/vsftpd.conf| grep anonymous_enable

Step 2) Anonymous FTP 비활성화
# vi /etc/vsftpd.conf
anonymous_enable 옵션을 NO로 수정

Step 3) 서비스 재시작
# kill -l <PID>

[ProFTP]
Step 1) Anonymous FTP 활성화 여부 확인
# sed -n ‘/<Anonymous ~ftp>/,/</Anonymous>/p’ /etc/proftpd.conf

Step 2) Anonymous FTP 비활성화
# vi /etc/proftpd.conf
Anonymous 필드 주석 처리

Step 3) 서비스 재시작
# kill -l <PID>

[NFS]
Step 1) 익명 접근 활성화 여부 확인
# cat /etc/exports | grep anon
# cat /etc/dfs/dfstab | grep anon

Step 2) 익명 접근 비활성화
# vi /etc/exports
# vi /etc/dfs/dfstab
anon 옵션을 -1로 수정
예시) /home/example –access=bear,anon=-1,ro
예시) share -F nfs -o rw, anon=-1 /home/example

Step 3) NFS 서비스 재시작
# exportfs -u
# exportfs -a
```

> ※ HP-UX 11i v3에서는 /etc/dfs/dfstab 파일을 사용함
> ※ anon 옵션이 -1이 아닌 경우 익명 접근이 활성화되어 있는 상태

```
[Samba]
Step 1) 익명 접근 허용 여부 확인
# cat /usr/lib/smb.conf| grep “guest ok”

Step 2) 익명 사용자 접근 비활성화
# vi /usr/lib/smb.conf

Step 3) 서비스 재시작
# kill -l <PID>
```

---

### U-36 (상) r 계열 서비스 비활성화

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | r-command 서비스 비활성화 여부 점검 |
| 점검 목적 | r-command 사용을 통한 원격 접속은 NET Backup 또는 클러스터링 등 용도로 사용되기도 하나, 인증 없이 관리자 원격 접속이 가능하여 이에 대한 보안 위험을 방지하기 위함 |
| 보안 위험 | rlogin, rsh, rexec 등의 r-command를 이용하여 원격에서 인증 절차 없이 터미널 접속, 쉘 명령어를 실행이 가능한 위험이 존재함 |
| 참고 | ※ r-command: 인증 없이 관리자의 원격 접속을 가능하게 하는 명령어들로 rsh(rermsh), rlogin, rexec, rsync 등이 있음 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 불필요한 r 계열 서비스가 비활성화된 경우<br>**취약**: 불필요한 r 계열 서비스가 활성화된 경우 |
| 조치 방법 | 불필요한 r 계열 서비스 중지 및 비활성화 설정<br>※ NET Backup 등 특별한 용도로 사용하지 않는다면 shell(514), login(513), exec(512) 서비스 중지<br>※ rlogin, rsh, rexec 서비스는 backup, 클러스터링 등의 용도로 종종 사용되고 있으므로 해당 서비스 사용 유무를 확인하여 미사용시 서비스 중지<br>※ /etc/hosts.equiv 또는 $HOME/.rhosts 파일을 통해 해당 서비스 사용 여부 확인 (파일이 존재하지 않거나 해당 파일 내에 설정이 없다면 사용하지 않는 것으로 간주) |
| 조치 시 영향 | 일반적인 경우 영향을 없음 |

#### 점검 및 조치 사례

**● SOLARIS(5.9 이하 버전)**

```
Step 1) /etc/inetd.conf 파일 내 불필요한 r 계열 서비스 활성화 여부 확인
# vi /etc/inetd.conf

Step 2) 불필요한 r 계열 서비스 관련 필드 주석처리
예시) #shell stream tcp nowait root /usr/sbin/in.rshd in.rshd

Step 3) 서비스 재시작
# kill -HUP [inetd PID]
```

**● SOLARIS(5.10 이상 버전)**

```
Step 1) 불필요한 r 계열 서비스 활성화 여부 확인
# inetadm | egrep “shell|rlogin|rexec”

Step 2) 불필요한 r 계열 서비스 대문 중지
# inetadm -d <rcommand 대문>
```

**● LINUX**

```
[inetd]
Step 1) /etc/inetd.conf 파일 내 불필요한 r 계열 서비스 활성화 여부 확인
Step 2) 불필요한 r 계열 서비스 관련 필드 주석 처리
# vi /etc/inetd.conf
예시) # rlogin stream tcp nowait root /usr/sbin/in.rlogind in.rlogind

Step 3) inetd 서비스 재시작
```

```
[xinetd]
Step 1) /etc/xinetd.d/<파일 이름> 파일 내 불필요한 r 계열 서비스 활성화 여부 확인
Step 2) 불필요한 r 계열 서비스 비활성화
disable 값을 yes로 수정

Step 3) 설정 적용 및 서비스 재시작
# systemctl restart xinetd
```

```
[systemd]
Step 1) 불필요한 r 계열 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep -E “rlogin|rsh|rexec”

Step 2) 현재 가동되고 있는 r 계열 서비스 중지
# systemctl stop <서비스 이름>

Step 3) 불필요한 r 계열 서비스 비활성화
# systemctl disable <서비스 이름>
```

**● AIX, HP-UX**

```
[inited]
Step 1) /etc/inetd.conf 파일 내 불필요한 r 계열 서비스 활성화 여부 확인
Step 2) 불필요한 r 계열 서비스 관련 필드 주석 처리
# vi /etc/inetd.conf
예시) #login stream tcp6 nowait root /usr/sbin/rlogind rlogind

Step 3) 변경된 설정 적용
- AIX : # refresh –s inetd
- HP-UX : # inetd -c
```

```
[r-command]
Step 1) /etc/inetd.conf 파일 내 불필요한 r 계열 서비스 활성화 여부 확인
Step 2) /etc/hosts.equiv, $HOME/.rhosts 파일에 접근을 허용할 사용자 이름 또는 IP주소 설정
Step 3) /etc/hosts.equiv, $HOME/.rhosts 파일 권한을 600 이하로 설정
```

---

### U-37 (상) crontab 설정파일 권한 설정 미흡

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | crontab 및 at 서비스 관련 파일의 권한 적절성 여부 점검 |
| 점검 목적 | 관리자 외에는 서비스를 사용할 수 없도록 설정하고 있는지 점검하기 위함 |
| 보안 위험 | 일반 사용자가 crontab 및 at 서비스를 사용할 수 있을 경우, 고의 또는 실수로 불법적인 예약 파일 실행으로 시스템 피해를 일으킬 수 있는 위험이 존재함 |
| 참고 | ※ cron 시스템: 특정 작업을 정해진 시간에 주기적이고 반복적으로 실행하기 위한 데몬 및 설정<br>※ cron.allow: 사용자 ID를 등록하면 등록된 사용자는 crontab 명령어 사용이 가능함<br>※ cron.deny: 사용자 ID를 등록하면 등록된 사용자는 crontab 명령어 이용이 불가능함<br>※ at 서비스(일회성 작업 예약): 지정한 시간에 어떠한 작업이 실행될 수 있도록 작업 스케줄을 예약 처리해 주는 기능을 제공함. /etc/at.allow 파일에 등록된 사용자만이 at 명령을 사용할 수 있음<br>※ 기반시설 시스템에서 at 서비스의 이용은 원칙적으로 금지하나, 불가피하게 사용 시 소유자 및 권한 설정 등의 보안 조치를 반드시 적용해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: crontab 및 at 명령어에 일반 사용자 실행 권한이 제거되어 있으며, cron 및 at 관련 파일 권한이 640 이하인 경우<br>**취약**: crontab 및 at 명령어에 일반 사용자 실행 권한이 부여되어 있으며, cron 및 at 관련 파일 권한이 640 이상인 경우 |
| 조치 방법 | crontab 및 at 명령어 파일 권한 750 이하, cron 및 at 관련 파일 소유자 및 파일 권한 640 이하 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) crontab, cron 작업 목록 파일, cron 관련 파일 소유자 및 권한 확인
# ls -l /usr/bin/crontab
# ls -l /var/spool/cron/crontabs/<cron 작업 목록 파일>
# ls -l /etc/cron.d/<cron 관련 파일>

Step 2) at, at 작업 목록 파일 소유자 및 권한 확인
# ls -l /usr/bin/at
# ls -l /var/spool/cron/atjobs/<at 작업 목록 파일>

Step 3) crontab 파일 및 at 파일 소유자를 root로, 파일 권한을 750으로 변경
Step 4) cron 작업 목록 파일, cron 관련 파일 및 at 작업 목록 파일 소유자를 root로, 파일 권한을 640으로 변경
```

> ※ crontab 및 at 명령어는 SUID가 설정되어 있으므로 SUID 설정 제거 필요

**● LINUX**

```
Step 1) crontab, cron 작업 목록 파일, cron 관련 파일 소유자 및 권한 확인
# ls -l /usr/bin/crontab
# ls -l /var/spool/cron/<cron 작업 목록 파일>, # ls -l /var/spool/cron/crontabs/<cron 작업 목록 파일>
# ls -l /etc/<cron 관련 파일>

Step 2) at, at 작업 목록 파일 소유자 및 권한 확인
# ls -l /usr/bin/at
# ls -l /var/spool/at/<at 작업 목록 파일>, # ls -l /var/spool/cron/atjobs/<at 작업 목록 파일>

Step 3) crontab 파일 및 at 파일 소유자를 root로, 파일 권한을 750으로 변경
Step 4) cron 작업 목록 파일, cron 관련 파일 및 at 작업 목록 파일 소유자를 root로, 파일 권한을 640으로 변경
```

> ※ crontab 및 at 명령어는 SUID가 설정되어 있으므로 SUID 설정 제거 필요

**● AIX, HP-UX**

```
Step 1) crontab, cron 작업 목록 파일, cron 관련 파일 소유자 및 권한 확인
# ls -l /usr/bin/crontab
# ls -l /var/spool/cron/crontabs/<cron 작업 목록 파일>
# ls -l /var/adm/cron/<cron 관련 파일>

Step 2) at, at 작업 목록 파일 소유자 및 권한 확인
# ls -l /usr/bin/at
# ls -l /var/spool/cron/atjobs/<at 작업 목록 파일>

Step 3) crontab 파일 및 at 파일 소유자를 root로, 파일 권한을 750으로 변경
Step 4) cron 작업 목록 파일, cron 관련 파일 및 at 작업 목록 파일 소유자를 root로, 파일 권한을 640으로 변경
```

> ※ crontab 및 at 명령어는 SUID가 설정되어 있으므로 SUID 설정 제거 필요

| cron 관련 설정 파일 | 설명 |
| :--- | :--- |
| crontab | 예약 작업을 등록하는 파일 |
| cron.hourly | 시간 단위 예약 실행 스크립트 등록 파일 |
| cron.daily | 일 단위 예약 실행 스크립트 등록 파일 |
| cron.weekly | 주 단위 예약 실행 스크립트 등록 파일 |
| cron.monthly | 월 단위 예약 실행 스크립트 등록 파일 |
| cron.allow | crontab 명령어 허용 사용자 등록 파일 |
| cron.deny | crontab 명령어 차단 사용자 등록 파일 |
| /var/spool/cron 또는 /var/spool/cron/crontab | 사용자별 설정된 cron 작업 목록 |

> ※ cron.allow, cron.deny 두 파일 모두 존재하지 않을 시, root 계정만 cron 등록 가능

| at 관련 설정 파일 | 설명 |
| :--- | :--- |
| at | 예약 작업을 등록하는 파일 |
| at.allow | at 명령어 허용 사용자 등록 파일 |
| at.deny | at 명령어 차단 사용자 등록 파일 |
| /var/spool/at 또는 /var/spool/cron/atjobs | 사용자별 설정된 at 작업 목록 |

> ※ at.allow, at.deny 두 파일 모두 존재하지 않을 시, root 계정만 at 등록 가능

---

### U-38 (상) DoS 공격에 취약한 서비스 비활성화

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 사용하지 않는 DoS 공격에 취약한 서비스의 실행 여부 점검 |
| 점검 목적 | 많은 취약점을 가진 echo, discard, daytime, chargen, ntp, snmp 등의 서비스를 중지하여 시스템의 보안성을 높이기 위함 |
| 보안 위험 | 해당 서비스가 활성화된 경우, 시스템 정보 유출 및 DoS 공격의 대상이 될 수 있는 위험이 존재함 |
| 참고 | ※ DoS(Denial of Service attack): 시스템을 악의적으로 공격해 해당 시스템의 자원을 부족하게 하여 원래 의도된 용도로 사용하지 못하게 하는 공격. 특정 서버에게 수많은 접속 시도를 만들어 다른 이용자가 정상적으로 서비스 이용을 하지 못하게 하거나, 서버의 TCP 연결을 바닥내는 등의 공격이 이 범위에 포함됨 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: DoS 공격에 취약한 서비스가 비활성화된 경우<br>**취약**: DoS 공격에 취약한 서비스가 활성화된 경우 |
| 조치 방법 | echo, discard, daytime, chargen, ntp, dns, snmp 등의 서비스 비활성화 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) 서비스 대문 활성화 여부 확인
# inetadm | grep enable | egrep “echo|discard|daytime|chargen”

Step 2) 불필요한 서비스 대문 중지
# inetadm -d <중지하고자 하는 서비스 대문>
```

**● LINUX**

```
[inetd]
Step 1) /etc/inetd.conf 파일 내 서비스 활성화 여부 확인
서비스 대상: echo, discard, daytime, chargen

Step 2) /etc/inetd.conf 파일 수정(주석 제거)
예시) echo stream tcp nowait root internal

Step 3) inetd 서비스 재시작
# inetd

[xinetd]
Step 1) /etc/xinetd.d/<파일명> 파일 내 서비스 활성화 여부 확인
예시) service echo{
disable =no
...
}

Step 2) 서비스 비활성화
disable = yes

Step 3) 설정 적용 및 서비스 재시작
# service xinetd restart
```

```
Step 1) 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep -E “echo|discard|daytime|chargen”

Step 2) 서비스 중지
# systemctl stop <서비스명>

Step 3) 서비스 비활성화
# systemctl disable <서비스명>
```

**● AIX, HP-UX**

```
Step 1) /etc/inetd.conf 파일 내 서비스 활성화 여부 확인
대상 서비스: echo, discard, daytime, chargen

Step 2) /etc/inetd.conf 파일 수정(주석 처리)
# echo stream tcp nowait root internal
# discard stream tcp nowait root internal
# chargen stream tcp nowait root internal
# daytime stream tcp nowait root internal
# echo dgram udp wait root internal
# discard dgram udp wait root internal
# chargen dgram udp wait root internal
# daytime dgram udp wait root internal

Step 3) 설정 적용
[AIX] refresh -s inetd
[HP-UX] inetd -c
```

| DoS 공격에 취약한 서비스 예시 | | |
| :--- | :--- | :--- |
| 서비스 (포트) | 설명 | |
| echo (7) | 클라이언트에서 보내는 메시지를 단순히 재전송하는 서비스 | |
| discard (9) | 수신되는 임의 사용자의 데이터를 폐기하는 서비스 | |
| daytime (13) | 클라이언트의 질의에 응답하여 아스키 형태로 현재 시간과 날짜를 출력하는 서비스 | |
| chargen (19) | 임의 길이의 문자열을 반환하는 서비스 | |
| NTP (123) | 네트워크로 연결되어 있는 컴퓨터들끼리 시각을 동기화하는 서비스 | |
| DNS (53) | 호스트의 도메인 이름을 호스트의 네트워크 주소로 바꾸거나 그 반대의 변환을 수행하는 서비스 | |
| SNMP (161/162) | 네트워크 장비들로부터 필요한 정보를 가져와 장비 상태를 모니터링하거나, 설정값을 변경하는 등의 작업을 하여 네트워크 장비를 관리하는데 사용되는 서비스 | |
| SMTP (25) | 인터넷에서 메일을 보내기 위해 사용되는 서비스 | |

---

### U-39 (상) 불필요한 NFS 서비스 비활성화

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 불필요한 NFS 서비스 사용 여부 점검 |
| 점검 목적 | NFS(Network File System) 서비스는 한 서버의 파일을 많은 서비스 서버들이 공유하여 사용할 때 이용하는 서비스지만 이를 이용한 침해사고 위험성이 높으므로 사용하지 않는 경우 중지하기 위함 |
| 보안 위험 | NFS 서비스는 서버의 디스크를 클라이언트와 공유하는 서비스로 적정한 보안 설정이 적용되어 있지 않다면 불필요한 파일 공유로 인한 유출 위험이 존재함 |
| 참고 | ※ NFS(Network File System): 원격 컴퓨터의 파일 시스템을 로컬 시스템에 마운트하여 로컬 파일 시스템처럼 사용할 수 있는 프로그램<br>※ NFS 서비스 사용은 원칙적으로 금지되어 있지만 불가피하게 사용 시 필요한 경우 U-40 항목을 참조하여 통제해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 불필요한 NFS 서비스 관련 대문이 비활성화된 경우<br>**취약**: 불필요한 NFS 서비스 관련 대문이 활성화된 경우 |
| 조치 방법 | NFS 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>※ 로컬 서버에 마운트 되어 있는 디렉터리 제거 및 공유 디렉터리 제거 후 서비스 중지 가능 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) NFS 서비스 대문 활성화 확인
# inetadm | egrep “nfs|statd|lockd”

Step 2) 불필요한 서비스 대문 중지
# inetadm -d <중지하고자 하는 서비스 대문>
```

**● LINUX**

```
Step 1) NFS 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep nfs

Step 2) 불필요한 NFS 서비스 중지
# systemctl stop <서비스명>

Step 3) NFS 서비스 비활성화
# systemctl disable <서비스명>
```

**● AIX**

```
[process 被]
Step 1) NFS 프로세스 활성화 여부 확인
# ps -ef| grep nfsd

Step 2) NFS 서비스 관련 데몬 중지
# kill -9 <PID>

Step 3) NFS 시동 스크립트 위치 확인
# ls -al /etc/rc.d/rc*.d/* | grep nfs

Step 4) NFS 시동 스크립트 이름 변경
# mv /etc/rc.d/rc2.d/S60nfs /etc/rc.d/rc2.d/ S60nfs

[service 被]
Step 1) NFS 서비스 활성화 여부 확인
# lssrc -a | grep nfs

Step 2) NFS 서비스 관련 데몬 중지
# stopsrc -g nfs

Step 3) /etc/inittab 파일 수정(주석 처리)
# rcnfs:23456789:wait:/etc/rc.nfs > /dev/console # Start NFS Daemons

Step 4) /etc/inittab 파일 설정 적용
#init q
```

**● HP-UX**

```
Step 1) NFS 서비스 활성화 여부 확인 및 관련 데몬 PID 확인
# ps -ef| grep -E “nfsd|statd|lockd”

Step 2) NFS 서비스 관련 데몬 중지
# kill -9 <PID>

Step 3) /etc/rc.config.d/nfsconf 파일 수정
NFS_SERVER=0

Step 4) 설정 적용
# /usr/sbin/nfs.server start
```

---

### U-40 (상) NFS 접근 통제

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | NFS(Network File System)의 접근 통제 설정 적용 여부 점검 |
| 점검 목적 | 접근 권한이 없는 비인가자의 접근을 통제하기 위함 |
| 보안 위험 | 접근 통제 설정이 적절하지 않을 경우, 인증 절차 없이 비인가자가 디렉터리나 파일의 접근이 가능하며, 해당 공유 시스템에 원격으로 마운트하여 중요 파일을 변조하거나 유출할 위험이 존재함 |
| 참고 | ※ NFS 서비스 사용 금지가 원칙이나, 불가피하게 사용 시 NFS v2, v3는 평문으로 전송되는 취약점이 있으므로 암호화되는 v4를 사용하는 것을 권고함<br>※ NFS 서비스를 사용해야 하는 경우, NFS 설정 파일에 꼭 필요한 디렉터리만 설정하고, 허가된 사용자만 접근할 수 있도록 올바른 접근 통제를 설정해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 접근 통제가 설정되어 있으며 NFS 설정 파일 접근 권한이 644 이하인 경우<br>**취약**: 접근 통제가 설정되어 있지 않고 NFS 설정 파일 접근 권한이 644를 초과하는 경우 |
| 조치 방법 | • NFS 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• 불가피하게 사용 시 접근 통제 설정 및 NFS 설정 파일 접근 권한 644 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) 파일 소유자 및 권한 확인
# ls -l /etc/dfs/dfstab
# ls -l /etc/dfs/sharetab

Step 2) /etc/dfs/dfstab 파일 내 공유 중인 디렉터리에 접근할 수 있는 사용자 및 부여 권한 확인
Step 3) 파일 소유자를 root로 변경
# chown root /etc/dfs/dfstab

Step 4) 파일 권한을 644로 변경
# chmod 644 /etc/dfs/dfstab

Step 5) /etc/dfs/dfstab 파일에 디렉터리 공유를 허용할 사용자 및 해당 사용자의 권한 설정
예시) 사용자의 읽기, 쓰기 권한 접속 허용 : share -F nfs -o rw, ro /export/home/example
사용자의 권한 접속 제한 : share -F nfs -o rw=client1:client2, ro=client1:client2 /export/home/example

Step 6) NFS 서비스 설정 적용
# shareall
```

> ※ 읽기(ro), 쓰기(rw) 권한에 각각 사용자를 설정하여야 읽기, 쓰기 권한 모두 제한 가능

**● LINUX**

```
Step 1) 파일 소유자 및 권한 확인
# ls -l /etc/exports

Step 2) /etc/exports 파일 내 공유 중인 디렉터리에 접근할 수 있는 사용자 및 부여 권한 확인
# cat /etc/exports

Step 3) 파일 소유자를 root로 변경
# chown root /etc/exports

Step 4) 파일 권한을 644로 변경
# chmod 644 /etc/exports

Step 5) /etc/exports 파일에 디렉터리 공유를 허용할 사용자 및 해당 사용자의 권한 설정
예시) /home/example host1 (ro, root_squash)

Step 6) NFS 서비스 설정 적용
# exportfs -ra
```

**● AIX**

```
Step 1) 파일 소유자 및 권한 확인
# ls -l /etc/exports

Step 2) /etc/exports 파일 내 공유 중인 디렉터리에 접근할 수 있는 사용자 및 부여 권한 확인
# cat /etc/exports

Step 3) 파일 소유자를 root로 변경
# chown root /etc/exports

Step 4) 파일 권한을 644로 변경
# chmod 644 /etc/exports

Step 5) /etc/exports 파일에 디렉터리 공유를 허용할 사용자 및 해당 사용자의 권한 설정
예시) /home/example -sec=sys:krb5p:krb5i:krb5:dh,ro=host1, access=host1

Step 6) NFS 서비스 재시작
# exportfs -u, exportfs -a
```

**● HP-UX**

```
[/etc/dfs/dfstab]
Step 1) 파일 소유자 및 권한 확인
# ls -l /etc/dfs/dfstab
# ls -l /etc/dfs/sharetab

Step 2) /etc/dfs/dfstab 파일 내 공유 중인 디렉터리에 접근할 수 있는 사용자 및 부여 권한 확인
# cat /etc/dfs/dfstab

Step 3) 파일 소유자를 root로 변경
# chown root /etc/dfs/dfstab

Step 4) 파일 권한을 644로 변경
# chmod 644 /etc/dfs/dfstab

Step 5) /etc/dfs/dfstab 파일에 디렉터리 공유를 허용할 사용자 및 해당 사용자의 권한 설정
예시) 사용자의 읽기, 쓰기 권한 접속 허용 : share -F nfs -o rw, ro /export/home/example
사용자의 권한 접속 제한 : share -F nfs -o rw=client1:client2, ro=client1:client2 /export/home/example

Step 6) NFS 서비스 설정 적용
# shareall
```

> ※ 읽기(ro), 쓰기(rw) 권한에 각각 사용자를 설정하여야 읽기, 쓰기 권한 모두 제한 가능

```
[/etc/exports]
Step 1) 파일 소유자 및 권한 확인
# ls -l /etc/exports

Step 2) /etc/exports 파일 내 디렉터리에 접근할 수 있는 사용자 및 부여 권한 확인
# cat /etc/exports

Step 3) 파일 소유자를 root로 변경
# chown root /etc/exports

Step 4) 파일 권한을 644로 변경
# chmod 644 /etc/exports

Step 5) /etc/exports 파일에 디렉터리 공유를 허용할 사용자 및 해당 사용자의 권한 설정
Step 6) NFS 서비스 재시작
# exportfs -ra
```

---

### U-41 (상) 불필요한 automountd 제거

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | automountd 서비스 데몬의 실행 여부 점검 |
| 점검 목적 | 로컬 공격자가 automountd 데몬에 RPC(Remote Procedure Call)를 보낼 수 있는 취약점이 존재하기 때문에 해당 서비스를 중지시키기 위함 |
| 보안 위험 | 파일 시스템의 마운트 옵션을 변경하여 root 권한을 획득할 수 있으며, 로컬 공격자가 automountd 프로세스 권한으로 임의의 명령을 실행할 수 있는 위험이 존재함 |
| 참고 | ※ automountd: 클라이언트에서 자동으로 서버에 마운트를 시키고 일정 시간 사용하지 않으면 unmount 시켜 주는 기능을 말함<br>※ RPC(Remote Procedure Call): 별도의 원격 제어를 위한 코딩 없이 다른 주소 공간에서 함수나 프로시저를 실행할 수 있게 하는 프로세스 간 프로토콜 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: automountd 서비스가 비활성화된 경우<br>**취약**: automountd 서비스가 활성화된 경우 |
| 조치 방법 | automountd 서비스 비활성화 설정 |
| 조치 시 영향 | NFS 및 상버(Samba) 서비스에서 사용 시 automountd 사용 여부 확인이 필요하며, 적용 시 CD-ROM의 자동 마운트는 이뤄지지 않음 (/etc/auto.*, /etc/auto_* 파일을 확인하여 필요 여부 확인) |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) automount 서비스 데몬 확인
#svcs -a | grep autofs

Step 2) autofs 서비스 데몬 확인
# svcs -l svc:/system/filesystem/autofs:default

Step 3) 서비스 데몬 중지
# svcadm disable <중지하고자 하는 서비스 데몬>

Step 4) automount 또는 autofs 데몬 제거
# pkg uninstall <삭제할 관련 데몬의 패키지명>
```

**● HP-UX**

```
Step 1) automount 또는 autofs 서비스 활성화 여부 확인
# ps -ef | grep automount
# ps -ef | grep autofs

Step 2) automount 또는 autofs 서비스 중지
# kill -9 <PID>

Step 3) /etc/rc.config.d/nfsconf 파일 수정
AUTOFS=0
```

---

### U-42 (상) 불필요한 RPC 서비스 비활성화

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 불필요한 RPC 서비스의 실행 여부 점검 |
| 점검 목적 | 많은 취약점(버퍼 오버플로우, DoS, 원격 실행 등)이 존재하는 RPC 서비스를 비활성화하여 시스템의 보안성을 높이기 위함 |
| 보안 위험 | RPC 서비스의 취약점을 통해 비인가자가 root 권한 획득 및 각종 공격을 시도할 위험이 존재함 |
| 참고 | ※ 불필요한 RPC 서비스: rpc.cmsd, rpc.ttdbserverd, sadmind, rusersd, walld, sprayd, rstatd, rpc.nisd, rexd, rpc.pcnfsd, rpc.statd, rpc.ypudated, rpc.rquoted, kcms_server, cachefsd |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 불필요한 RPC 서비스가 비활성화된 경우<br>**취약**: 불필요한 RPC 서비스가 활성화된 경우 |
| 조치 방법 | 불필요한 RPC 서비스 중지 및 비활성화 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) RPC 서비스 관련 대문 확인
# inetadm | grep rpc | grep enabled | egrep “ttdbserver|rex|rstart|rusers|spray|wall|rquota”

Step 2) 불필요한 RPC 서비스 확인
# inetadm | egrep “ttbd|rex|rstat|ruser|spray|wall|rquoat”

Step 3) 서비스 대문 중지
# svcadm disable <서비스 대문>
```

**● LINUX**

```
[inetd]
Step 1) /etc/inetd.conf 파일 내 불필요한 RPC 서비스 활성화 여부 확인
# cat /etc/inetd.conf

Step 2) etc/inetd.conf 파일 수정(주석 처리)
#rpc.cmsd/2-4 dgram rpc/udp wait root /usr/dt/bin/rpc.cmsd rpc.cmsd

Step 3) inetd 서비스 재시작
# systemctl restart inetd

[xinetd]
Step 1) /etc/xinetd.d/ 디렉터리 내 존재하는 블필요한 RPC 서비스 활성화 여부 확인
#cat /etc/xinetd.d/<파일명>
예시) service rpc-stad{
disable = no
...
}

Step 2) /etc/xinetd.d/ 디렉터리 내 존재하는 블필요한 rpc 파일을 열어 disable 설정값 수정
disable = yes

Step 3) 설정 적용 및 서비스 재시작
# systemctl restart xinetd

[systemd]
Step 1) 블필요한 RPC 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep rpc

Step 2) 블필요한 RPC 서비스 중지
# systemctl stop <서비스명>

Step 3) 블필요한 RPC 서비스 비활성화
# systemctl disable <서비스명>
```

**● AIX, HP-UX**

```
Step 1) /etc/inetd.conf 파일 내 블필요한 RPC 서비스 활성화 여부 확인
Step 2) /etc/inetd.conf 파일 수정(주석 처리)
# rexd sunrpc_tcp tcp wait root /usr/sbin/rpc.rexd rexd 100017 1
# rstatd sunrpc_udp udp wait root /usr/sbin/rpc.rstatd rstatd 100001 1-3

Step 3) inetd 설정 적용
[AIX] refresh –s inetd
[HP-UX] inetd –c
```

---

### U-43 (상) NIS, NIS+ 점검

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 안전하지 않은 NIS 서비스의 비활성화, 안전한 NIS+ 서비스의 활성화 여부 점검 |
| 점검 목적 | 안전하지 않은 NIS 서비스를 비활성화하고 안전한 NIS+ 서비스를 활성화하여 시스템의 보안성을 높이기 위함 |
| 보안 위험 | NIS 서비스가 활성화된 경우, 비인가자가 타 시스템의 root 권한까지 탈취할 수 있는 위험이 존재함 |
| 참고 | ※ NIS 주 서버는 정보표를 소유하여 NIS 대응 파일들로 변환하고, 이 대응 파일들이 네트워크를 통해 제공됨으로써 모든 컴퓨터에 정보가 갱신되도록 함. 네트워크를 통한 공유로부터 관리자와 사용자들에게 일관성 있는 시스템 환경을 제공함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: NIS 서비스가 비활성화되어 있거나, 불가피하게 사용 시 NIS+ 서비스를 사용하는 경우<br>**취약**: NIS 서비스가 활성화된 경우 |
| 조치 방법 | NIS 관련 서비스 비활성화 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) NIS 서비스 대문 구동 여부 확인
# svcs -a |grep nis

Step 2) NIS 관련 서비스 대문 확인
# svcs -a | grep nis

Step 3) NIS 서비스 대문 중지
# svcadm disable <서비스 대문>
```

**● LINUX**

```
Step 1) NIS 관련 서비스 대문 활성화 여부 확인
# systemctl list-units --type=service | grep -E "ypserv\ypbind\ypxfrd\rpc.yppasswd\rpc.ypupdated"

Step 2) NIS 관련 서비스 데몬 중지
# systemctl stop <서비스명>

Step 3) NIS 관련 서비스 데몬 비활성화
# systemctl disable <서비스명>
```

> ※ Redhat 계열 리눅스는 RHEL 8 버전부터 NIS(yp rpm) 패키지가 제거되었음

**● AIX**

```
[process 被接]
Step 1) NIS 관련 서비스 데몬 활성화 여부 확인
# ps -ef | grep -E “/pserv/ypbind/ypxfrdf/rpc.yppasswd/rpc.ypupdated”

Step 2) NIS 관련 서비스 중지
# kill -9 <PID>

Step 3) NIS 관련 서비스 시동 스크립트 위치 확인
# ls -al /etc/rc.d/rc*.d/* | grep -E “/pserv/ypbind/ypxfrdf/rpc.yppasswd/drpc.ypupdated”

Step 4) NIS 관련 서비스 시동 스크립트 이름 변경
# mv /etc/rc.d/rc2.d/S73ypbind /etc/rc.d/rc2.d/_S73ypbind

[service 被接]
Step 1) NIS 관련 서비스 데몬 활성화 여부 확인
# lssrc -a | grep -E “/pserv/ypbind/ypxfrdf/rpc.yppasswd/drpc.ypupdated”

Step 2) NIS 관련 서비스 중지
# stopsrc -s <NIS 관련 서비스명>

Step 3) etc/inittab 파일 수정(주석 처리)
#/pserv:2:wait:/usr/lib/netsvc/yp/pserv >> /dev/console 2>&1
#/ypbind:2:wait:/usr/lib/netsvc/yp/ypbind >> /dev/console 2>&1

Step 4) /etc/inittab 파일 설정 적용
# init q
```

**● HP-UX**

```
Step 1) NIS 관련 서비스 데몬 활성화 여부 확인
# ps -ef | grep -E "ypserv|ypbind|ypxfrd|rpc.yppasswdd|rpc.ypupdated"

Step 2) NIS 관련 서비스 중지
# kill -9 <PID>

Step 3) etc/rc.config.d/namesrvfs 파일 수정
NIS_MASTER_SERVER=0
NIS_SLAVE_SERVER=0
NIS_CLIENT_SERVER=0
```

| NIS 관련 서비스 대문 | 설명 |
| :--- | :--- |
| ypserv | master와 slave 서버에서 실행되며 클라이언트로부터의 ypbind 요청에 응답 |
| ypbind | 모든 NIS 시스템에서 실행되며 클라이언트와 서버를 바인딩하고 초기화함 |
| rpc.yppasswdd | 사용자들이 비밀번호를 변경하기 위해 사용 |
| ypxfrd | NIS 마스터 서버에서만 실행되며 고속으로 NIS 맵 전송 |
| rpc.ypupdated | NIS 마스터 서버에서만 실행되며 고속으로 암호화하여 NIS 맵 전송 |

---

### U-44 (상) tftp, talk 서비스 비활성화

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | tftp, talk, ntalk 서비스의 활성화 여부 점검 |
| 점검 목적 | 안전하지 않거나 불필요한 서비스를 제거함으로써 시스템 보안성 및 리소스의 효율적 운용하기 위함 |
| 보안 위험 | 사용하지 않는 서비스나 취약점이 발표된 서비스 운용 시 공격 시도 가능한 위험이 존재함 |
| 참고 | ※ tftp: 파일 전송을 위한 프로토콜로서 FTP 서비스보다 구조가 단순하며 적은 양의 데이터를 보낼 때 사용됨. 주로 원격의 부팅 파일을 불러오거나 설치 프로세스를 시작하기 위한 초기 데이터 호출 용도로 사용. 서비스 사용 시 인증 절차가 없어 보안에 취약함<br>※ talk: 사용자가 시스템에 원격으로 연결하여 다른 시스템에 로그인하고 있는 사용자와 대화 세션을 시작할 수 있음<br>※ ntalk: 서로 다른 시스템 간에 채팅을 가능하게 하는 서비스 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: tftp, talk, ntalk 서비스가 비활성화된 경우<br>**취약**: tftp, talk, ntalk 서비스가 활성화된 경우 |
| 조치 방법 | 불필요한 tftp, talk, ntalk 서비스 비활성화 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) tftp, talk 서비스 활성화 여부 확인
# inetadm | egrep “tftp\talk”

Step 2) 불필요한 서비스 대문 증지
# inetadm -d <서비스 대문명>
```

**● LINUX**

```
[inetd]
Step 1) /etc/inetd.conf 파일 내 tftp, talk, ntalk 서비스 활성화 여부 확인
# cat /etc/inetd.conf

Step 2) /etc/inetd.conf 파일 수정(주석 처리)
#tftp dgram udp nobody /usr/sbin/tftpdt tftpdt -n
#talk stream tcp wait root /usr/sbin/talkd talkd
#ntalk dgram udp wait root /usr/sbin/talkd talkd

Step 3) inetd 서비스 재시작
# systemctl restart inetd

[xinetd]
Step 1) /etc/xinetd.d/ 디렉터리 내 존재하는 tftp, talk, ntalk 파일에 대해 서비스 활성화 여부 확인
예시) service tftp{
disable = no
...
}

Step 2) /etc/xinetd.d/ 디렉터리 내 존재하는 tftp, talk, ntalk 파일에 대한 설정값 변경
disable = yes

Step 3) 설정 적용 및 서비스 재시작
# systemctl restart xinetd

[systemd]
Step 1) 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep -E “tftp|talk|ntalk”

Step 2) tftp, talk, ntalk 서비스 중지
systemctl stop <서비스명>

Step 3) tftp, talk, ntalk 서비스 비활성화
# systemctl disable <서비스명>
```

> ※ Redhat 계열 리눅스는 RHEL 7 버전부터 talk 패키지가 제거되었음

**● AIX, HP-UX**

```
Step 1) 서비스 활성화 여부 확인
# /etc/inetd.conf| grep -E “tftp|talk|ntalk” tftp, talk, ntalk

Step 2) /etc/inetd.conf 파일 수정(주석 처리)
#tftp dgram udp6 SRC nobody /usr/sbin/tftpdtftp-d
#talk dgram udp wait root /usr/sbin/talkd talkd
#ntalk dgram udp wait root /usr/sbin/talkd talkd

Step 3) intetd 설정 적용
[AIX] refresh -s inetd
[HP-UX] inetd -c
```

| 서비스 (포트) | 설명 |
| :--- | :--- |
| TFTP (69) | 파일 전송을 위한 프로토콜로써 FTP 서비스보다 구조가 단순하며 적은 양의 데이터를 보낼 때 사용됨. 주로 원격의 부팅 파일을 불러오거나 설치 프로세스를 시작하기 위한 초기 데이터 호출 용도로 사용함. 서비스 사용 시 인증 절차가 없어 보안에 취약함 |
| TALK (517) | 사용자가 시스템에 원격으로 연결하여 다른 시스템에 로그인하고 있는 사용자와 대화 세션을 시작할 수 있음 |
| NTALK (518) | 서로 다른 시스템과 채팅을 가능하게 하는 서비스 |

---

### U-45 (상) 메일 서비스 버전 점검

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 취약한 버전의 메일 서비스 이용 여부 점검 |
| 점검 목적 | 메일 서비스 사용 목적 검토 및 취약점이 없는 버전의 사용 유무 점검으로 최적화된 메일 서비스의 운영하기 위함 |
| 보안 위험 | 취약점이 발견된 메일 버전의 경우 버퍼 오버플로우(Buffer Overflow) 공격에 의한 시스템 권한 획득 및 주요 정보 노출의 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 메일 서비스 버전이 최신 버전인 경우<br>**취약**: 메일 서비스 버전이 최신 버전이 아닌 경우 |
| 조치 방법 | • 메일 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• 메일 서비스 사용 시 패치 관리 정책을 수립하여 주기적으로 패치 적용 설정 |
| 조치 시 영향 | 패치 적용 시 시스템 및 서비스의 영향 정도를 충분히 고려해야 함 |

#### 점검 및 조치 사례

**● SOLARIS**

```
[Sendmail 메일 서비스를 사용하는 경우]
Step 1) Sendmail 버전 확인
# /usr/sbin/sendmail -d grep Version

Step 2) 최신 버전 확인 및 보안 패치 진행
Sendmail 홈페이지(http://www.sendmail.org/)에 접속하여 다운로드 및 보안 패치 적용

[Sendmail 메일 서비스를 사용하지 않는 경우]
Step 1) Sendmail 서비스 활성화 여부 확인
# svcs -a | grep sendmail

Step 2) Sendmail 서비스 비활성화
# svcadm disable sendmail

[Postfix 메일 서비스를 사용하는 경우]
Step 1) Postfix 버전 확인
# /usr/lib/postfix/postconf| grep mail_version

Step 2) 최신 버전 확인 및 보안 패치 진행
postfix 홈페이지에 접속하여 해당 OS 패키지 주소로 접속 후 다운로드 및 보안 패치 적용

[Postfix 메일 서비스를 사용하지 않는 경우]
Step 1) Postfix 서비스 활성화 여부 확인
# svcs -a | grep postfix

Step 2) Postfix 서비스 비활성화
# svcadm disable postfix

[Exim 메일 서비스를 사용하는 경우]
Step 1) Exim 버전 확인
# usr/sbin/exim -bV

Step 2) 최신 버전 확인 및 보안 패치 진행
Exim 홈페이지에 접속하여 다운로드 및 보안 패치 적용

[Exim 메일 서비스를 사용하지 않는 경우]
Step 1) Exim 서비스 활성화 여부 확인
# svcs -a | grep exim

Step 2) Exim 서비스 비활성화
# svcadm disable exim
```

**● LINUX**

```
[Sendmail 메일 서비스를 사용하는 경우]
Step 1) Sendmail 버전 확인
# sendmail -d0 -bt

Step 2) 최신 버전 확인 및 보안 패치 진행
Sendmail 홈페이지에 접속하여 다운로드 및 보안 패치 적용

[Sendmail 메일 서비스를 사용하지 않는 경우]
Step 1) Sendmail 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep sendmail

Step 2) Sendmail 서비스 중지
# systemctl stop sendmail

Step 3) Sendmail 서비스 비활성화
# systemctl disable sendmail

[Postfix 메일 서비스를 사용하는 경우]
Step 1) Postfix 버전 확인
# postconf mail_version

Step 2) 최신 버전 확인 및 보안 패치 진행
postfix 홈페이지에 접속하여 해당 OS 패키지 주소로 접속 후 다운로드 및 보안 패치 적용

[Postfix 메일 서비스를 사용하지 않는 경우]
Step 1) Postfix 서비스 활성화 여부 및 PID 확인
# ps -ef | grep postfix

Step 2) Postfix 서비스 종료
# kill -9 <PID>

[Exim 메일 서비스를 사용하는 경우]
Step 1) Exim 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep exim

Step 2) 최신 버전 확인 및 보안 패치 진행
Exim 홈페이지에 접속하여 다운로드 및 보안 패치 적용

[Exim 메일 서비스를 사용하지 않는 경우]
Step 1) Exim 서비스 활성화 여부 및 PID 확인
# ps -ef | grep exim

Step 2) Exim 서비스 종료
```

**● AIX**

```
[Sendmail 메일 서비스를 사용하는 경우]
Step 1) Sendmail 버전 확인
# sendmail -d0 -bt

Step 2) 최신 버전 확인 및 보안 패치 진행
Sendmail 홈페이지(http://www.sendmail.org/)에 접속하여 다운로드 및 보안 패치 적용

[Sendmail 메일 서비스를 사용하지 않는 경우]
Step 1) Sendmail 서비스 활성화 여부 확인
# lssrc -a | grep sendmail

Step 2) Sendmail 서비스 중지
# stopsrc -s sendmail

Step 3) /etc/rc.tcpip 파일 수정(주석 처리)
#start /usr/lib/sendmail “$src_running” “-bd -q${qpi)”

[Postfix 메일 서비스를 사용하는 경우]
Step 1) Postfix 버전 확인
# postconf mail_version

Step 2) 최신 버전 확인 및 보안 패치 진행
postfix 홈페이지에 접속하여 해당 OS 패키지 주소로 접속 후 다운로드 및 보안 패치 적용

[Postfix 메일 서비스를 사용하지 않는 경우]
Step 1) Postfix 서비스 활성화 여부 및 PID 확인
# ps -ef | grep postfix

Step 2) Postfix 서비스 종료
# kill -9 <PID>

[Exim 메일 서비스를 사용하는 경우]
Step 1) Exim 버전 확인
# exim -bV

Step 2) 최신 버전 확인 및 보안 패치 진행
Exim 홈페이지에 접속하여 다운로드 및 보안 패치 적용

[Exim 메일 서비스를 사용하지 않는 경우]
Step 1) Exim 서비스 활성화 여부 및 PID 확인
# ps -ef| grep exim

Step 2) Exim 서비스 종료
# kill -9 <PID>
```

**● HP-UX**

```
[Sendmail 메일 서비스를 사용하는 경우]
Step 1) Sendmail 버전 확인
# sendmail -d0 -bt

Step 2) 최신 버전 확인 및 보안 패치 진행
Sendmail 홈페이지에 접속하여 다운로드 및 보안 패치 적용

[Sendmail 메일 서비스를 사용하지 않는 경우]
Step 1) Sendmail 서비스 활성화 여부 및 PID 확인
# ps -ef| grep sendmail

Step 2) Sendmail 서비스 종료
# kill -9 <PID>

Step 3) /etc/rc.config.d/mailservs 파일 수정
SENDMAIL_SERVER=0

[Postfix 메일 서비스를 사용하는 경우]
Step 1) Postfix 버전 확인
# postconf mail_version

Step 2) 최신 버전 확인 및 보안 패치 진행
postfix 홈페이지에 접속하여 해당 OS 패키지 주소로 접속 후 다운로드 및 보안 패치 적용

[Postfix 메일 서비스를 사용하지 않는 경우]
Step 1) Postfix 서비스 활성화 여부 및 PID 확인
# ps -ef| grep postfix

Step 2) Postfix 서비스 종료
# kill -9 <PID>

[Exim 메일 서비스를 사용하는 경우]
Step 1) Exim 버전 확인
# exim -bV

Step 2) 최신 버전 확인 및 보안 패치 진행
Exim 홈페이지에 접속하여 다운로드 및 보안 패치 적용

[Exim 메일 서비스를 사용하지 않는 경우]
Step 1) Exim 서비스 활성화 여부 및 PID 확인
# ps -ef| grep exim

Step 2) Exim 서비스 종료
# kill -9 <PID>
```

---

### U-46 (상) 일반 사용자의 메일 서비스 실행 방지

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | SMTP 서비스 사용 시 일반 사용자의 q 옵션 제한 여부 점검 |
| 점검 목적 | 일반 사용자의 q 옵션을 제한하여 메일 서비스 설정 및 메일 큐를 강제적으로 drop 시킬 수 없게 하여 비인가자에 의한 SMTP 서비스 오류 방지하기 위함 |
| 보안 위험 | 일반 사용자가 q 옵션을 이용해서 메일 큐, 메일 서비스 설정을 보거나 메일 큐를 강제적으로 drop 시킬 수 있어 악의적으로 SMTP 서버의 오류를 발생시킬 위험이 존재함 |
| 참고 | ※ SMTP(Simple Mail Transfer Protocol): 인터넷상에서 전자우편(E-mail)을 전송할 때 이용하게 되는 표준 통신 규약을 말함 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 일반 사용자의 메일 서비스 실행 방지가 설정된 경우<br>**취약**: 일반 사용자의 메일 서비스 실행 방지가 설정되어 있지 않은 경우 |
| 조치 방법 | • 메일 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• 메일 서비스 사용 시 메일 서비스의 q 옵션 제한 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
[Sendmail]
Step 1) /etc/mail/sendmail.cf 파일 내 PrivacyOptions 설정에 restrictqrun 값 추가
PrivacyOptions = authwarnings, novrfy, noexpn, restrictqrun

Step 2) Sendmail 서비스 재시작

[Postfix]
Step 1) 일반 사용자 실행 권한 확인
# ls -l /usr/sbin/postsuper

Step 2) 일반 사용자 실행 권한 제거
# chmod o-x /usr/sbin/postsuper

[Exim]
Step 1) 일반사용자실행권한확인
# ls -l /usr/sbin/exiqgrep

Step 2) 일반사용자실행권한제거
# chmod o-x /usr/sbin/exiqgrep
```

---

### U-47 (상) 스펜 메일 릴레이 제한

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | SMTP 서버의 릴레이 기능 제한 여부 점검 |
| 점검 목적 | 스펜 메일 서버로의 악용 방지 및 서버 과부하를 방지하기 위함 |
| 보안 위험 | SMTP 서버의 릴레이 기능을 제한하지 않을 경우, 악의적인 사용 목적을 가진 사용자들이 스펜 메일 서버로 사용하거나 DoS 공격의 위험이 존재함 |
| 참고 | ※ SMTP(Simple Mail Transfer Protocol) 서버: SMTP에 의해 전자 메일을 발신하는 서버(server)를 SMTP 서버라고 함<br>※ 메일 서비스를 사용하지 않는 경우 양호 또는 N/A |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 릴레이 제한이 설정된 경우<br>**취약**: 릴레이 제한이 설정되어 있지 않은 경우 |
| 조치 방법 | • 메일 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• 메일 서비스 사용 시 릴레이 방지 설정 또는 릴레이 대상 접근 제어 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
[Sendmail 8.9 이상 버전]
Step 1) /etc/mail/sendmail.cf 파일 내 릴레이 허용 설정 여부 확인
Step 2) /etc/mail/sendmail.mc 파일 수정
FEATURE('promiscuous_relay')dnl <해당 설정 제거>

Step 3) sendmail.cf 설정 파일 재생성
# m4 /etc/mail/sendmail.mc > /etc/mail/sendmail.cf

Step 4) /etc/mail/access 파일에 특정 IP, Domain, Email 주소, 네트워크에 대한 접근제한 설정
예시) localhost.localdomain RELAY
localhost RELAY
127.0.0.1 RELAY
spam.com REJECT

- /etc/mail/access 파일을 생성하거나 수정하였을 경우 # makemap hash /etc/mail/access.db < /etc/mail/access 명령으로 DB 파일 생성

Step 5) 설정 적용 및 재시작
# systemctl restart sendmail
```

> ※ Sendmail 8.9 이상 버전부터는 기본적으로 스팸 메일 릴레이 제한 설정이 적용됨

```
[Sendmail 8.9 미만 버전]
Step 1) /etc/mail/sendmail.cf 파일 내 릴레이 제한 설정 확인
# cat /etc/mail/sendmail.cf | grep “R$\*” | grep “Relaying denied”

Step 2) /etc/mail/sendmail.cf 파일 수정
# R$* $#error $@ 5.7.1 $: “550 Relaying denied”

Step 3) /etc/mail/access 파일에 특정 IP, Domain, Email 주소, 네트워크에 대한 접근제한 설정
예시) localhost.localdomain RELAY
localhost RELAY
127.0.0.1 RELAY
spam.com REJECT

Step 4) Sendmail 서비스 재시작
```

> ※ 파일이 존재하지 않는 경우 생성하여 설정
> ※ /etc/mail/access 파일을 생성하거나 수정하였을 경우 # makemap hash /etc/mail/access.db < /etc/mail/access 명령으로 DB 파일 생성

```
[Postfix]
Step 1) /etc/postfix/main.cf 파일 내 릴레이 정책 설정 확인
# cat /etc/postfix/main.cf | grep -E “smtpd_recipient_restrictions|mynetworks”

Step 2) /etc/postfix/main.cf 파일 수정
mynetworks = <하용할 네트워크 주소>

Step 3) 설정 적용
# postfix reload
```

```
[Exim]
Step 1) /etc/exim/exim.conf, /etc/exim4/exim4.conf 파일 내 릴레이 설정이 허용된 네트워크 주소 확인
cat <파일명> | grep -E “relay_from_hosts|hosts =”

Step 2) /etc/exim/exim.conf 또는 /etc/exim4/exim4.conf 파일 수정
hostlist relay_from_hosts = <허용할 네트워크 주소>
accept hosts = +relay_from_hosts 또는 <허용할 네트워크 주소>

Step 3) Exim 서비스 재시작
```

---

### U-48 (중) expn, vrfy 명령어 제한

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | SMTP 서비스 사용 시 expn, vrfy 명령어 사용 금지 설정 여부 점검 |
| 점검 목적 | SMTP 서비스의 expn, vrfy 명령을 통한 정보 유출을 방지하기 위함 |
| 보안 위험 | expn, vrfy 명령어를 통하여 특정 사용자 계정의 존재 여부를 알 수 있고, 사용자의 정보를 외부로 유출할 수 있는 위험이 존재함 |
| 참고 | ※ expn(메일링 리스트 확장): 메일 전송 시 포함되하기 위한 명령어<br>※ vrfy: SMTP 클라이언트가 SMTP 서버에 특정 아이디에 대한 메일이 있는지 검증하기 위해 보내는 명령어<br>※ goway: authwarnings, noexpn, novrfy, noveb, needmailhelo, needexpnhelo, needvrfyhelo, nobodyreturn 옵션을 통합한 단축 옵션<br>※ 메일 서비스를 사용하지 않는 경우 양호 또는 N/A |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: noexpn, novrfy 옵션이 설정된 경우<br>**취약**: noexpn, novrfy 옵션이 설정되어 있지 않은 경우 |
| 조치 방법 | • 메일 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• 메일 서비스 사용 시 메일 서비스 설정 파일에 noexpn, novrfy 또는 goaway 옵션 추가 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
[Sendmail]
Step 1) /etc/mail/sendmail.cf 파일 내 PrivacyOptions 설정 확인
Step 2) PrivacyOptions 옵션 수정
PrivacyOptions = authwarnings, novrfy, noexpn, restrictqrun
또는
PrivacyOptions = restrictqrun, goaway

Step 3) Sendmail 서비스 재시작
```

> ※ goaway : authwarnings, noexpn, novrfy, noveb, needmailhelo, needexpnhelo, needvrfyhelo, nobodyreturn 기능이 통합된 단축 옵션

```
[Postfix]
Step 1) /etc/postfix/main.cf 파일 내 vrfy 설정 확인
Step 2) disable_vrfy_command 옵션을 yes로 수정
disable_vrfy_command = yes

Step 3) postfix 설정 적용 및 재시작
# postfix reload
```

> ※ Postfix는 기본적으로 expn 기능 및 설정을 허용하지 않음

```
[Exim]
Step 1) /etc/exim/exim.conf 또는 /etc/exim4/exim4.conf 파일 내 expn, vrfy 설정 확인
Step 2) 해당 옵션이 허용된 경우 설정 제거
acl_smtp_vrfy = accept
acl_smtp_expn = accept

주석 처리 혹은 명령어 줄 삭제

Step 3) Exim 서비스 재시작
```

---

### U-49 (상) DNS 보안 버전 패치

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | BIND 최신 버전 사용 유무 및 주기적 보안 패치 여부 점검 |
| 점검 목적 | 취약점이 발표되지 않은 BIND 버전을 사용하여 시스템 보안성을 높이기 위함 |
| 보안 위험 | 취약점이 내포된 BIND 버전을 사용할 경우, DoS 공격, 버퍼 오버플로우(Buffer Overflow) 및 DNS 서버 원격 침입 등의 위험이 존재함 |
| 참고 | ※ BIND(Berkeley Internet Name Domain): BIND는 BSD 기반의 유닉스 시스템을 위해 설계된 DNS로 서버와 resolver 라이브러리로 구성되어 있음. 내일 서버는 클라이언트들이 이름 자원들이나 Object들에 접근하여, 네트워크 내의 다른 Object들과 함께 정보를 공유할 수 있게 해주는 네트워크 서비스로 사실상 컴퓨터 네트워크 내의 Object들을 위한 분산 데이터베이스 시스템임 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: 주기적으로 패치를 관리하는 경우<br>**취약**: 주기적으로 패치를 관리하고 있지 않은 경우 |
| 조치 방법 | • DNS 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• DNS 서비스 사용 시 패치 관리 정책 수립 및 주기적으로 패치 적용 설정<br>※ DNS 서비스의 경우 대부분의 버전에서 취약점이 보고되고 있으므로 OS 관리자, 서비스 개발자가 패치 적용에 따른 서비스 영향 정도를 정확히 파악하여 주기적인 패치 적용 정책 수리 후 적용 |
| 조치 시 영향 | 패치 적용 시 시스템 및 서비스 영향 정도를 충분히 고려해야 함 |

#### 점검 및 조치 사례

**● SOLARIS**

```
Step 1) DNS 서비스 활성화 여부 확인
# svcs -a | grep bind

Step 2) DNS 서비스 비활성화
# svcadm disable bind

Step 3) BIND 버전 확인
# named -v

Step 4) DNS 서비스 최신 패치 버전 확인 및 업데이트
ISC 홈페이지 https://www.isc.org/downloads/
```

> ※ BIND 9 취약점 정보(BIND 9 Vulnerability matrix) https://kb.isc.org/v1/docs/en/aa-00913

**● LINUX**

```
Step 1) DNS 서비스 활성화 여부 확인
# systemctl list-units --type=service | grep named

Step 2) DNS 서비스 비활성화
# systemctl stop named

Step 3) BIND 버전 확인
# named -v

Step 4) DNS 서비스 최신 패치 버전 확인 및 업데이트
ISC 홈페이지 https://www.isc.org/downloads/
```

> ※ BIND 9 취약점 정보(BIND 9 Vulnerability matrix) https://kb.isc.org/v1/docs/en/aa-00913

**● AIX**

```
Step 1) DNS 서비스 활성화 여부 확인
lssrc -a | grep named

Step 2) DNS 서비스 비활성화
# stopsrc -s named

Step 3) BIND 버전 확인
# named -v

Step 4) DNS 서비스 최신 패치 버전 확인 및 업데이트
ISC 홈페이지 https://www.isc.org/downloads/
```

> ※ BIND 9 취약점 정보(BIND 9 Vulnerability matrix) https://kb.isc.org/v1/docs/en/aa-00913

**● HP-UX**

```
Step 1) DNS 서비스 활성화 여부 확인
# ps -ef| grep named

Step 2) DNS 서비스 중지
# /sbin/init.d/named stop

Step 3) etc/rc.config.d/namesrv5 파일 내 NAMED 값을 0으로 수정
NAMED=0

Step 4) BIND 버전 확인
# named -v

Step 5) DNS 서비스 최신 패치 버전 확인 및 업데이트
ISC 홈페이지 https://www.isc.org/downloads/
```

> ※ BIND 9 취약점 정보(BIND 9 Vulnerability matrix) https://kb.isc.org/v1/docs/en/aa-00913

---

### U-50 (상) DNS ZoneTransfer 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | Secondary Name Server로만 Zone 정보 전송 제한 여부 점검 |
| 점검 목적 | DNS Zone Transfer 설정을 통해 비인가자에 대한 무단 접근을 방지하기 위함 |
| 보안 위험 | Zone Transfer를 모든 사용자에게 허용할 경우, 비인가자에게 호스트 정보, 시스템 정보 등 중요 정보가 유출될 위험이 존재함 |
| 참고 | ※ DNS Zone Transfer는 Primary Name Server와 Secondary Name Server 간에 Zone 정보를 일관성 있게 유지하기 위하여 사용하는 기능 |
| **점검 대상 및 판단 기준** | |
| 대상 | SOLARIS, LINUX, AIX, HP-UX 등 |
| 판단 기준 | **양호**: Zone Transfer를 허가된 사용자에게만 허용한 경우<br>**취약**: Zone Transfer를 모든 사용자에게 허용한 경우 |
| 조치 방법 | • DNS 서비스를 사용하지 않는 경우 서비스 중지 및 비활성화 설정<br>• DNS 서비스 사용 시 DNS Zone Transfer를 허가된 사용자에게만 전송 허용하도록 설정 |
| 조치 시 영향 | Zone Transfer 설정에서 허용할 대상을 정상적으로 등록하였다면 일반적으로 영향 없음 |

#### 점검 및 조치 사례

**● SOLARIS, LINUX, AIX, HP-UX**

```
Step 1) xfrnets 설정 확인
# cat /etc/named.boot | grep xfrnets 또는 # cat /etc/bind/named.boot | grep xfrnets

Step 2) allow-transfer 설정 확인
# cat /etc/named.conf | grep allow-transfer 또는 # cat /etc/bind/named.conf.options | grep allow-transfer

Step 3) / etc(bind)/named.boot 파일의 xfrnets 설정값 수정
xfrnets <zone transfer를 허용할 IP>

Step 4) /etc(bind)/named.conf 파일의 allow-transfer 설정값 수정
allow-transfer { <zone transfer를 허용할 IP>; };

Step 5) DNS 서비스 재시작
```

> ※ DNS 서비스 Zone 파일명은 임의 지정이 가능하므로 DNS 설정 파일의 Include 구문으로 참조하는 파일명 점검

---

*(Part 3 끝. 다음 Part 4에서 U-51부터 이어집니다.)*