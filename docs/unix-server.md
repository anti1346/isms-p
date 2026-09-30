# I. Unix 서버

Unix 기반 서버의 계정, 파일·디렉터리, 서비스, 패치, 로그 등 운영 보안 점검 항목을 정리한 영역입니다.

## 문서 개요

- 평가 대상 영역: I. Unix 서버
- 참고 자료: [원문 PDF](../reference/주요정보통신기반시설_기술적_취약점_분석_평가_방법_상세가이드_2026.pdf)
- 정리 방식: PDF 목차 구조를 기준으로 GitHub 보기에 적합하게 정리한 문서

## 점검 항목

- [1. 계정 관리](unix-server/unix-account-management.md) — root 원격 접속 제한, 비밀번호 정책, 잠금 임계값, 비밀번호 파일 보호, 계정/UID/GID 점검 등
- [2. 파일 및 디렉터리 관리](unix-server/unix-file-directory-management.md) — root 홈·PATH 설정, 파일 소유자 권한, 파일 시스템 권한, 숨김 파일 관리, 익명 접근 제한 등
- [3. 서비스 관리](unix-server/unix-service-management.md) — 서비스 실행 권한, 불필요 서비스 비활성화, 익명 서비스 제한, 포트 및 프로세스 점검
- [4. 패치 관리](unix-server/unix-patch-management.md) — OS/패키지/보안 업데이트 적용 여부와 패치 반영 기준 점검
- [5. 로그 관리](unix-server/unix-log-management.md) — 로그 기록, 보관 기간, 접근 및 변경 추적 관점의 로그 점검

## 참고

- 원문 PDF에서 해당 항목을 함께 확인해 주세요.
- 실제 점검 기준은 운영 환경 및 정책에 따라 추가 검토가 필요합니다.

[목차로 돌아가기](../README.md)

