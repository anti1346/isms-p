# X. Web Application(웹)

## 01. Web Application(웹) 취약점 분석 · 평가 항목

| 점검항목 | 항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: | :---: |
| 코드 인젝션 (Code Injection) | | 상 | CI |
| SQL 인젝션 (SQL Injection) | | 상 | SI |
| 디렉터리 인덱싱 | | 상 | DI |
| 에러 페이지 적용 미흡 | | 상 | EP |
| 정보 누출 | | 상 | IL |
| 크로스사이트 스크립트 | | 상 | XS |
| 크로스사이트 요청 위조(CSRF) | | 상 | CF |
| 서버사이드 요청 위조(SSRF) | | 상 | SF |
| 약한 비밀번호 정책 | | 상 | BF |
| 불충분한 인증 절차 | | 상 | IA |
| 불충분한 권한 검증 | | 상 | IN |
| 취약한 비밀번호 복구 절차 | | 상 | PR |
| 프로세스 검증 누락 | | 상 | PV |
| 악성 파일 업로드 | | 상 | FU |
| 파일 다운로드 | | 상 | FD |
| 불충분한 세션 관리 | | 상 | IS |
| 데이터 평문 전송 | | 상 | SN |
| 쿠키 변조 | | 상 | CC |
| 관리자 페이지 노출 | | 상 | AE |
| 자동화 공격 | | 상 | AU |
| 불필요한 Method 악용 | | 상 | WM |

---

## 1. 코드 인젝션 (Code Injection)

### CI (상) 코드 인젝션 (Code Injection)

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 웹 애플리케이션 내 다양한 인젝션 공격(LDAP, 운영체제 명령 실행, SSI, XPATH, XML, SSTI 인젝션 등)에 대해 외부 입력값이 쿼리나 명령어로 삽입되어 비인가된 접근이나 코드 실행의 가능 유무 점검 |
| 점검 목적 | 허용되지 않은 코드 및 쿼리 실행을 방지하여 비인가된 접근, 데이터 유출, 시스템 변조, 악성 코드 실행 등의 위협을 차단하여, 데이터 보호와 시스템 안정성을 확보하기 위함 |
| 보안 위험 | 해당 취약점이 존재하는 경우 비인가된 데이터 접근으로 민감 정보가 탈취될 수 있으며, 시스템 명령어나 스크립트가 실행되어 서버 제어나 악성 코드 실행이 가능하고, 데이터 무결성이 훼손되어 정보의 신뢰성이 떨어지며, 서비스 거부 공격(DoS)으로 시스템 가용성이 저하될 수 있음. 따라서 "\|", ";", "`", "<" 등의 특수 문자에 대한 필터링 구현과 함께 입력값 검증, 화이트리스트 적용 등의 추가적인 보안 조치가 필요함 |
| 참고 | ※ LDAP 인젝션: 입력값이 LDAP(Lightweight Directory Access Protocol) 쿼리에 삽입되어 디렉터리 서비스 데이터에 대한 비인가된 조회, 수정, 삭제를 유발하는 공격<br>※ 운영체제 명령 실행: 입력값이 시스템 명령어로 실행되어 서버의 운영체제 명령을 비인가로 수행하거나 민감한 시스템 정보를 노출하는 공격<br>※ SSI 인젝션: 입력값이 서버 사이드 인클루드(Server Side Include) 명령어로 실행되어 웹 애플리케이션 서버에서 비인가된 스크립트 실행이나 파일 접근을 유발하는 공격<br>※ XPath 인젝션: 입력값이 XPath 쿼리에 삽입되어 XML 데이터의 비인가된 조회, 추가, 삭제를 유발하는 공격<br>※ XXE 인젝션: 입력값이 XML 문서나 쿼리에 삽입되어 XML 데이터에 대한 비인가된 접근, 외부 엔티티 참조(XML External Entities)를 통한 시스템 정보 유출을 유발하는 공격<br>※ SSTI 인젝션: 입력값이 서버 사이드 템플릿 엔진에 삽입되어 템플릿 렌더링 과정에서 비인가된 코드 실행이나 서버 내부 데이터 노출을 유발하는 공격<br>※ 소스코드 및 취약점 점검 필요 |
| **점검 대상 및 판단 기준** | |
| 대상 | 웹 애플리케이션 소스코드, 웹 방화벽 |
| 판단 기준 | **양호**: 임의의 입력값에 대하여 철저한 검증이 이루어져, 허용되지 않은 값이 필터링되고 허용된 값만 처리되는 경우<br>**취약**: 임의의 입력값에 대하여 검증 없이 명령이 실행되는 경우 |
| 조치 방법 | 화이트리스트 방식으로 쿼리를 허용된 값만 처리하고, 특수 문자에 대해 입력값 검증 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● LDAP(Lightweght Directory Access Protocol) 인젝션**

```
- 점검 방법
Step 1) 사용자 입력값에 대하여 변조된 LDAP 쿼리 삽입 후 실행 가능 여부 확인
[ LDAP 쿼리 삽입 ]
```

```
- 조치 방법
1. 사용자 입력값을 화이트리스트로 지정하여 영문(a-z, A-Z)과 숫자(0-9)만을 허용
2. 특수문자를 사용해야 하는 경우 입력값(DN에 사용되는 특수문자는 '\'를 붙여 이스케이프 처리, 필터에 사용되는 특수문자는 '= + < > # \ , ; 앞뒤 공백' 등)에 대해서는 실행 명령이 아닌 일반문자로 인식되도록 처리
3. DN과 필터에 사용되는 사용자 입력값에는 특수문자 제거
4. 웹 방화벽에 LDAP 관련 특수문자를 필터링하도록 룰셋 적용
```

| 구분 | 필터링 예시 |
| :--- | :--- |
| 변경 전 | \ = + * ( ) \0 |
| 변경 후 | \5c \3d \2b \2a \28 \29 \00 |

| 필터링 대상 예시 |
| :--- |
| ' " - # ( ) < > = /* */ + * ; & \| \ \0 : ` % user_tables table_name column_name Syscolumns union select insert drop update and or If join substring from where declare substr openrowset xp_ sysobject |

**● 운영체제 명령실행**

```
- 점검 방법
Step 1) 웹 애플리케이션 기능 내 전달되는 파라미터 값에 대하여 운영체제 명령어 삽입 후 실행 여부 확인
[ 임의 운영체제 명령어 삽입 ]
```

```
- 조치 방법
1. 웹 애플리케이션 설계 시 운영체제로부터 명령어를 직접적으로 호출하지 않도록 구현하고, 언어/프레임워크에서 제공하는 안전한 API 사용
2. 명령어를 직접 호출하는 기능이 필요한 경우에는, 데이터가 OS의 명령어 해석기에 전달되기 전에 화이트리스트 기반으로 입력값을 검증/확인하도록 구현
3. 입력값에 대한 파라미터 데이터의 필터링 처리
 - Unix/Linux : &, &&, |, ||, ;, `, $(), <, > 등
 - Windows : &, |, ^, % 등
4. 웹 서버 및 웹 애플리케이션 서버는 공개적으로 알려진 취약점이 제거된 상위 버전으로 업데이트
KISA 보호나라&KrCERT/CC
알림마당 > 보안공지(https://www.boho.or.kr/)
5. 웹 방화벽에 모든 사용자 입력값을 대상으로 악용될 수 있는 특수문자 및 키워드 등에 대한 룰셋 적용
```

| 구분 | 상세 설명 |
| :--- | :--- |
| & | 첫 번째 명령어는 백그라운드에서 실행되며, 두 번째 명령어는 즉시 실행 |
| && | 첫 번째 명령어가 성공했을 때만 두 번째 명령어 실행 |
| \| | 두 명령어를 연결하여, 첫 번째 명령어의 출력을 두 번째 명령어의 입력으로 전달 |
| ; | 첫 번째 명령어 실행 후 성공여부와 무관하게 두 번째 명령어 실행 |
| ` ` 또는 $() | 백틱 또는 괄호 안에 있는 명령어를 실행하고 그 출력을 반환 |
| > 또는 >> | 명령 실행 결과를 파일로 생성(덮어쓰기 또는 추가) |
| < | 파일 내용을 명령어 입력으로 전달 |
| ^ (Windows) | 명령어 이스케이프/제어 문자로 사용 |
| % (Windows) | 환경 변수 치환 |
| \ | 이스케이프 문자 또는 뒤에 오는 특수문자를 무효화하거나 명령 연결 시 사용 |

**● SSI(Server Side Includes) 인젝션**

```
- 점검 방법
Step 1) 사용자가 입력 가능한 파라미터 값에 <!--#echo var="DOCUMENT_ROOT" -->를 삽입하여 전송 후 반환되는 페이지에 사이트의 홈 디렉터리가 표시되는지 확인
[ Server Side Includes 지시어 삽입 및 취약점 유무 판단 ]

Step 2) 사용자가 입력 가능한 파라미터 값에 <!-- #exec cmd="ls -al" -->를 삽입하여 전송 후 반환되는 페이지에 디렉터리의 파일 리스트가 표시되는지 확인
[ 심화 공격 수행 ]

Step 3) HTTP 요청(Request) 헤더에 명령어를 삽입하여 실행되는지 확인
GET / HTTP/1.0
Referer: <!--#exec cmd="/bin/ps ax"-->
User-Agent: <!--#include virtual="/proc/version"-->
```

```
- 조치 방법
1. 화이트리스트 방식으로 사용자 입력에 대한 사용 가능한 문자들을 정의하여 정해진 문자를 제외한 나머지 모든 문자들을 필터링 처리
2. 필터링 해야 하는 대상은 GET 질의 문자열, POST 데이터, 쿠키, URL, 그리고 일반적으로 브라우저와 웹 서버가 주고받는 모든 데이터를 포함하며, 아래는 특수문자에 대한 엔티티 형태를 표시한 것임
3. 웹 서버의 SSI 기능을 사용하지 않거나, 웹 방화벽에 특수문자를 필터링하도록 룰셋 적용
```

| 구분 | 필터링 예시 |
| :--- | :--- |
| 변경 전 | < > " ( ) # & |
| 변경 후 | &lt; &gt; &quot; &#40; &#41; &#35; &amp; |

**● XPath 인젝션**

```
- 점검 방법
Step 1) 취약점 존재 유무 판단을 위한 Xpath 쿼리(' or '1'='1, ' and 'a' = 'b 등) 삽입
(※ 예시로 제시한 것으로, 웹 사이트 환경에 맞춰 점검해야 함)
[ XPath 구문 삽입 시도 및 취약점 유무 판단 ]

Step 2) 추가적인 쿼리 질의를 통하여 데이터 추출 등의 타당성 검토
' or count(parent::*[position()=1])=0 or 'a'='b
1' or string-length(username)=[COUNT] and '1'='1... 등
[ 심화 공격 수행 ]
```

```
- 조치 방법
1. XPath 쿼리에 사용자가 값을 입력할 수 있는 경우, 입력값 검증을 통해 필요 문자만을 받아들이게 함. ( ) = ' [ ] : , * / 등의 오동작를 유발하는 특수문자는 제한하며, 특정 특수문자만을 필터링하는 것이 아닌 허용된 문자 이외의 모든 입력을 화이트리스트 방식으로 필터링 처리
2. Xpath 및 XQuery의 쿼리 삽입 시 사용되는 특수문자를 필터링하도록 웹 방화벽 룰셋 적용
```

**● XXE(XML External Entities) 인젝션**

```
- 점검 방법
Step 1) 파일 업로드 페이지, API 엔드포인트, HTML Form 등 XML을 파싱하는 페이지 포인트 내 XML 객체 삽입 시도 (※ 예로 제시한 것으로, 웹 사이트 환경에 맞춰 점검해야 함)
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE foo [
 <!ELEMENT foo ANY >
 <!ENTITY xxe SYSTEM "file:///C:/Windows/System32/drivers/etc/hosts" >
]>
<foo>&xxe;</foo>
[ 외부 Entity 객체 삽입 및 XXE 공격 수행 ]
```

```
- 조치 방법
1. 허용된 태그와 속성만 사용하도록 화이트리스트 방식을 이용한 입력값 검증 로직 구현
2. 최근 언어별 XML 파서의 경우, 기본적으로 외부 엔티티 처리가 비활성화되어 있으나 소스코드 상에서 명시적으로 비활성화 처리하는 것이 안전한 방법
3. 의도하지 않은 오동작이 발생할 가능성이 존재하는 외부 엔티티 참조 명령어 및 주요 스키마 등에 대하여 웹 방화벽에 룰셋 적용
```

**※ Java**

```
Java DTD(외부 엔티티) 비활성화 예시
...
// 공통 보안 설정
dbf.setXIncludeAware(false);
...
if (mode == SecurityMode.FULL_SECURE) {
 dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
 dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
 dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
 dbf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
} else if (mode == SecurityMode.LIMITED_SECURE) {
 // DTD를 완전히 비활성화할 수 없는 경우
 dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
 dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
 dbf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
}
...
```

**※ ASP.NET**

```
ASP.NET DTD(외부 엔티티) 비활성화 예시
...
// XmlDocument 객체 생성
XmlDocument doc = new XmlDocument();
// XmlResolver를 null로 설정하여 외부 엔티티의 해석을 비활성화
doc.XmlResolver = null
...
```

**※ PHP 8.0 이전**

```
PHP 8.0 이전 DTD(외부 엔티티) 비활성화 예시
...
libxml_disable_entity_loader(true);
...
```

**※ PHP 8.0 이후**

```
§ libxml_disable_entity_loader() 함수가 더 이상 사용되지 않으며, 외부 엔티티 로드는 기본적으로 비활성화되어있지만, LIBXML_NOENT 플래그로 인하여 XML 파서가 외부 엔티티를 확장하도록 설정되어있는 경우 XXE 취약점 발생 가능
PHP 8.0 이후 DTD(외부 엔티티) 비활성화 예시
...
// DOMDocument 인스턴스 생성
$dom = new DOMDocument();
// 외부 엔티티 비활성화
$dom->loadXML($xmlfile, LIBXML_NONET);
...
```

**● SSTI(Server Side Template Injection)**

```
- 점검 방법
Step 1) 사용자 입력값이 서버 템플릿 엔진 내에서 처리되는지 확인하기 위해 {{7*7}} 등의 수식 삽입 시도
[ 템플릿 엔진 수식 삽입을 통한 취약점 유무 판단 ]

Step 2) 상위 컨텍스트 및 객체 접근을 시도하여 원격 코드 실행의 가능 여부를 판별하기 위하여 페이로드 입력 및 실행 유무 확인
[ 심화 공격 수행 ]
```

```
- 조치 방법
1. 템플릿 언어에서 예약된 의미를 가지는 문자({ } < > % # @ 등)에 대하여 이스케이프 처리
2. 템플릿 엔진의 안전 모드를 사용함으로써 템플릿 내에서 실행할 수 있는 명령을 제한하여 임의 코드 실행 방지
3. 안전 모드 및 내장 함수를 활용하여 보안 조치를 하는 경우 엔진의 버전과 그 버전에서 지원하는 기능을 고려하여 적절한 보안 패치 진행
4. 에러 메시지를 통해 사용된 템플릿 언어 및 관련 취약점에 대한 유의미한 정보를 제공할 가능성이 존재하므로, 노출되는 에러 메시지를 제한
5. 템플릿 엔진 내 사용되는 특수문자를 필터링하도록 웹 방화벽 룰셋 적용
```

**※ Java**

```
사용자 입력값 특수문자 인코딩 처리 예시
...
name = org.apache.commons.text.StringEscapeUtils.escapeHtml4(name); // 사용자 입력값 인코딩
// 사용자 입력값 이스케이프 처리
public static String escapeSpecialCharacters(String input) {
```

```
§ Velocity 템플릿 엔진에서 제공하는 '$esc.html'를 사용하여 사용자 입력을 HTML 인코딩 처리
Java(Velocity) 안전한 템플릿 사용 예시
...
#set($userInput = $esc.html($params.get("userInput")))
<p>사용자 입력: $userInput</p>
...
§ FreeMarker 템플릿 엔진의 내장 함수인 '?html'를 사용하여 사용자 입력을 HTML 인코딩 처리
Java(FreeMarker) 안전한 템플릿 사용 예시
...
<p>사용자 입력: ${userInput?html}!</p>
...
```

**※ ASP.NET**

```
if (input == null) return null;
return input.replaceAll("([*{}\\[\\]<>%#@])", "\\\\$1");
}
사용자 입력값 특수문자 인코딩 처리 예시
// 사용자 입력값 인코딩
...
private static readonly Dictionary<char, string> HtmlEntities = new Dictionary<char, string> {
 { '*', "&#42;" },
 { '{', "&#123;" },
 { '}', "&#125;" },
 { '[', "&#91;" },
 { ']', "&#93;" },
 { '<', "&lt;" },
 { '>', "&gt;" },
 { '%', "&#37;" },
 { '#', "&#35;" },
 { '@', "&#64;" }
};
public static string EscapeHtmlEntities(string input) {
```

**※ Python**

```
if (input == null) return null;
StringBuilder escapedString = new StringBuilder();
foreach (char ch in input) {
 if (HtmlEntities.ContainsKey(ch)) {
 escapedString.Append(HtmlEntities[ch]);
 } else {
 escapedString.Append(ch);
 }
 }
 return escapedString.ToString();
 }
...
// 사용자 입력값 이스케이프 처리
public static string EscapeSpecialCharacters(string input) {
 if (input == null) return null;
 return Regex.Replace(input, @"([*{}\[\]<>%#@])", @"\$1");
}
...
사용자 입력값 특수문자 인코딩 처리 예시
# 사용자 입력값 인코딩
def escape_html_entities(input_string):
 if input_string is None:
 return None
...
 html_entities = {
 '*': '&#42;',
 '{': '&#123;',
 '}': '&#125;',
 '[': '&#91;',
 ']': '&#93;',
 '<': '&lt;',
 '>': '&gt;',
 '%': '&#37;',
 '#': '&#35;',
```

```
§ 사용자 입력을 직접 템플릿에 삽입하는 방식은 SSTI 취약점에 노출될 수 있으므로 사용자 입력을 템플릿 변수로 전달하는 방식을 사용하여 안전하게 처리
Python(jinja2) 안전한 템플릿 사용 예시
...
template = "userinput : {{ userinput }}"
return render_template_string(template, userinput=param)
...
```

**※ PHP**

```
 '@': '&#64;',
 ...
 }
 return ''.join(html_entities.get(char, char) for char in input_string)
...
# 사용자 입력값 이스케이프 처리
def escape_special_characters(input_string):
 if input_string is None:
 return None
 return re.sub(r'([*{}\[\]<>%#@])', r'\\\1', input_string)
...
PHP 사용자 입력값 특수문자 인코딩 처리 예시
...
function escape_html_entities($input_string) {
 if ($input_string === null) {
 return null;
 }
 $html_entities = [
 '*' => '&#42;',
 '{' => '&#123;',
 '}' => '&#125;',
 '[' => '&#91;',
 '<' => '&lt;',
 '>' => '&gt;',
 '%' => '&#37;',
 ...
 ];
 return strtr($input_string, $html_entities);
}
// 특수 문자 앞에 백슬래시를 추가하여 이스케이프 처리
function escape_special_characters($input_string) {
 if ($input_string === null) {
 return null;
 }
 return preg_replace('/([*{}\[\]<>%#@])/', '\\\\$1', $input_string);
}
...
// htmlspecialchars 함수를 이용하여 사용자 입력값을 HTML 인코딩
$userInput = htmlspecialchars($userInput ENT_QUOTES, 'UTF-8');
...
```

---

## 2. SQL 인젝션 (SQL Injection)

### SI (상) SQL 인젝션 (SQL Injection)

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 웹 애플리케이션 내 입력값이 SQL 쿼리에 삽입되어 비인가된 데이터베이스 접근과 조작 가능 여부 점검 |
| 점검 목적 | 웹 애플리케이션 내 SQL문으로 해석될 수 있는 입력값 허용을 차단하고 운영 중인 데이터베이스에 대한 비인가된 접근 및 조작을 방지하여, 데이터 무결성과 보안성을 확보하기 위함 |
| 보안 위험 | 해당 취약점이 존재하는 경우, 입력값이 SQL 쿼리에 삽입되어 데이터베이스에 비인가된 접근을 허용하며, 공격자는 민감 데이터의 조회, 수정, 삭제를 포함한 다양한 악의적인 행위가 가능하므로 입력값에 대한 특수문자 필터링을 구현해야함 |
| 참고 | ※ SQL 인젝션: 사용자의 입력값으로 웹 사이트 SQL 쿼리가 완성되는 약점을 이용하여, 입력값을 변조해 비정상적인 SQL 쿼리를 조합하거나 실행하는 공격. 이는 개발자가 의도하지 않은 SQL문을 실행하게 하여 데이터베이스를 비정상적으로 조작하고, 민감한 데이터를 조회, 수정, 삭제할 수 있는 공격<br>※ SQL 인젝션 공격 관련 코드 검토 필요<br>※ 소스코드 및 취약점 점검 필요 |
| **점검 대상 및 판단 기준** | |
| 대상 | 웹 애플리케이션 소스코드, 웹 방화벽 |
| 판단 기준 | **양호**: 임의로 작성된 SQL 쿼리 입력에 대한 적절한 검증을 통해 비정상적인 쿼리가 실행되지 않도록 하는 경우<br>**취약**: 임의로 작성된 SQL 쿼리 입력에 대한 검증이 이루어지지 않아 비정상적인 쿼리가 실행되는 경우 |
| 조치 방법 | 소스코드 내 SQL 쿼리를 입력값으로 받는 함수나 코드를 사용할 경우, 임의의 SQL 쿼리 입력에 대한 검증 로직을 구현하여 서버에 검증되지 않는 SQL 쿼리요청 시 에러 페이지가 아닌 정상 페이지가 반환되도록 필터링 처리하고 웹방화벽에 SQL 인젝션 관련 룰셋을 적용하여 SQL 인젝션 공격을 차단함 |
| 조치 시 영향 | 웹 서비스에서 사용하고 있는 명령어 및 특수문자가 필터링 되어 장애가 발생 될 수 있어 사전 영향도 및 코드 분석이 필요 |

#### 점검 및 조치 사례

```
- 점검 방법
Step 1) 사용자 입력값 조건에 따른 참, 거짓 SQL 쿼리를 삽입하여, 응답의 변화(응답시간, 에러메시지, 응답 내용 등) 유무 확인
[ DB 쿼리 삽입을 통한 취약점 유무 판단 ]

Step 2) 인증 페이지(로그인, 비밀번호 검증 등) 내 참이 되는 SQL쿼리를 삽입하여 우회 유무 확인
[ 인증 페이지 내 DB 쿼리 삽입을 통한 인증 우회 확인 ]
```

```
- 조치 방법
1. SQL 쿼리 내 사용되는 문자열의 유효성을 검증하는 로직 구현
2. 아래와 같은 특수문자에 대하여 사용자 입력값으로 지정 금지

| 문자 | 상세 설명 |
| :--- | :--- |
| ' | 문자 데이터 구분 기호 |
| ; | 쿼리 구분 기호 |
| --, # | 해당 라인 주석 구분 기호 |
| /* */ | /* 와 */ 사이 구문 주석 |

3. Prepared Statements를 사용하여 사용자 입력과 SQL 쿼리를 분리하여 처리
4. 시스템에서 제공하는 에러 메시지 및 DBMS에서 제공하는 에러코드가 노출되지 않도록 예외처리
5. 웹 방화벽(WAF)에 대하여 SQL Injection 관련 룰셋 추가
```

**※ Java**

```
SQL 키워드 및 특수문자 필터링 로직 예시
...
public static String sanitize(String input) {
 if (input == null) {
 return null;
 }
 // 특수문자 및 키워드들을 공백으로 치환
 String[] sqlKeywords = {"SELECT", "UNION", "INSERT", "UPDATE", "DELETE", "DROP", "--"};
 String pattern = "(?i)\\b(" + String.join("|", sqlKeywords) + ")\\b|['\"\\\\;()<>#/*!]";
 Pattern regex = Pattern.compile(pattern + "|--");
 Matcher matcher = regex.matcher(input);
 return matcher.replaceAll(" ");
}
...
String sanitizedInput = sanitize(userInput);
Prepared Statement 사용 로직 예시
...
String sql = "SELECT * FROM users WHERE username = ?";
PreparedStatement preparedStatement = connection.prepareStatement(sql);
preparedStatement.setString(1, userInput);
...
ResultSet resultSet = preparedStatement.executeQuery();
...
```

```
§ JDBC 표준 예외 클래스를 사용하여 다양한 데이터베이스 시스템에 일관된 방식으로 예외처리
적절한 예외 처리 예시
try {
 // 데이터베이스 작업
} catch (SQLException e) {
 // 브라우저에 일반적인 오류 메시지를 반환
 e.printStackTrace();
 System.out.println("An error occurred. Please try again later.");
}
§ 사용자 입력을 직접 쿼리에 포함시킬 시 취약점이 발생하므로, 파라미터 바인딩을 사용하여 구현
§ 파라미터 바인딩 : 쿼리를 실행할 때, 쿼리 문자열과 사용자 입력값(파라미터)을 분리하여 처리하는 기법. 데이터베이스는 쿼리 문자열을 미리 파싱하고 컴파일하며, 쿼리 실행 시점에 파싱된 쿼리 문자열에 파라미터를 바인딩하여 데이터를 전달하므로 데이터베이스는 파라미터를 데이터로만 인식함
ORM(JPA-Hibernate) 파라미터 바인딩 사용 예시
public class ItemService {
 @PersistenceContext
 private EntityManager em;
 public List<Item> findItemsByUserInput(String userInput) {

 // JPQL을 사용하여 SQL Injection 방지
 String jpql = "SELECT i FROM Item i WHERE i.itemID > :userInput";
 Query query = em.createQuery(jpql, Item.class);
 query.setParameter("userInput", userInput);
 return query.getResultList();
 }
}
§ SQL Mapper(Mybatis) 내 '${}' 구문의 경우 사용자 입력값이 SQL 구문으로 해석되기 때문에 파라미터 바인딩('#{}')을 사용하여 구현
SQL Mapper(Mybatis) 파라미터 바인딩 사용 예시
...
 <!-- 학생 정보 삽입 -->
 <insert id="insertStudent" parameterType="com.example.Student">
 INSERT INTO STUDENTS (NUM, NAME, AGE, GRADE)
 VALUES (#{num}, #{name}, #{age}, #{grade})
 </insert>
 <!-- 학생 정보 삭제 -->
 <delete id="deleteStudent" parameterType="int">
 DELETE FROM STUDENTS
 WHERE NUM = #{num}
 </delete>
...
```

**※ ASP.NET**

```
§ 정규표현식을 활용하여 SQL 키워드 및 특수문자에 대하여 필터링 로직 구현
SQL 키워드 및 특수문자 필터링 로직 예시
public static string Sanitize(string input)
{
 if (input == null)
 {
 return null;
 }
 // 특수문자들을 공백으로 치환
 string[] sqlKeywords = { "SELECT", "UNION", "INSERT", "UPDATE", "DELETE", "DROP", "--" };
 string pattern = @"(?i)\b(" + string.Join("|", sqlKeywords) + @")\b|['""\\;()<>#/!*]";
 return Regex.Replace(input, pattern, " ");
}
string sanitizedInput = Sanitize(userInput);
...
Prepared Statement 사용 로직 예시
string strQry = "SELECT count(*) FROM users WHERE userName = @username
 AND Password = @password";
using (SqlCommand cmd = new SqlCommand(strQry, cnx))
{
 cmd.Parameters.Add(new SqlParameter("@username", SqlDbType.VarChar, 50) {
 Value = txtUser.Text });
 cmd.Parameters.Add(new SqlParameter("@password", SqlDbType.VarChar, 50) {
 Value = txtPassword.Text });
 int intRecs = (int)cmd.ExecuteScalar();
 if (intRecs > 0)
 {
 FormsAuthentication.RedirectFromLoginPage(txtUser.Text, false);
 }
 else
 {
 lblMsg.Text = "Login attempt failed.";
 }
}

적절한 에러 예외처리 로직 예시
catch (SqlException ex)
{
 Logger.LogError(ex); // 로그 상세 에러 기록
 // 사용자에게 일반적인 메시지 표시
 lblErrorMessage.Text = "데이터베이스 작업 중 오류가 발생했습니다.";
}
```

**※ ASP**

```
적절한 에러 예외처리 예시
On Error Resume Next ' 에러 발생 시 계속 실행
...
If Err.Number <> 0 Then
 ' 에러가 발생한 경우
 Err.Clear ' 에러 삭제 처리
%>
 <script language="javascript">
 alert("서버에 문제가 발생하였습니다. 잠시 후 다시 시도해 주세요.");
 location.replace("<%=local%>/login/login.asp?ba=search")
 </script>
<%
 response.end
End If
§ SQL Server의 xp_cmdshell 기능의 경우 SQL Server 2005 버전부터 기본적으로 비활성화 되어있음
xp_cmdshell 비활성화 처리 예시
sp_configure 'show advanced options', 1; // SQL Server의 고급 옵션 활성화
GO
RECONFIGURE;
GO
sp_configure 'xp_cmdshell', 0; // xp_cmdshell 비활성화
GO
RECONFIGURE;
GO
```

**※ PHP**

```
§ ereg_replace, eregi_replace 의 경우, PHP 5.3.0 이후 삭제되었으며, addslashes/magic_quotes_gpc의 경우 멀티바이트 문자 입력 시 우회의 가능성이 존재하므로 preg_replace를 이용하여 구현
SQL 키워드 및 특수문자 필터링 로직 예시
function sanitize($input) {
 if ($input === null) {
 return null;
 }
 // 특수문자들을 공백으로 치환
 $sqlKeywords = ["SELECT", "UNION", "INSERT", "UPDATE", "DELETE", "DROP", "--"];
 $pattern = "/(?i)\\b(" . implode("|", $sqlKeywords) . ")\\b|['\"\\\\;()<>#\/!*]/";
 return preg_replace($pattern, " ", $input);
}
$sanitizedInput = sanitize($userInput);
Prepared Statement 사용 로직 예시
...
$sql = "SELECT * FROM users WHERE username = ?";
$stmt = $pdo->prepare($sql);
$stmt->execute([$userInput]);
...
$results = $stmt->fetchAll(PDO::FETCH_ASSOC);
...
적절한 에러 예외처리 예시
...
try {
 // 데이터베이스 작업
} catch (PDOException $e) { // PDO 확장의 표준 예외 클래스를 사용하여 예외처리
 // 브라우저에 일반적인 오류 메시지를 반환
 error_log($e->getMessage());
 echo 'SQL Exception';
}
...
```

---

*(이하 디렉터리 인덱싱(DI), 에러 페이지 적용 미흡(EP), 정보 누출(IL), 크로스사이트 스크립팅(XS), CSRF(CF), SSRF(SF), 약한 비밀번호 정책(BF), 불충분한 인증 절차(IA), 불충분한 권한 검증(IN), 취약한 비밀번호 복구 절차(PR), 프로세스 검증 누락(PV), 악성 파일 업로드(FU), 파일 다운로드(FD), 불충분한 세션 관리(IS), 데이터 평문 전송(SN), 쿠키 변조(CC), 관리자 페이지 노출(AE), 자동화 공격(AU), 불필요한 Method 악용(WM) 항목이 동일한 형식으로 계속됩니다.)*

---

# XI. 가상화 장비

## 01. 가상화 장비 취약점 분석 · 평가 항목

### 1. 계정 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| 계정 로그오프/세션 관리 | 상 | HV-01 |
| 가상화 장비 외부접속 차단 | 상 | HV-02 |
| 가상화 장비 루트계정 관리 | 상 | HV-03 |
| 가상화 장비 계정 권한 관리 | 상 | HV-04 |
| 가상화 장비 사용자 인증 강화 | 상 | HV-05 |
| 비밀번호 관리정책 설정 | 상 | HV-06 |
| 계정 잠금 임계값 설정 | 상 | HV-07 |

### 2. 시스템 서비스 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| 시스템 사용 주의사항 출력 설정 | 중 | HV-08 |
| NTP 및 시각 동기화 설정 | 중 | HV-09 |
| SNMP Community String 복잡성 적용 | 중 | HV-10 |
| MOB(Managed Object Browser) 서비스 비활성화 | 상 | HV-11 |
| ESXi Shell 비활성화 | 상 | HV-12 |
| ESXi Shell 세션 종료 시간 설정 | 상 | HV-13 |
| 원격 로그 서버 이용 | 중 | HV-14 |
| 시스템 주요 이벤트 로그 설정 | 상 | HV-15 |
| 비휘발성 경로 내 로그 파일 저장 | 상 | HV-16 |

### 3. 가상 머신 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| 코어덤프 수집 기능 활성화 | 상 | HV-17 |
| 가상 머신의 장치 변경 제한 설정 | 상 | HV-18 |
| 가상 머신의 불필요한 장치 제거 | 상 | HV-19 |
| 가상 머신 콘솔 클립보드 복사&붙여넣기 기능 비활성화 | 상 | HV-20 |
| 가상 머신 콘솔 드래그 앤 드롭 기능 비활성화 | 상 | HV-21 |

### 4. 가상 네트워크 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| 가상 스위치 MAC 주소 변경 정책 비활성화 | 상 | HV-22 |
| 가상 스위치 무차별(Promiscuous) 모드 정책 비활성화 | 상 | HV-23 |
| 가상 스위치 위조전송(Forged Transmits) 모드 정책 비활성화 | 상 | HV-24 |
| 주기적 보안 패치 및 벤더 권고사항 적용 | 상 | HV-25 |

---

## 1. 계정 관리

### HV-01 (상) 계정 로그오프/세션 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 웹 콘솔 및 사용자 Shell Session Timeout 설정 여부 점검 |
| 점검 목적 | Session Timeout 기능을 구현하여 공격자가 만료되지 않은 세션 활용을 방지하기 위함 |
| 보안 위험 | 세션의 만료 기간을 정하지 않거나, 만료기한이 너무 길게 설정된 경우 악의적인 사용자가 만료되지 않은 세션을 활용하여 불법적인 접근을 시도할 수 있는 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | VMware ESXi, vCenter, XenServer, KVM, Nutanix |
| 판단 기준 | **양호**: 웹 콘솔 및 사용자 Shell Session Timeout 설정이 600초(10분) 이하로 설정된 경우<br>**취약**: 웹 콘솔 및 사용자 Shell Session Timeout 설정이 600초(10분)를 초과하여 설정된 경우 |
| 조치 방법 | 600초(10분) 동안 입력이 없을 경우 접속된 클라이언트 세션을 끊도록 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● VMware ESXi, vCenter**

```
[웹 콘솔 Session Timeout 설정]
Step 1) Web 콘솔 페이지 접속
https://<VMware ESXi IP>
Step 2) 호스트 > 관리 > 시스템 > 고급 설정으로 이동
Step 3) UserVars.HostClientSessionTimeout 설정이 600초(10분)로 설정되어 있는지 확인
[ 웹 콘솔 Session Timeout 설정 확인 ]
Step 4) 600초(10분) 이하로 설정되어 있지 않은 경우 [옵션 편집]을 클릭하여 아래와 같이 수정
[ 옵션 값 수정 ]
```

**● XenServer, KVM**

```
[사용자 Shell Session Timeout 설정]
Step 1) 호스트에 접속
Step 2) echo $TMOUT 명령어를 이용하여 사용자 Shell Session Timeout 설정 확인
$ echo $TMOUT
9000
Step 3) Session Timeout 10분을 초과하는 경우 아래 두 라인 추가
$ vi /etc/profile
readonly TMOUT=600;
export TMOUT
Step 4) 변경된 설정 적용
$ source /etc/profile
```

**● Nutanix**

```
[사용자 Shell Session Timeout 설정]
Step 1) Controller VM에 접속하여 User Shell Session Timeout 설정 확인
sudo cat /etc/profile.d/os-security.sh
readonly TMOUT=9000 2> /dev/null || echo "TMOUT already set."
readonly HISTFILE
mesg n 2>/dev/null
Step 2) vi 편집기를 이용하여 User Shell Session Timeout을 10분으로 설정
sudo vi /srv/salt/security/CVM/shellCVM.sls
ossecuritycreate:
 file:
 - managed
 - name: /etc/profile.d/os-security.sh
 - mode: 644
 - user: root
 - group: root
 - contents: |
 readonly TMOUT=600 2> /dev/null || echo "TMOUT already set."
Step 3) 변경된 설정 적용
sudo salt-call state.sls security/CVM/shellCVM
```

```
[SSH Idle Timeout 설정]
Step 1) Controller VM에 접속하여 SSH Idle Timeout 설정 확인
sudo cat /etc/ssh/sshd_config | grep "ClientAliveInterval"
Step 2) vi 편집기를 이용하여 SSH Idle Timeout을 10분으로 설정
sudo vi /srv/salt/security/CVM/sshd/sshdconfCVM
ClientAliveInterval 600
Step 3) 변경 설정 적용
sudo salt-call state.sls security/CVM/sshdCVM
```

```
[관리 웹 콘솔 Session Timeout 설정]
Step 1) 관리 웹 콘솔 접속
https://<Nutanix 웹 콘솔 IP:9440>
Step 2) Session Timeout 설정 적용
Settings > UI Settings > Security Setting의 SESSION TIMTOUT 설정을 10분으로 설정
```

---

### HV-02 (상) 가상화 장비 외부접속 차단

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 허용할 호스트에 대한 접속 IP 제한 설정 여부 점검 |
| 점검 목적 | 허용한 호스트만 서비스를 사용하게 하여 비인가자의 무단 접근 시도를 예방하기 위함 |
| 보안 위험 | 호스트에서 실행되는 서비스에 대한 접근을 제한하지 않으면 비인가자의 무단 접근에 노출되어 가상화 시스템 침해사고의 위험이 존재함 |
| 참고 | ※ TCP Wrapper: 호스트 기반의 네트워킹 ACL(Access Control List) 시스템<br>※ IPTables: 리눅스 커널 방화벽이 제공하는 테이블들과 그것을 저장하는 체인, 규칙들을 구성할 수 있게 해주는 서비스<br>※ FirewallD: Linux 운영체제를 위한 방화벽 관리 도구 |
| **점검 대상 및 판단 기준** | |
| 대상 | VMware ESXi, vCenter, XenServer, KVM, Nutanix |
| 판단 기준 | **양호**: 허용된 IP에서만 관리 콘솔 및 원격 접속이 가능하도록 제한된 경우<br>**취약**: 허용된 IP에서만 관리 콘솔 및 원격 접속이 가능하도록 제한되지 않은 경우 |
| 조치 방법 | 호스트에서 제공하는 방화벽 애플리케이션을 이용하여 서비스 접속 허용 IP 등록 설정 |
| 조치 시 영향 | IPTables의 기본 정책을 Drop으로 변경하는 경우에는 애플리케이션 간의 연결 현황을 확인 후 변경이 필요함 |

#### 점검 및 조치 사례

**● VMware ESXi, vCenter**

```
[웹 콘솔 접속 IP 제한 설정]
Step 1) Web 콘솔 페이지 접속
https://<VMware ESXi IP>
Step 2) 네트워킹 > 방화벽 규칙으로 이동
Step 3) [ESXi] SSH 서버 “허용된 IP주소” 확인
Step 4) [vSphere] 웹 클라이언트 “허용된 IP주소” 확인
[ 허용된 IP주소 확인 ]
Step 5) IP 제한 설정이 적용되어 있지 않은 경우 vSphere Web Client(SSH 서버) > 설정 편집 > 다음 네트워크의 연결만 허용 선택
Step 6) 접속 허용 IP 입력
[ 접속 허용 IP 입력 ]
```

**● XenServer, KVM**

```
[IPTables를 통한 접근 통제]
Step 1) 호스트 접속
$ iptables -nL --line-number
Chain INPUT (policy ACCEPT)
num target prot opt source destination
1 xapi_nbd_input_chain tcp -- 0.0.0.0/0 0.0.0.0/0 tcp dpt:10809
2 ACCEPT 47 -- 0.0.0.0/0 0.0.0.0/0
3 RH-Firewall-1-INPUT all -- 0.0.0.0/0 0.0.0.0/0
… 중간 생략 …
Chain RH-Firewall-1-INPUT (2 references)
num target prot opt source destination
1 ACCEPT all -- 0.0.0.0/0 0.0.0.0/0
2 ACCEPT icmp -- 0.0.0.0/0 0.0.0.0/0 icmptype 255
3 ACCEPT udp -- 0.0.0.0/0 0.0.0.0/0 udp dpt:67
4 ACCEPT all -- 0.0.0.0/0 0.0.0.0/0 ctstate RELATED,ESTABLISHED
5 ACCEPT udp -- 0.0.0.0/0 0.0.0.0/0 ctstate NEW udp dpt:694
Step 2) IPTables 정책 목록을 통해 접속 IP 제한 설정 확인
Step 3) SSH 원격 접속을 허용된 IP로만 제한
$ iptables -I RH-Firewall-1-INPUT 1 -p tcp -s <허용 IP> --dport 22 -j ACCEPT
$ iptables -I RH-Firewall-1-INPUT 2 -p tcp -s 0.0.0.0/0 --dport 22 -j DROP
Step 4) IPTables의 변경된 정책 저장 및 서비스 재시작
$ service iptables save
$ service iptables restart
```

**● Nutanix**

```
Step 1) Controller VM에 접속하여 설정 확인
sudo cat /etc/hosts.allow | grep –v "^#“
Step 2) vi 편집기를 이용하여 hosts.allow 파일에 ssh 접속이 필요한 IP만 접속을 허용 하도록 설정
sudo vi /srv/salt/security/CVM/network/hosts.allow
sshd: 192.168.100.1 : ALLOW
Step 3) 변경 설정 적용
sudo salt-call state.sls security/CVM/networkCVM
```

---

*(이하 HV-03부터 HV-25까지 동일한 형식으로 계속됩니다.)*

---

# XII. 클라우드

## 01. 클라우드 취약점 분석 · 평가 항목

### 1. 계정 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| 사용자 계정 관리 | 상 | CA-01 |
| 사용자 정책 관리 | 중 | CA-02 |
| MFA(Multi-Factor Authentication) 설정 | 상 | CA-03 |
| 클라우드 계정 비밀번호 정책 관리 | 중 | CA-04 |

### 2. 권한 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| 인스턴스 서비스 정책 관리 | 상 | CA-05 |
| 네트워크 서비스 정책 관리 | 상 | CA-06 |

### 3. 가상 리소스 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| VPC 네트워크 서브넷 관리 | 상 | CA-07 |
| 가상 네트워크 리소스 관리 | 중 | CA-08 |
| 접근 제어 설정 관리 | 상 | CA-09 |
| 스토리지 리소스 퍼블릭 접근 관리 | 중 | CA-10 |

### 4. 운영 관리

| 점검항목 | 중요도 | 항목코드 |
| :--- | :---: | :---: |
| 관계형 데이터베이스 암호화 설정 | 중 | CA-11 |
| 통신 구간 암호화 설정 | 중 | CA-12 |
| 클라우드 서비스 사용자 계정 로깅 설정 | 상 | CA-13 |
| 인스턴스 로깅 설정 | 중 | CA-14 |
| 관계형 데이터베이스 로깅 설정 | 중 | CA-15 |
| 오브젝트 스토리지 버킷 로깅 설정 | 중 | CA-16 |
| 로그 보관 기간 설정 | 중 | CA-17 |
| 백업 사용 여부 | 중 | CA-18 |
| 가상 리소스 이상징후 알림 설정 | 중 | CA-19 |

---

## 1. 계정 관리

### CA-01 (상) 사용자 계정 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 불필요한 클라우드 관리 콘솔 계정 존재 여부 점검 |
| 점검 목적 | 불필요한 계정(퇴직, 전직, 휴직 등의 사유로 사용하지 않는 계정 및 장기간 사용하지 않는 계정 등)이 존재하는지 점검하여 관리되지 않은 계정에 의한 침입에 대비하기 위함 |
| 보안 위험 | 불필요한 계정을 관리하지 않는 경우 비인가자의 무단 접근이 가능하며, 공용 계정 및 퇴사자 계정이 존재할 경우 해당 계정을 통한 침해사고 발생 시 사후 추적이 어려울 수 있는 위험이 존재함 |
| 참고 | ※ 불필요한 계정 삭제 시 업무 영향도 파악 후 삭제 권고 |
| **점검 대상 및 판단 기준** | |
| 대상 | 클라우드 플랫폼 |
| 판단 기준 | **양호**: 불필요한 계정이 존재하지 않거나 비활성화된 경우<br>**취약**: 불필요한 계정이 존재하며 활성화 된 경우 |
| 조치 방법 | 클라우드 관리 콘솔에 등록된 계정 현황 확인 후 불필요한 계정 삭제 또는 비활성화 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● 공통**

```
Step 1) 불필요한 클라우드 콘솔 계정 제거
§ 클라우드 서비스를 운영하는 데 있어 관리 콘솔에 접근할 수 있는 불필요한 계정이 존재할 경우 클라우드 서비스 침해 사고가 발생할 수 있으므로 퇴사자 및 장기 미사용 계정은 삭제 또는 비활성화 하여 클라우드 서비스를 운영해야 함
```

---

### CA-02 (중) 사용자 정책 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 사용자 계정에 적절한 권한 부여 여부 점검 |
| 점검 목적 | 계정별 권한을 점검하여 권한의 오남용을 예방하기 위함 |
| 보안 위험 | 사용자 정책 관리가 적절하게 할당되지 않을 경우 무단 접근, 데이터 유출, 내부자 위협 등 보안 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | Cloud Platform |
| 판단 기준 | **양호**: 사용자/그룹의 목적에 맞게 역할/권한이 할당된 경우<br>**취약**: 사용자/그룹을 목적에 맞지 않게 역할/권한이 할당된 경우 |
| 조치 방법 | 사용자/그룹의 역할/권한을 목적에 맞게 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● 공통**

```
Step 1) 계정 및 그룹 확인 후 불필요한 권한 제거
§ 클라우드 서비스 운영 시 사용자에 대한 직무 및 역할에 맞는 사용자 권한을 설정하고, 권한 오남용이 발생하지 않도록 주기적인 정책 검토가 요구됨
§ 관리자 및 일반 사용자 등 관리 정책이나 권한을 분리하여 1인 1계정으로 운영되어야 함

Step 2) 별도의 계정을 생성하여 서비스 운영에 활용
§ 콘솔 최상위 관리자(최초 가입계정) 계정은 서비스 운영에 활용 금지
§ 서비스에 대해 관리자 권한이 필요한 경우, 신규로 계정을 생성하여 필요한 권한을 부여하여 활용
```

---

### CA-03 (상) MFA(Multi-Factor Authentication) 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 2차 인증을 통해 사용자 계정의 보안을 강화 여부 점검 |
| 점검 목적 | 사용자 계정의 보안을 강화하여 무단 접근을 방지하고, 계정 탈취 및 데이터 유출의 위험을 줄이기 위함 |
| 보안 위험 | 2차 인증을 사용하지 않을 경우, 다양한 비밀번호 추측 공격에 노출될 가능성이 높으며, 이러한 공격으로 인해 계정이 탈취되어 중요 데이터 유출 및 로그 변조 등의 시스템 악용이 발생할 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | 클라우드 플랫폼 |
| 판단 기준 | **양호**: 각 계정별 2차 인증이 설정된 경우<br>**취약**: 각 계정별 2차 인증이 설정되지 않은 경우 |
| 조치 방법 | 인증 번호, OTP 등을 통한 2차 인증 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● 공통**

```
Step 1) 2차 인증 설정
§ 클라우드 서비스 관리 계정에 2차 인증을 사용하지 않으면 관리 계정이 탈취 및 데이터 유출 위험이 존재함
§ 각 계정별 2차 인증을 사용해 계정 탈취를 방지해야 함
§ 2차 인증은 휴대전화 문자 인증, 이메일 인증, OTP 등으로 설정되어야 함
```

---

### CA-04 (중) 클라우드 계정 비밀번호 정책 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 비밀번호 설정 정책의 복잡성 만족 여부 점검 |
| 점검 목적 | 안전한 비밀번호(*비밀번호 설정 기준 참조)를 사용함으로써 무차별 대입 공격, 사전 공격 등 비밀번호 탈취 목적의 공격에 대해 대비하기 위함 |
| 보안 위험 | 무차별 대입 공격, 비밀번호 추측 공격 등 비밀번호가 비교적 단순하거나 비교적 자주 쓰이는 비밀번호(예:1q2w3e4r! 등)로 비인가 접근을 시도하는 공격 위험이 존재함 |
| 참고 | ※ 무차별 대입 공격(Brute-force Attack): 특정한 암호를 풀기 위해 가능한 모든 조합을 시도하여 비밀번호를 찾아내는 공격 방식<br>※ 사전 공격(Dictionary attack): 사전에 있는 단어를 입력하여 비밀번호를 알아내거나 해독하는 컴퓨터 공격 방식 |
| **점검 대상 및 판단 기준** | |
| 대상 | 클라우드 플랫폼 |
| 판단 기준 | **양호**: 복잡성을 만족하는 비밀번호 정책을 설정하고 로그인 시도 제한을 설정한 경우<br>**취약**: 복잡성을 만족하지 않는 비밀번호를 사용하거나 로그인 시도 제한을 설정하지 않은 경우 |
| 조치 방법 | 비밀번호 정책을 해당 기관의 보안 정책에 적합하게 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● 공통**

```
Step 1) 클라우드 콘솔 계정에 대한 비밀번호 정책 설정
§ 클라우드 관리 콘솔 계정 비밀번호는 영문자, 숫자 및 특수문자를 두개 조합시에는 10자리 이상, 세 개 조합시에는 8자리 이상 사용해야 함
§ 무차별 대입 공격을 방지하기 위한 로그인 시도 횟수 제한 설정 적용이 필요함
```

---

*(이하 CA-05부터 CA-19까지 동일한 형식으로 계속됩니다.)*

---

*(Part 11 끝. 이상으로 Web Application, 가상화 장비, 클라우드 파트가 완료되었습니다. 다음 Part 12에서는 나머지 Web Application 항목과 가상화 장비, 클라우드 상세 내용이 이어집니다.)*