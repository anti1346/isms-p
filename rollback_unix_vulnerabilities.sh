#!/bin/bash
################################################################################
# 파일명   : rollback_unix_vulnerabilities.sh
# 목적     : 취약점 조치 전 상태로 롤백
# 사용법   : sudo ./rollback_unix_vulnerabilities.sh <백업디렉터리경로>
# 예시     : sudo ./rollback_unix_vulnerabilities.sh /var/backup/vuln_fix_20260101_120000
################################################################################

set -u

if [ $# -ne 1 ]; then
    echo "사용법: $0 <백업디렉터리경로>"
    echo "예시:   $0 /var/backup/vuln_fix_20260101_120000"
    exit 1
fi

BACKUP_DIR="$1"

if [ ! -d "$BACKUP_DIR" ]; then
    echo "오류: 백업 디렉터리가 존재하지 않습니다: $BACKUP_DIR"
    exit 1
fi

if [ "$(id -u)" -ne 0 ]; then
    echo "이 스크립트는 root 권한으로 실행해야 합니다."
    exit 1
fi

echo "######################################################################"
echo "#  Unix 취약점 조치 롤백                                             #"
echo "#  백업 디렉터리: $BACKUP_DIR"
echo "######################################################################"
echo ""

# 백업 파일 목록 확인
FILES=$(find "$BACKUP_DIR" -type f 2>/dev/null)
if [ -z "$FILES" ]; then
    echo "백업된 파일이 없습니다."
    exit 1
fi

echo "다음 파일들을 원래 위치로 복원합니다:"
echo "$FILES"
echo ""
read -p "계속하시겠습니까? (yes/no): " confirm
[ "$confirm" != "yes" ] && echo "취소되었습니다." && exit 0

# 복원
for backup_file in $FILES; do
    original="${backup_file#$BACKUP_DIR}"
    if [ -f "$original" ]; then
        cp -p "$backup_file" "$original"
        echo "[복원] $backup_file → $original"
    else
        echo "[경고] 원본 경로 없음: $original"
    fi
done

# 서비스 재시작
systemctl restart sshd 2>/dev/null || service ssh restart 2>/dev/null || true

echo ""
echo "롤백 완료!"