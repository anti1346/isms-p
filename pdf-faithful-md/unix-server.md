# I. Unix 서버

## 01. Unix 서버 취약점 분석 · 평가 항목

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

## 항목별 문서

- [U-01 root 계정 원격 접속 제한](unix-server/u-01.md)
- [U-02 비밀번호 관리정책 설정](unix-server/u-02.md)
- [U-03 계정 잠금 임계값 설정](unix-server/u-03.md)
- [U-04 비밀번호 파일 보호](unix-server/u-04.md)
- [U-05 root 이외의 UID가 '0' 금지](unix-server/u-05.md)
- [U-06 사용자 계정 su 기능 제한](unix-server/u-06.md)
- [U-07 불필요한 계정 제거](unix-server/u-07.md)
- [U-08 관리자 그룹에 최소한의 계정 포함](unix-server/u-08.md)
- [U-09 계정이 존재하지 않는 GID 금지](unix-server/u-09.md)
- [U-10 동일한 UID 금지](unix-server/u-10.md)
- [U-11 사용자 Shell 점검](unix-server/u-11.md)
- [U-12 세션 종료 시간 설정](unix-server/u-12.md)
- [U-13 안전한 비밀번호 암호화 알고리즘 사용](unix-server/u-13.md)

[최상위 문서로 돌아가기](README.md)
