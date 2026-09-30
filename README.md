# 주요정보통신기반시설 기술적 취약점 분석·평가 가이드 2026

> 원문 PDF: [reference/주요정보통신기반시설_기술적_취약점_분석_평가_방법_상세가이드_2026.pdf](reference/주요정보통신기반시설_기술적_취약점_분석_평가_방법_상세가이드_2026.pdf)
>
> GitHub에서 바로 확인할 수 있도록 정리한 문서입니다. 본 저장소에는 원문 PDF와 GitHub 보기에 적합한 Markdown 정리본이 함께 포함되어 있습니다.

## 문서 목록

- [pdf-faithful-md/2026 주요정보통신기반시설 기술적 취약점 분석·평가방법.md](pdf-faithful-md/2026%20%EC%A3%BC%EC%9A%94%EC%A0%95%EB%B3%B4%ED%86%B5%EC%8B%A0%EA%B8%B0%EB%B0%98%EC%8B%9C%EC%84%A4%20%EA%B8%B0%EC%88%A0%EC%A0%81%20%EC%B7%A8%EC%95%BD%EC%A0%90%20%EB%B6%84%EC%84%9D%C2%B7%ED%8F%89%EA%B0%80%EB%B0%A9%EB%B2%95.md) : PDF를 기준으로 구조화한 GitHub용 정리본
- [deepseek/Index.md](deepseek/Index.md) : 초기 아웃라인 및 항목 구조 참고

## 점검 실행

### 1) 점검 수행
```bash
sudo ./check_unix_vulnerabilities.sh /tmp/unix_check_$(date +%Y%m%d).log
```

### 2) 조치 수행 (권장: dry-run 먼저)
```bash
sudo ./fix_unix_vulnerabilities.sh --dry-run
sudo ./fix_unix_vulnerabilities.sh
```

### 3) 문제 발생 시 복구
```bash
sudo ./rollback_unix_vulnerabilities.sh /var/backup/vuln_fix_20260101_120000
```

## 참고

본 저장소의 Markdown 문서는 PDF의 점검 항목과 실무적인 조치 포인트를 함께 정리하여 GitHub에서 빠르게 살펴볼 수 있도록 구성했습니다.