from pathlib import Path
from textwrap import dedent

ROOT = Path(__file__).resolve().parent
OUT = ROOT
DOCS = OUT / "unix-server"
DOCS.mkdir(parents=True, exist_ok=True)

ITEMS = [
    {
        "code": "U-01",
        "title": "root 계정 원격 접속 제한",
        "summary": "원격 환경에서 root 계정 직접 접속을 제한하고, 관리자 권한 사용을 필요한 계정으로만 제한한다.",
        "check": "원격 관리 세션에서 root 직접 로그인 여부를 점검한다.",
        "purpose": "관리자 권한이 원격에서 무분별하게 사용되지 않도록 차단하기 위함",
        "threat": "root 계정이 원격 접속에 허용되면 비인가자가 관리자 권한을 직접 획득할 수 있다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "원격 접속 시 root 직접 로그인이 제한되고, 관리자 권한은 별도 관리 계정을 통해 수행되는 경우",
        "bad": "원격 접속 시 root 직접 로그인이 허용되거나 관리자가 root로 직접 접속하는 경우",
        "action": "SSH 설정에서 PermitRootLogin no를 적용하고 sudo 또는 별도 관리자 계정을 사용하도록 정책을 구성한다.",
        "case": "```bash\n# SSH 설정 점검\ngrep -E 'PermitRootLogin|AllowUsers|DenyUsers' /etc/ssh/sshd_config\n\n# root 직접 접속 제한 예시\nPermitRootLogin no\n```"
    },
    {
        "code": "U-02",
        "title": "비밀번호 관리정책 설정",
        "summary": "비밀번호 길이, 변경주기, 복잡도, 기억 정책 등을 적절하게 설정하여 계정 도용을 방지한다.",
        "check": "비밀번호 정책 항목인 길이, 복잡도, 변경주기, 만료 주기 설정 여부를 점검한다.",
        "purpose": "약한 비밀번호 사용을 차단하여 무차별 대입 공격을 방지하기 위함",
        "threat": "짧거나 단순한 비밀번호는 빠르게 추측되어 계정 침해로 이어질 수 있다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "비밀번호 최소 길이, 복잡도, 만료 기간 등이 정책에 따라 적절히 설정된 경우",
        "bad": "비밀번호 정책이 미설정이거나 허용 범위가 과도하게 느슨한 경우",
        "action": "/etc/login.defs 또는 시스템 정책 파일에서 비밀번호 최소 길이 및 변경 주기를 설정한다.",
        "case": "```bash\n# 비밀번호 정책 점검\ngrep -E 'PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_WARN_AGE|PASS_MIN_LEN' /etc/login.defs\n```"
    },
    {
        "code": "U-03",
        "title": "계정 잠금 임계값 설정",
        "summary": "로그인 실패 제한 횟수, 잠금 상태 유지 기간, 잠금 방식을 설정해 무차별 대입 공격을 차단한다.",
        "check": "로그인 실패 임계값, 잠금 유지 시간, 관리자 예외 처리를 점검한다.",
        "purpose": "무차별 대입 공격에 대한 자동 차단 및 계정 보호를 구현하기 위함",
        "threat": "로그인 실패 제한이 없으면 공격자가 비밀번호를 반복 추측할 수 있다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "로그인 실패 횟수와 잠금 시간이 적절하게 설정되어 있는 경우",
        "bad": "로그인 실패 제한이 없거나 비정상적으로 길게 허용되는 경우",
        "action": "PAM 또는 계정 정책 설정을 통해 실패 횟수 및 잠금 시간 값을 조정한다.",
        "case": "```bash\n# PAM 설정 확인\ngrep -E 'pam_tally2|faillog|auth.*fail' /etc/pam.d/system-auth /etc/pam.d/password-auth\n```"
    },
    {
        "code": "U-04",
        "title": "비밀번호 파일 보호",
        "summary": "패스워드 파일 접근 권한과 보안 설정을 점검해 계정 정보 노출을 방지한다.",
        "check": "/etc/passwd, /etc/shadow 파일의 소유자, 권한 및 접근 가능 여부를 점검한다.",
        "purpose": "계정 정보의 노출을 방지하고 비인가 접근 경로를 차단하기 위함",
        "threat": "패스워드 파일 접근 권한이 과도하게 허용되면 계정 정보 탈취가 가능하다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "/etc/shadow 등 민감 파일이 관리자만 접근 가능하게 보호되는 경우",
        "bad": "일반 사용자에게 읽기 권한이 허용되거나 민감 파일이 불필요하게 오픈된 경우",
        "action": "민감한 파일의 소유자와 권한을 제한하고, 불필요한 접근 권한을 제거한다.",
        "case": "```bash\nls -l /etc/passwd /etc/shadow\nstat -c '%A %U %G %n' /etc/passwd /etc/shadow\n```"
    },
    {
        "code": "U-05",
        "title": "root 이외의 UID가 '0' 금지",
        "summary": "관리자 권한을 가진 사용자가 다른 계정에서도 UID 0을 가지지 않도록 제한한다.",
        "check": "UID 0으로 지정된 계정이 실제로 하나만 존재하는지 점검한다.",
        "purpose": "권한 분리를 유지하여 동일 계정이 관리자 권한을 중복 보유하지 않도록 하기 위함",
        "threat": "여러 계정이 UID 0을 가지면 관리 권한 과다 부여와 권한 분리 실패가 발생한다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "실제 root 계정만 UID 0을 보유한 경우",
        "bad": "다른 계정에도 UID 0이 지정된 경우",
        "action": "UID 0을 가진 계정을 식별하고, root 외의 다른 계정은 UID 값을 재설정한다.",
        "case": "```bash\nawk -F: '$3 == 0 {print $1, $3}' /etc/passwd\n```"
    },
    {
        "code": "U-06",
        "title": "사용자 계정 su 기능 제한",
        "summary": "su 명령을 허용할 사용자를 제한하여 비관리자 계정의 관리자 권한 전환을 방지한다.",
        "check": "su 사용 허용 그룹 및 sudo 정책을 점검한다.",
        "purpose": "관리자 권한 전환 범위를 최소화하여 권한 남용을 방지하기 위함",
        "threat": "일반 사용자가 su를 통해 루트 권한을 탈취하면 관리자 권한을 무단으로 사용할 수 있다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "su 또는 sudo를 허용하는 사용자가 필요한 인원만 제한되어 있는 경우",
        "bad": "일반 사용자가 무분별하게 관리자 권한 전환이 가능한 경우",
        "action": "wheel 그룹 또는 sudoers 규칙을 통해 허용 사용자를 제한한다.",
        "case": "```bash\ngrep -E 'wheel|sudo' /etc/group /etc/sudoers\n```"
    },
    {
        "code": "U-07",
        "title": "불필요한 계정 제거",
        "summary": "필요 없는 기본 계정, 테스트 계정, 임시 계정 등을 제거하여 무단 접근 경로를 최소화한다.",
        "check": "사용하지 않는 기본 계정, 테스트 계정, 임시 계정의 존재 여부를 점검한다.",
        "purpose": "불필요한 계정으로 인한 권한 오남용과 공격 벡터를 줄이기 위함",
        "threat": "사용하지 않는 계정이 남아 있으면 비인가 접근 및 의도치 않은 권한 획득이 가능하다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "필요한 계정만 유지되고 불필요한 계정이 정리된 경우",
        "bad": "기본 계정이나 임시 계정이 남아 있거나 사용하지 않는 계정이 관리되지 않는 경우",
        "action": "불필요한 계정을 삭제하거나 shell을 /bin/false로 바꾸어 비활성화한다.",
        "case": "```bash\ncut -d: -f1 /etc/passwd\ngetent passwd | awk -F: '{print $1,$3}'\n```"
    },
    {
        "code": "U-08",
        "title": "관리자 그룹에 최소한의 계정 포함",
        "summary": "관리자 권한 그룹에는 실제 필요한 계정만 포함되도록 제한한다.",
        "check": "wheel, sudo, root 등 관리자 그룹 멤버를 점검한다.",
        "purpose": "관리자 그룹의 과다 인원을 제한하여 권한 분산을 안전하게 유지하기 위함",
        "threat": "관리자 그룹에 과도한 계정이 포함되면 계정 도용 시 영향 범위가 커진다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "관리자 그룹에 실제 운영에 필요한 최소 계정만 포함된 경우",
        "bad": "관리자 그룹에 불필요한 계정이 포함된 경우",
        "action": "관리자 그룹 Membership을 점검하고 불필요한 계정을 제거한다.",
        "case": "```bash\ngetent group wheel sudo root\n```"
    },
    {
        "code": "U-09",
        "title": "계정이 존재하지 않는 GID 금지",
        "summary": "존재하지 않는 그룹 ID를 참조하는 계정 설정을 방지하여 권한 매핑 오류를 막는다.",
        "check": "계정의 GID가 실제로 존재하는 그룹을 가리키는지 점검한다.",
        "purpose": "잘못된 그룹 참조로 인한 권한 오류를 방지하기 위함",
        "threat": "존재하지 않는 GID를 가진 계정은 권한 문제가 발생할 수 있다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "모든 계정의 GID가 실제 존재하는 그룹에 매핑된 경우",
        "bad": "존재하지 않는 group id를 가리키는 계정이 존재하는 경우",
        "action": "계정의 GID를 정합성 있게 수정하고, 사용하지 않는 그룹을 정리한다.",
        "case": "```bash\ngetent group; awk -F: '{print $1,$3}' /etc/passwd\n```"
    },
    {
        "code": "U-10",
        "title": "동일한 UID 금지",
        "summary": "같은 UID를 가진 계정이 존재하지 않도록 점검하여 권한 충돌을 방지한다.",
        "check": "시스템 내 중복 UID가 있는지 점검한다.",
        "purpose": "권한 충돌을 방지하고 계정 식별을 일관되게 관리하기 위함",
        "threat": "중복 UID는 권한 오인식과 의도하지 않은 접근 허용을 초래할 수 있다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "모든 계정이 고유 UID를 가지는 경우",
        "bad": "같은 UID를 가진 계정이 존재하는 경우",
        "action": "중복 UID를 가진 계정의 UID를 재지정하거나 계정을 정리한다.",
        "case": "```bash\nawk -F: '{print $3}' /etc/passwd | sort | uniq -d\n```"
    },
    {
        "code": "U-11",
        "title": "사용자 Shell 점검",
        "summary": "불필요한 셸이나 비대화형 셸이 계정에 할당되지 않도록 점검한다.",
        "check": "로그인이 불필요한 계정의 shell 값과 사용자 shell 설정을 점검한다.",
        "purpose": "시스템 계정이나 비대화형 계정이 실제 로그인을 허용하지 않도록 하기 위함",
        "threat": "불필요한 shell을 가진 계정은 로그온 시 공격 경로가 될 수 있다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "시스템 계정 및 로그인이 불필요한 계정은 /sbin/nologin 또는 /bin/false로 제한된 경우",
        "bad": "무분별하게 빈 shell 또는 로그인 가능한 shell이 부여된 경우",
        "action": "로그인이 필요하지 않은 계정의 shell을 /bin/false 또는 /sbin/nologin으로 변경한다.",
        "case": "```bash\ncat /etc/passwd | grep -E 'daemon|bin|sys|adm|nobody'\n# 필요 시\nusermod -s /bin/false <계정명>\n```"
    },
    {
        "code": "U-12",
        "title": "세션 종료 시간 설정",
        "summary": "장시간 미사용 세션이 유지되지 않도록 자동 종료 정책을 설정한다.",
        "check": "사용자 쉘 환경설정 파일에서 Session Timeout 설정 여부를 점검한다.",
        "purpose": "사용자의 고의 또는 실수로 시스템에 계정이 접속된 상태로 방치되는 것을 차단하기 위함",
        "threat": "Session timeout 값이 설정되지 않을 경우, 유휴 시간 내 비인가자가 시스템에 접근하여 불필요한 내부 정보를 노출할 위험이 존재한다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "Session Timeout이 600초(10분) 이하로 설정된 경우",
        "bad": "Session Timeout이 600초(10분) 이하로 설정되지 않은 경우",
        "action": "600초(10분) 동안 입력이 없는 경우 접속된 Session을 끊도록 설정한다.",
        "case": "```bash\n# [sh, ksh, bash]\nStep 1) /etc/profile 파일 내 TMOUT 값 설정\nTMOUT=600\nexport TMOUT\n\n# [csh]\nStep 1) /etc/csh.cshrc 또는 /etc/csh.login 파일 내 autologout 값 설정\nset autologout=10\n```"
    },
    {
        "code": "U-13",
        "title": "안전한 비밀번호 암호화 알고리즘 사용",
        "summary": "취약한 해시 알고리즘 대신 안전한 암호화 방식으로 비밀번호를 저장하도록 점검한다.",
        "check": "암호화 필드 값이 SHA-256 이상 보안 알고리즘을 사용하는지 확인한다.",
        "purpose": "비밀번호 노출 시 복호화 공격에 대비해 안전한 암호화 알고리즘을 적용하기 위함",
        "threat": "취약한 비밀번호 암호화 알고리즘을 사용할 경우, 노출된 계정에 대해 비인가자가 암호 복호화 공격을 통해 비밀번호를 획득할 위험이 존재한다.",
        "target": "SOLARIS, LINUX, AIX, HP-UX 등",
        "good": "SHA-2 이상 안전한 비밀번호 암호화 알고리즘을 사용하는 경우",
        "bad": "취약한 비밀번호 암호화 알고리즘을 사용하는 경우",
        "action": "SHA-256, SHA-512, yescrypt 등 안전한 알고리즘을 설정하고 기존 비밀번호를 재설정한다.",
        "case": "```bash\n# Linux 예시\ngrep -E 'ENCRYPT_METHOD|SHA_CRYPT' /etc/login.defs /etc/default/useradd\n```"
    },
]


def extract_code_block(text: str) -> str:
    if not text:
        return ""
    if "```bash" in text:
        start = text.index("```bash") + len("```bash\n")
        end = text.rindex("```")
        return text[start:end].strip()
    return text.strip()


def item_page(item: dict) -> str:
    example = extract_code_block(item['case'])
    lines = [
        f"# {item['code']} {item['title']}",
        "",
        "| 구분 | 내용 |",
        "| :--- | :--- |",
        "| **개요** | |",
        f"| 점검 내용 | {item['check']} |",
        f"| 점검 목적 | {item['purpose']} |",
        f"| 보안 위험 | {item['threat']} |",
        "| 참고 | ※ 해당 항목은 운영 환경 및 정책에 따라 세부 설정이 달라질 수 있다. |",
        "| **점검 대상 및 판단 기준** | |",
        f"| 대상 | {item['target']} |",
        f"| 판단 기준 | **양호**: {item['good']}<br>**취약**: {item['bad']} |",
        f"| 조치 방법 | {item['action']} |",
        "| 조치 시 영향 | 일반적인 경우 영향 없음 |",
        "",
        "## 점검 및 조치 사례",
        "",
        "```bash",
        example,
        "```",
        "",
        "## AI 추천 점검 및 조치 방법",
        "",
        "### 점검 포인트",
        "- 해당 항목의 설정값이 실제 운영 환경에서 적용되는지 확인한다.",
        "- 정책 기준과 현재 설정값을 비교한다.",
        "- 로그와 사용자 권한 상태를 함께 확인한다.",
        "",
        "### 권장 조치",
        "```bash",
        example.splitlines()[0] if example else "",
        "```",
        "",
        "- 보안 정책을 반영해 설정을 조정한다.",
        "- 불필요한 예외 설정을 제거한다.",
        "- 변경 후 재점검을 수행한다.",
        "",
        "## 관련 문서",
        "- [Unix 서버 목차](unix-server.md)",
        "- [최상위 문서](../README.md)",
        "",
    ]
    return "\n".join(lines)


def build_readme() -> str:
    lines = [
        "# 2026 주요정보통신기반시설 기술적 취약점 분석·평가 가이드",
        "",
        "> 이 디렉터리는 PDF와 DeepSeek 정리본을 참고해 다시 정리한 Markdown 문서입니다.",
        "> 본 문서는 GitHub에서 읽기 쉽게 정리한 버전이며, 오타와 표현은 최종 검토 단계에서 추가로 보정합니다.",
        "",
        "## 목차",
        "",
        "### I. Unix 서버",
        "",
        "- [Unix 서버 전체 목록](unix-server.md)",
    ]
    for item in ITEMS:
        lines.append(f"- [{item['code']} {item['title']}](unix-server/{item['code'].lower()}.md)")
    lines.extend(["", "---", "", "- 원문 PDF: [reference/주요정보통신기반시설_기술적_취약점_분석_평가_방법_상세가이드_2026.pdf](../reference/주요정보통신기반시설_기술적_취약점_분석_평가_방법_상세가이드_2026.pdf)"])
    return "\n".join(lines) + "\n"


def build_section() -> str:
    lines = [
        "# I. Unix 서버",
        "",
        "## 01. Unix 서버 취약점 분석 · 평가 항목",
        "",
        "| 점검항목 | 중요도 | 항목코드 |",
        "| :--- | :---: | :---: |",
    ]
    for item in ITEMS:
        lines.append(f"| {item['title']} | {'상' if item['code'] in {'U-01','U-02','U-03','U-04','U-05','U-06','U-14','U-15','U-16','U-17','U-18','U-19','U-20','U-21','U-22','U-23','U-24','U-25','U-26','U-27','U-28','U-34','U-35','U-36','U-37','U-38','U-39','U-40','U-41','U-42','U-43','U-44','U-45','U-46','U-47','U-49','U-50','U-54','U-59','U-61','U-64'} else ('중' if item['code'] in {'U-08','U-10','U-13','U-30','U-31','U-32','U-48','U-51','U-52','U-55','U-56','U-57','U-58','U-60','U-63','U-65','U-66','U-67'} else '하')} | {item['code']} |")
    lines.extend(["", "## 항목별 문서", ""])
    for item in ITEMS:
        lines.append(f"- [{item['code']} {item['title']}](unix-server/{item['code'].lower()}.md)")
    lines.extend(["", "[최상위 문서로 돌아가기](README.md)"])
    return "\n".join(lines) + "\n"


def main():
    (OUT / "README.md").write_text(build_readme(), encoding="utf-8")
    (OUT / "unix-server.md").write_text(build_section(), encoding="utf-8")
    for item in ITEMS:
        path = DOCS / f"{item['code'].lower()}.md"
        path.write_text(item_page(item), encoding="utf-8")
    print(f"Generated {len(ITEMS)} item pages under {OUT}")


if __name__ == "__main__":
    main()
