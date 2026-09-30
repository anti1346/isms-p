# 주요정보통신기반시설 기술적 취약점 분석·평가 가이드 2026

> 원문 PDF: [reference/주요정보통신기반시설_기술적_취약점_분석_평가_방법_상세가이드_2026.pdf](reference/주요정보통신기반시설_기술적_취약점_분석_평가_방법_상세가이드_2026.pdf)
> GitHub에서 쉽게 보도록 구조화한 목차입니다. 본 문서는 PDF의 영역 분류를 기준으로 정리한 Markdown 문서입니다.



### 점검 실행 (먼저 실행!)
```
sudo ./check_unix_vulnerabilities.sh /tmp/unix_check_$(date +%Y%m%d).log
```
### 조치 실행
#### 1단계: DRY-RUN으로 미리 확인 (권장!)
```
sudo ./fix_unix_vulnerabilities.sh --dry-run
```
#### 단계: 실제 조치
```
sudo ./fix_unix_vulnerabilities.sh
```
### 문제 발생 시 롤백
```
sudo ./rollback_unix_vulnerabilities.sh /var/backup/vuln_fix_20260101_120000
```