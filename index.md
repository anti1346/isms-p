# 주요정보통신기반시설 기술적 취약점 분석·평가 가이드 2026

> 원문 PDF: [reference/주요정보통신기반시설_기술적_취약점_분석_평가_방법_상세가이드_2026.pdf](reference/주요정보통신기반시설_기술적_취약점_분석_평가_방법_상세가이드_2026.pdf)
> GitHub에서 쉽게 보도록 구조화한 목차입니다. 본 문서는 PDF의 영역 분류를 기준으로 정리한 Markdown 문서입니다.

## 목차

### I. Unix 서버
Unix 기반 서버의 계정, 파일·디렉터리, 서비스, 패치, 로그 등 운영 보안 점검 항목을 정리한 영역입니다.

- [I. Unix 서버 상세 페이지](unix-server.md)
  - [1. 계정 관리](unix-server/unix-account-management.md)
  - [2. 파일 및 디렉터리 관리](unix-server/unix-file-directory-management.md)
  - [3. 서비스 관리](unix-server/unix-service-management.md)
  - [4. 패치 관리](unix-server/unix-patch-management.md)
  - [5. 로그 관리](unix-server/unix-log-management.md)

### II. Windows 서버
Windows 서버 계정, 서비스, 패치, 로그, 보안 관리 항목을 구성한 영역입니다.

- [II. Windows 서버 상세 페이지](windows-server.md)
  - [1. 계정 관리](windows-server/windows-account-management.md)
  - [2. 서비스 관리](windows-server/windows-service-management.md)
  - [3. 패치 관리](windows-server/windows-patch-management.md)
  - [4. 로그 관리](windows-server/windows-log-management.md)
  - [5. 보안 관리](windows-server/windows-security-management.md)

### III. 웹 서비스
웹 서버 운영 환경에서 계정, 서비스, 보안 설정, 패치 및 로그를 점검하는 영역입니다.

- [III. 웹 서비스 상세 페이지](web-service.md)
  - [1. 계정 관리](web-service/web-account-management.md)
  - [2. 서비스 관리](web-service/web-service-management.md)
  - [3. 보안 설정](web-service/web-security-settings.md)
  - [4. 패치 및 로그 관리](web-service/web-patch-log-management.md)

### IV. 보안 장비
방화벽, IDS/IPS, 보안 게이트웨이 등 보안 장비의 계정, 접근, 패치, 로그, 기능 관리 영역입니다.

- [IV. 보안 장비 상세 페이지](security-device.md)
  - [1. 계정 관리](security-device/security-device-account-management.md)
  - [2. 접근 관리](security-device/security-device-access-management.md)
  - [3. 패치 관리](security-device/security-device-patch-management.md)
  - [4. 로그 관리](security-device/security-device-log-management.md)
  - [5. 기능 관리](security-device/security-device-function-management.md)

### V. 네트워크 장비
네트워크 장비의 계정, 접근, 패치, 로그, 기능 관리 항목을 점검하는 영역입니다.

- [V. 네트워크 장비 상세 페이지](network-device.md)
  - [1. 계정 관리](network-device/network-device-account-management.md)
  - [2. 접근 관리](network-device/network-device-access-management.md)
  - [3. 패치 관리](network-device/network-device-patch-management.md)
  - [4. 로그 관리](network-device/network-device-log-management.md)
  - [5. 기능 관리](network-device/network-device-function-management.md)

### VI. 제어시스템
산업 제어 시스템에서 계정, 네트워크 접근통제, 물리적 접근통제, 보안위협 탐지, 복구 대응, 교육훈련을 검토하는 영역입니다.

- [VI. 제어시스템 상세 페이지](control-system.md)
  - [1. 계정 관리](control-system/control-system-account-management.md)
  - [2. 서비스 관리](control-system/control-system-service-management.md)
  - [3. 패치 관리](control-system/control-system-patch-management.md)
  - [4. 네트워크 접근통제](control-system/control-system-network-access-control.md)
  - [5. 물리적 접근통제](control-system/control-system-physical-access-control.md)
  - [6. 보안위협 탐지](control-system/control-system-security-threat-detection.md)
  - [7. 복구 대응](control-system/control-system-recovery-response.md)
  - [8. 보안 관리](control-system/control-system-security-management.md)
  - [9. 교육 훈련](control-system/control-system-training.md)

### VII. PC
개인용 PC 기반 운영체제 및 사용자 단말의 계정, 접근, 패치, 보안 관리 영역입니다.

- [VII. PC 상세 페이지](pc.md)
  - [1. 계정 관리](pc/pc-account-management.md)
  - [2. 접근 관리](pc/pc-access-management.md)
  - [3. 패치 관리](pc/pc-patch-management.md)
  - [4. 보안 관리](pc/pc-security-management.md)

### VIII. DBMS
데이터베이스 서버에서 계정, 접근, 옵션, 패치 관리를 점검하는 영역입니다.

- [VIII. DBMS 상세 페이지](dbms.md)
  - [1. 계정 관리](dbms/dbms-account-management.md)
  - [2. 접근 관리](dbms/dbms-access-management.md)
  - [3. 옵션 관리](dbms/dbms-option-management.md)
  - [4. 패치 관리](dbms/dbms-patch-management.md)

### IX. 이동통신
이동통신 장비 및 운영 환경의 보안 운영 관리 점검 영역입니다.

- [IX. 이동통신 상세 페이지](mobile-communication.md)
  - [1. 운영 관리](mobile-communication/mobile-communication-operations.md)

### X. Web Application(웹)
웹 애플리케이션 보안 취약점 분석을 위한 항목 범주입니다.

- [X. Web Application(웹) 상세 페이지](web-application.md)
  - [개요](web-application/web-application-overview.md)

### XI. 가상화 장비
가상화 기반 서버와 가상 네트워크의 계정, 운영, 관리 포인트를 점검하는 영역입니다.

- [XI. 가상화 장비 상세 페이지](virtualization-device.md)
  - [1. 계정 관리](virtualization-device/virtualization-account-management.md)
  - [2. 시스템 서비스 관리](virtualization-device/virtualization-system-service-management.md)
  - [3. 가상 머신 관리](virtualization-device/virtualization-machine-management.md)
  - [4. 가상 네트워크 관리](virtualization-device/virtualization-network-management.md)

### XII. 클라우드
클라우드 인프라의 계정, 권한, 가상 리소스, 운영 관리를 평가하는 영역입니다.

- [XII. 클라우드 상세 페이지](cloud.md)
  - [1. 계정 관리](cloud/cloud-account-management.md)
  - [2. 권한 관리](cloud/cloud-authorization-management.md)
  - [3. 가상 리소스 관리](cloud/cloud-resource-management.md)
  - [4. 운영 관리](cloud/cloud-operation-management.md)

