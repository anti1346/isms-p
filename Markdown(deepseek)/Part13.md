## 15. 파일 다운로드

### FD (상) 파일 다운로드

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 웹 사이트에서 허용된 경로 외 다른 경로의 파일 접근 및 다운로드 가능 여부 점검 |
| 점검 목적 | 허용된 경로 외 다른 경로의 비인가된 접근을 방지하여, 공격자가 임의의 경로에 존재하는 파일을 열람하거나 다운로드하는 것을 차단하기 위함 |
| 보안 위험 | Ÿ 해당 취약점이 존재할 경우, 공격자는 파일 다운로드 시 애플리케이션의 파라미터 값을 조작하여 웹 사이트의 중요한 파일(DB 커넥션 파일, 애플리케이션 파일 등) 또는 웹 애플리케이션 서버 루트에 있는 중요한 설정 파일(/etc/passwd, /etc/shadow 등)을 다운로드할 수 있음<br>Ÿ CGI, JSP, PHP 등 파일 다운로드 기능을 제공하는 애플리케이션에서 입력 경로를 검증하지 않는 경우, 공격자는 임의의 문자(../.. 등)나 주요 파일명을 입력하여 웹 애플리케이션 서버의 홈 디렉터리를 벗어나 임의의 위치에 있는 파일을 열람하거나 다운로드할 수 있음 |
| 참고 | ※ 경로 추적: 웹 서버와 웹 애플리케이션의 파일 또는 디렉터리에 대한 접근이 적절히 통제되지 않아, 중요한 파일과 데이터에 비인가된 접근을 허용하는 취약점<br>※ 소스코드 및 취약점 점검 필요 |
| **점검 대상 및 판단 기준** | |
| 대상 | 웹 애플리케이션 소스코드, 웹 애플리케이션 서버, 웹 방화벽 |
| 판단 기준 | **양호**: 입력값이 검증되어 허용된 경로와 파일만 접근 가능하고, 경로 조작 및 임의 시스템 파일 다운로드가 불가능하며, 다운로드 디렉터리 외의 접근과 상위 디렉터리 접근이 차단된 경우<br>**취약**: 입력값이 검증없이 처리되어 임의의 경로로 접근이 가능하거나 비인가된 파일을 다운로드할 수 있는 경우 |
| 조치 방법 | 다운로드 시 허용된 경로 이외의 디렉터리와 파일에 접근할 수 없도록 구현하고, 서버 사이드에서 ../..와 같은 경로 이동 관련 문자열에 대해 입력값 검증을 수행하여 비인가된 접근을 차단함 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

```
- 점검 방법
Step 1) 웹 사이트 내 파일 다운로드 기능 식별 후 파일 다운로드 요청 및 응답 패킷 내 URL 파라미터, POST 데이터, 쿠키 등을 통해 파일 이름 및 경로 노출 여부 확인(또는 웹 사이트 내 이미지 렌더링 시 이미지 파일의 경로를 참조하는 경우)
[ 프록시 도구를 이용한 파일 다운로드 파라미터 확인 ]

Step 2) 파일 다운로드 시 요청 패킷 내 파일 경로를 상대 경로(../../ 또는 ..\..\)로 변조하여 요청할 경우 정상적으로 해당 경로 내 파일 다운로드 여부 확인
[ 프록시 도구를 이용한 경로 조작 및 임의 시스템 파일 다운로드 시도 ]

Step 3) "Step 2"에서 파일 다운로드가 불가능한 경우 변조한 파일 경로를 아래의 인코딩(또는 치환, 종단 문자 추가)을 적용하여 우회 가능 여부 확인
[ 입력값 인코딩을 통한 우회 공격 시도 ]
```

**※ 참고: 운영체제별 중요 시스템 파일 예시**

| 구분 | 파일 경로 | 설명 |
| :--- | :--- | :--- |
| Linux | /etc/passwd | 시스템유저 계정 리스트 |
| | /etc/group | 시스템그룹 정보 리스트 |
| | /etc/hosts | 호스트명과 IP주소 매핑 정보 |
| | /var/log/message | 시스템 메시지 로그 |
| | ~.bash_history | 사용자 명령어 기록 |
| | /etc/service | 활성화된 서비스 정보 |
| Windows | C:\Windows\System32\config\SAM | 사용자 계정 및 암호의 해시 정보 |
| | C:\Windows\System32\config\SYSTEM | 시스템 설정과 관련된 레지스트리 파일 |
| | C:\Windows\System32\config\AppEvent.evt | 응용프로그램 이벤트 로그 |
| | C:\Windows\System32\config\SecEvent.evt | 보안 이벤트 로그 |
| | C:\Windows\System32\drivers\etc\hosts | 호스트명과 IP주소 매핑 정보 |

**※ 참고: 우회 방안 예시**

```
§ 인코딩 적용 : 필터링 시스템이 특정 문자열 패턴을 차단하는 경우 문자열을 인코딩하여 우회 시도
```

| 인코딩 방식 | 사용 예시 |
| :--- | :--- |
| 16bit 유니코드 인코딩 | .(%u002e), /(%u2215), \(%u2216) |
| URL 인코딩 | .(%2e), /(%2f), \(%5c) |
| 더블 URL 인코딩 | .(%252e), /(%252f), \(%255c) |
| Base64인코딩 | ../../etc/passwd (Li4vLi4vZXRjL3Bhc3N3ZA==) |
| HTML 엔티티 인코딩 | ..&#x2F;..&#x2F;etc&#x2F;passwd |

```
§ 특수문자 중첩 사용 : 필터링 시스템이 단일 패턴(../)을 감지하여 소거할 경우, 중복된 경로 문자를 사용하여 우회( ....// → ../ )
§ 종단 문자 추가 : 필터링 시스템이 특정 확장자만 허용할 때 Nullbyte, 개행 문자 등을 사용하여 우회([파일명]%00.jpg , [파일명]%0a.jpg 등)
§ 문자열 패턴 검증 우회 : 시스템 파일 관련 단어(etc, passwd 등)들을 필터링할 때 대소문자 변환(EtC, PaSswD 등), URL인코딩과 조합(e%74c%2Fpa%73%73wd) 등의 방법을 사용하여 우회
```

```
- 조치 방법
1. 파일 다운로드의 취약점은 주로 파일 이름 조작으로 인해 발생되므로 파일의 이름을 데이터베이스에 저장하고 다운로드 수행 시 요청 파일 이름과 비교하여 적절한지 확인하여 사용자가 조작할 수 있는 공격 포인트를 제거
2. 파일 다운로드가 가능한 디렉터리를 별도의 파티션에서 관리하거나 특정 디렉터리로 한정하여 다른 디렉터리에서는 파일을 다운받을 수 없도록 설정
3. URL을 통해 파일 경로를 직접 노출시키지 않고, 파일 ID나 토큰을 사용하여 파일 경로를 은닉
4. 공격자가 입력값 변조를 통한 경로 추적이 불가하도록 파일 확장자 등의 일부 패턴을 화이트리스트로 적용하여 검증하고, 경로 추적 관련 특수문자(. / \ % 등) 필터링 로직 구현
```

**※ Java**

```
특수문자 필터링을 통한 입력값 검증 로직 예시
public class FileDownloadUtil {
 //파일 이름에 영문,숫자,일부 특수문자를 제외한 \,/ 문자 등이 탐지되었을 때 다운로드 차단
 public static boolean isValidFileName(String fileName) {
 return fileName != null && fileName.matches("^[a-zA-Z0-9._-]+$");
 }

 private static final Set<String> ALLOWED_EXTENSIONS;

 //허용 확장자 리스트
 static {
 Set<String> tempSet = new HashSet<>();
 tempSet.add("jpg");
 tempSet.add("png");
 ALLOWED_EXTENSIONS = Collections.unmodifiableSet(tempSet);
 }
 public static boolean isAllowedExtension(String filePath) {
 String extension = filePath.substring(filePath.lastIndexOf(".") + 1).toLowerCase();
 // 파일 확장자 검증
 return ALLOWED_EXTENSIONS.contains(extension);
 }
}
...
@GetMapping("/downloadFile")
 public ResponseEntity<Resource> downloadFile(@RequestParam String filename,
HttpServletResponse response) throws IOException {
 if(!FileDownloadUtil.isValidFileName(filename) || !FileDownloadUtil.isAllowedExtension(filename)) {

 // 다운로드 컨트롤러에 검증 로직 적용
 return ResponseEntity.badRequest().build();
 }
...
```

**※ ASP.NET**

```
§ 경로 정규화: 다양한 형태의 파일 경로를 표준화된 형식으로 변환시키는 과정으로 ../ 와 같은 상대 경로 참조를 해석하고 제거하여 허가되지 않은 디렉터리 접근을 차단함
경로 정규화를 통한 경로 검증 로직 예시
filename = Path.GetFileName(filename);
var uploadsFolder = Path.Combine(_environment.WebRootPath, "uploads");
//지정된 업로드 폴더와 정규화된 파일 이름을 결합
var filePath = Path.GetFullPath(Path.Combine(uploadsFolder, filename));
...
if (!filePath.StartsWith(uploadsFolder, StringComparison.OrdinalIgnoreCase)) {
 //해당 파일이 업로드 폴더 내 존재하는지 검증
 return BadRequest("Invalid file path.");
}
...
```

**※ PHP**

```
§ php.ini 에서 magic_quotes_gpc를 On으로 설정하여 .\./ 와 같은 역 슬러시 문자 입력 시 치환되도록 설정이 가능하나, PHP 5.4.0 이후로는 해당 기능이 제거됨
§ filter_input() 함수를 이용해 사용자 입력 데이터를 안전하게 필터링할 수 있으며, realpath() 함수를 이용해 경로를 정규화하고 실제 경로를 반환하므로, 이를 통해 상위 경로 탐색을 방지함
경로 정규화를 통한 경로 검증 로직 예시
// 파일 다운로드 요청 처리
if (isset($_GET['file'])) {
 // file 파라미터 검증 및 처리
 $file = filter_input(INPUT_GET, 'file', FILTER_SANITIZE_STRING);
 $filePath = realpath('../uploads/' . $file); //지정된 업로드 디렉터리에 실제 존재하는지 확인
 // 파일 경로가 지정된 디렉토리 내에 있는지 확인
 if ($filePath && strpos($filePath, realpath('../uploads/')) === 0) {
 downloadFile($filePath);
 } else {
 echo "잘못된 파일 경로입니다.";
 exit;
...
```

---

## 16. 불충분한 세션 관리

### IS (상) 불충분한 세션 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 세션 만료 기간 설정, 예측 가능한 세션 ID 생성, 고정된 세션 ID 발행 등 세션 관리 정책을 점검하고, 인증 토큰(JWT 등) 사용 시에도 안전한 서명 알고리즘 사용 여부, 안전한 비밀 키 사용 여부, 토큰 만료 등의 정책 점검 |
| 점검 목적 | 사용자의 세션 ID를 적절히 관리하여 공격자가 불법적으로 접근하거나 비인가적인 세션 탈취를 차단하기 위함 |
| 보안 위험 | 사용자에게 발급되는 세션 ID가 만료되지 않거나, 고정 및 예측 가능한 형태일 경우, 공격자는 해당 세션 ID를 탈취하여 타 사용자나 시스템에 무단 접근할 수 있으며, 이로 인해 중요 데이터의 무결성이 훼손될 수 있음 |
| 참고 | ※ 세션(Session): 일정 시간 동안 같은 사용자(브라우저)로 부터 들어오는 일련의 요구를 하나의 상태로 보고 그 상태를 일정하게 유지시키는 기술<br>※ JSON Web Token (JWT): 헤더, 페이로드, 서명으로 구성되는 JSON 객체 형식이며, 사용자 정보가 클라이언트에 저장되고 서버에 요청 시마다 전송하여 인증 상태를 유지시키는 기술<br>※ 소스코드 및 취약점 점검 필요 |
| **점검 대상 및 판단 기준** | |
| 대상 | 웹 애플리케이션 소스코드, 웹 애플리케이션 서버 |
| 판단 기준 | **양호**: 추측 불가능한 세션 ID가 발급되고, 세션 종료 시간이 설정되어 있는 경우<br>**취약**: 세션 ID가 일정한 패턴으로 발급되거나 세션 종료 시간이 설정되지 않아 세션 재사용이 가능한 경우 |
| 조치 방법 | 추측 불가능한 세션 ID가 발급되도록 로직을 구현하고, 세션 종료 시간 설정 또는 자동 로그아웃 기능을 구현하여 사이트 특성에 맞게 적정 시간을 설정 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

```
- 점검 방법
● 세션(Session)
Step 1) 로그인 과정에서 발급받은 세션 ID를 확인하고 로그아웃 후 재 로그인 시 각각 발급받은 세션 ID에 대해 일정한 패턴이 존재하는지 검증
§ 각각 발급받은 세션 ID를 확인하여 예측 가능한 패턴으로 생성되는지 검증
§ 각각 발급받은 세션 ID를 확인하여 고정된 값으로 생성되는지 검증
[ 세션 발급 시 동일 패턴 유무 확인 ]

Step 2) 로그인 후 웹 페이지 사용을 중지한 상태로 일정 시간이 경과하였을 때 세션이 유지되는지 확인
[ 일정 시간 경과 시 세션 만료 유무 확인 ]

● JWT(JSON Web Token)
Step 1) 사용자 인증 및 상태 유지를 위해 JWT(JSON Web Token)가 사용되는지 확인
(JWT는 일반적으로 Authorization 헤더에 포함되고, 경우에 따라 Cookie 헤더에 포함, 또는 POST 데이터로 전송할 수 있음)
[ JWT 토큰 사용 유무 확인 ]

Step 2) JWT(JSON Web Token)의 헤더와 페이로드 부분을 각각 Base64 디코딩하여 내용을 확인할 수 있으며, 안전한 알고리즘을 사용하는지, 토큰 만료 설정이 적절하게 되었는지, 민감정보가 노출되는지 등을 확인
[ JWT 토큰 디코딩 시 민감정보 노출 유무 확인 ]

Step 3) 페이로드 변조 후 서명을 삭제하거나 None 알고리즘으로 변조하였을 때 토큰이 유효하여 타 계정의 권한 탈취가 가능한지 확인
[ JWT 토큰 익스플로잇 가능성 유무 확인 ]
```

```
- 조치 방법
● 세션 고정 및 예측
1. 공격자가 하나의 유효한 세션 ID를 추측하는 것이 불가능에 가깝도록 길고 복잡한 세션 ID를 생성하여야 하며, 새 로그인 시 기존 세션 ID를 폐기하고 새로운 세션 ID로 발급해야 하며, 이용 중인 계정에 대해 접속 IP와 디바이스 정보를 통해 동시 세션 로그인 여부를 검사해야함
```

**※ Java**

```
세션 생성 로직 예시
@RequestMapping("/login")
public String login(HttpServletRequest request) {
 request.changeSessionId(); // 신규 로그인 시 세션 ID 변경
 return "redirect:/home";
}
//Spring Security 설정에서 세션 고정 방지 및 세션 ID 생성
@Override
protected void configure(HttpSecurity http) throws Exception {
 http.sessionManagement()
.sessionFixation().migrateSession()
.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED)
.maximumSessions(1).maxSessionsPreventsLogin(false)
 .expiredUrl("/login?expired");
}
```

**※ ASP.NET**

```
web.config 파일 설정을 통한 불규칙 세션 ID 발급 설정 예시
<system.web>
...
<!--세션 고정 방지 -->
<sessionState regenerateExpiredSessionId="true">
...
<!--세션 예측 방지 -->
<machineKey validationKey="AutoGenerate,IsolateApps"
 decryptionKey="AutoGenerate,IsolateApps"
 validation="HMACSHA512"
 decryption="AES"
/>
```

**※ PHP**

```
세션 생성 로직 예시
// 기존 세션을 삭제하고 새로운 세션 ID를 생성
session_start();
session_regenerate_id(true);
// 예측 불가한 안전한 세션 ID 생성
ini_set('session.entropy_length', '256');
ini_set('session.entropy_file', '/dev/urandom');
```

```
● 세션 만료
1. 세션 타임아웃이 미흡하게 설정되어있는 경우 사용자가 로그아웃하지 않고 시스템을 떠날 때 타 사용자가 재사용할 수 있는 여지가 존재하므로, 세션 타임아웃 기능을 구현하고 서비스에 따라 10~60분으로 설정할 것을 권고(아래 예시들은 60분으로 설정)
```

**※ Java**

```
web.xml 파일 설정을 통한 세션 만료 시간 설정 예시
<session-config>
 <session-timeout>60</session-timeout> <!-- 60분 -->
</session-config>
§ Spring Boot의 경우 application.properties 및 소스코드를 통하여 세션 만료 제어 가능
application.properties 파일 설정을 통한 세션 만료 시간 설정 예시
server.servlet.session.timeout=60m
소스 코드를 통한 세션 만료 시간 설정 예시
public String login(HttpSession session) {
 session.setMaxInactiveInterval(3600); // 60분 (3600초)
 return "Session timeout set to 60 minutes";
```

**※ ASP.NET**

```
web.config 파일 설정을 통한 세션 만료 시간 설정 예시
<configuration>
 <system.web>
 <sessionState timeout="60" /> <!-- 60분 -->
 </system.web>
</configuration>
§ Global.asax 파일에서 세션을 확인하고 접근을 제어하는 로직 추가 예시
(ASP.NET Core의 경우 Startup.cs 파일에서 ConfigureServices, Configure 메소드 수정)
Global.asax 파일을 통한 세션 만료 시간 설정 예시
...
public class Global : HttpApplication {
 void Session_Start(object sender, EventArgs e) {
 Session.Timeout = 60; // 60분
 }
}
...
```

**※ PHP**

```
php.ini 파일 설정을 통한 세션 만료 시간 설정 예시
session.gc_maxlifetime = 3600 ; 60분 (3600초)
session.cookie_lifetime = 3600 ; 60분 (3600초)
.htaccess 파일 설정을 통한 세션 만료 시간 설정 예시
php_value session.gc_maxlifetime 3600
php_value session.cookie_lifetime 3600
소스 코드를 통한 세션 만료 시간 설정 예시
...
ini_set('session.gc_maxlifetime', 3600); // 60분 (3600초)
ini_set('session.cookie_lifetime', 3600); // 60분 (3600초)
session_start();
...
```

```
● JWT(JSON Web Token)
1. 서명이 없는 JWT(JSON Web Token)는 쉽게 조작할 수 있으므로, 서명이 포함된 JWT를 사용하고 해당 서명에 대한 검증 로직 구현
2. 취약한 서명 알고리즘을 사용하는 경우 공격자가 서명을 위조할 수 있으므로, 강력한 서명 알고리즘 사용 권고
3. 공격자가 JWT의 알고리즘을 none으로 설정하여 서명을 우회할 수 있으므로 토큰의 알고리즘을 명시적으로 설정
§ 안전한 서명 알고리즘을 사용하더라도 약한 키(짧거나 예측 가능한 키)는 추측될 위험이 있으므로, 강력하고 랜덤한 비밀 키를 사용하고, 유출되지 않도록 키를 안전하게 관리
§ 토큰이 재사용되지 않도록 짧은 만료 시간을 설정하고, 리프레시 토큰을 사용하여 주기적으로 토큰을 갱신
```

| 안전한 JWT 서명 알고리즘 |
| :--- |
| HS256~512 : 비밀 키를 사용하여 메시지에 해시를 적용 (숫자가 높을수록 긴 출력 길이를 가지며, 높은 수준의 보안을 제공) |
| RS256~512 : 비대칭 키 쌍을 사용하여 서명 생성. 서명은 개인 키로 생성되고 공개 키로 검증 |
| ES256~512 : 타원 곡선 암호화를 사용하여 서명을 생성 |

| 취약한 JWT 서명 알고리즘 |
| :--- |
| HS1 : 취약한 암호화 기술인 SHA-1을 기반으로 함 |
| RS1 : 취약한 암호화 기술인 SHA-1을 기반으로 함 |
| none : 서명을 생략하여 무결성 검증에 취약함 |
| plaintext : 서명을 평문으로 전달하여, 무결성 검증에 취약함 |

---

## 17. 데이터 평문 전송

### SN (상) 데이터 평문 전송

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 서버와 클라이언트 간 통신 시 데이터의 암호화 여부 점검 |
| 점검 목적 | 서버와 클라이언트 간 통신 시 데이터의 암호화 전송 미흡으로 정보 유출의 위험을 방지하고자 함 |
| 보안 위험 | 웹 애플리케이션 통신은 주로 텍스트 기반으로 이루어지므로, 서버와 클라이언트 간 암호화 프로세스를 구현하지 않을 경우 악의적인 사용자가 네트워크 도청(Sniffing)을 통해 정보를 탈취 및 도용할 수 있음 |
| 참고 | ※ Sniffing : 스니퍼(sniff: 냄새를 맡다, 코를 킁킁거리다)를 이용하여 네트워크 상의 데이터를 도청하는 행위<br>※ 소스코드 및 취약점 점검 필요 |
| **점검 대상 및 판단 기준** | |
| 대상 | 웹 애플리케이션 소스코드, 웹 애플리케이션 서버 |
| 판단 기준 | **양호**: 중요 정보 전송구간에 암호화 통신이 적용된 경우<br>**취약**: 중요 정보 전송구간에 암호화 통신이 이루어지지 않는 경우 |
| 조치 방법 | 사이트의 중요 정보 전송구간(로그인, 회원가입, 회원정보관리, 게시판 등)에 대하여 암호화 통신(https, 애플리케이션방식) 적용 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

```
- 점검 방법
Step 1) 중요 정보(인증정보, 개인정보, 로그인페이지 등)를 송수신하는 페이지 존재 여부 확인
[ 중요 정보 송수신 페이지 확인 ]

Step 2) 중요 정보 송수신 페이지가 암호화 통신(https, 데이터 암호화 등)을 하는지 확인
[ 데이터 통신 시 패킷 내 중요 정보 평문 노출 유무 확인 ]

Step 3) 취약한 버전의 암호 프로토콜 사용 시 암호화된 통신 내용이 유출될 가능성이 존재하므로 취약한 버전의 SSL(SSL 2.0, 3.0) 사용 여부를 점검
[ 취약한 버전의 암호 프로토콜 사용 여부 확인 ]
```

```
- 조치 방법
1. 웹상에서의 전송 정보를 제한하여 불필요한 비밀번호, 주민등록번호, 계좌정보와 같은 중요 정보의 전송을 최소화하여야 하며, 중요 정보에 대해서는 SSL 등의 암호화 통신을 사용하여 도청으로부터의 위험을 제거함
2. 쿠키와 같이 클라이언트 사이드에서 노출되는 곳에 비밀번호, 인증인식 값, 개인정보 등의 중요 정보 제거
3. 암호화 전송 시 프로토콜 설계의 결함이 있는 SSLv2, SSLv3은 비활성화 필수, TLSv1.2 이상 사용을 권장함
```

**※ Apache**

```
Apache 서버 설정을 통한 프로토콜 제어 예시
httpd-ssl.conf 또는 ssl.conf의 SSL 관련 VirtualHost 설정에 아래를 추가 SSLProtocol all -SSLv2 -SSLv3 –TLSv1
-TLSv1.1
```

**※ IIS**

```
IIS 서버 설정을 통한 프로토콜 제어 예시
[SSL v2 사용 안 함]
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server]
하위에 '새로만들기' > 'DWord(32비트)' 값 선택 > 이름 부분에 'Enabled' 입력 > 데이터 부분에 '0' 입력 > 시스템 재부팅
[SSL v3 사용 안함]
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server]
하위에 '새로만들기' > 'DWord(32비트)' 값 선택 > 이름 부분에 'Enabled' 입력 > 데이터 부분에 '0' 입력 > 시스템 재부팅
```

---

## 18. 쿠키 변조

### CC (상) 쿠키 변조

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 쿠키 변조를 통한 임의의 타 사용자 권한 탈취 여부 점검 |
| 점검 목적 | 쿠키를 사용하는 경우, 안전한 알고리즘으로 암호화하여 공격자가 쿠키 값 변조를 통해 다른 사용자로 위장하거나 권한을 변경하는 것을 방지하기 위함 |
| 보안 위험 | 클라이언트에 전달되는 쿠키에 사용자 식별 값이 평문으로 노출될 경우 쿠키 변조를 통해 타 사용자의 유효한 세션을 취득할 수 있으며, 기타 중요 정보의 유출 및 변조 가능함 |
| 참고 | ※ 쿠키(Cookie): 서버가 사용자의 웹 브라우저에 전송하는 작은 데이터 조각. 브라우저는 그 데이터 조각들을 저장 후, 동일한 서버에 대하여 재요청 시 저장된 데이터를 함께 전송<br>※ 소스코드 및 취약점 점검 필요 |
| **점검 대상 및 판단 기준** | |
| 대상 | 웹 애플리케이션 소스코드 |
| 판단 기준 | **양호**: 쿠키를 사용하지 않고 서버 사이드 세션을 사용하고 있거나, 쿠키를 사용하는 경우 안전한 알고리즘(SEED, 3DES, AES)이 적용되어 있는 경우<br>**취약**: 안전한 알고리즘이 적용되지 않은 쿠키를 사용하거나, 쿠키로만 인증 및 권한 부여를 적용하는 경우 |
| 조치 방법 | 쿠키 대신 서버 사이드 세션 방식을 사용하거나, 쿠키를 통해 인증 등 중요한 기능을 구현해야 하는 경우 안전한 알고리즘(SEED, 3DES, AES 등)을 적용 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

```
- 점검 방법
Step 1) 일반 사용자 계정으로 로그인 한 뒤 쿠키 내용 및 발행되는 쿠키에 중요 정보(인증을 위한 ID, 권한을 위한 구분자 등)의 노출 여부 확인 후 변조 시도
[ 쿠키 내 사용자 및 주요 권한 검증값 존재 유무 확인 ]

Step 2) 쿠키 내 노출되는 중요 정보를 변조하여 다른 사용자 및 권한으로 정상 이용이 가능한지 확인
[ 쿠키 값 변조를 통한 타 사용자 권한 탈취 여부 확인 ]
```

```
- 조치 방법
1. 쿠키 대신 보안성이 강한 서버 사이드 세션 방식 사용. 클라이언트 사이드 방식인 쿠키는 구조상 다양한 취약점에 노출될 가능성이 존재
2. 쿠키를 사용해서 중요 정보나 인증을 구현해야 할 경우엔 안전한 알고리즘(SEED, 3DES, AES 등) 적용
3. 쿠키 서명(HMAC)을 통해 변조 여부 검증 및 HttpOnly, Secure, SameSite 속성을 적용하여 보안 강화
```

**※ Java**

```
AES + HMAC CookieUtil 예시
public class CookieUtil {
 private static final int IV_LEN = 16, HMAC_LEN = 32;
 private static final SecureRandom RNG = new SecureRandom();
 private final byte[] encKey;
 private final byte[] hmacKey;
 public CookieUtil(byte[] encKey, byte[] hmacKey) {
 if (encKey.length != 32) throw new IllegalArgumentException("AES key must be 32 bytes");
 this.encKey = encKey;
 this.hmacKey = hmacKey;
 }
 // 쿠키 생성 (HttpOnly, Secure, SameSite 설정 포함)
 public void addSecureCookie(HttpServletResponse resp, String name, String plaintext, int maxAgeSec)
throws Exception {
 byte[] iv = new byte[IV_LEN]; RNG.nextBytes(iv);
 // AES-256-CBC 암호화
 Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
 cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(encKey, "AES"), new IvParameterSpec(iv));
 byte[] ciphertext = cipher.doFinal(plaintext.getBytes(StandardCharsets.UTF_8));
 Mac mac = Mac.getInstance("HmacSHA256");
 mac.init(new SecretKeySpec(hmacKey, "HmacSHA256"));
 mac.update(iv); mac.update(ciphertext);
 byte[] hmac = mac.doFinal();
 byte[] payload = new byte[iv.length + hmac.length + ciphertext.length];
 System.arraycopy(iv, 0, payload, 0, iv.length);
 System.arraycopy(hmac, 0, payload, iv.length, hmac.length);
 System.arraycopy(ciphertext, 0, payload, iv.length + hmac.length, ciphertext.length);
 String encoded = Base64.getUrlEncoder().withoutPadding().encodeToString(payload);
 // HttpOnly, Secure 속성 설정
 Cookie cookie = new Cookie(name, encoded);
 cookie.setHttpOnly(true);
 cookie.setSecure(true);
 cookie.setPath("/");
 cookie.setMaxAge(maxAgeSec);
 // SameSite 속성은 Cookie API로 직접 지정 불가 → 헤더로 세팅
 String header = String.format(
 "%s=%s; Max-Age=%d; Path=/; HttpOnly; Secure; SameSite=Strict",
 name, encoded, maxAgeSec
 );
 resp.addHeader("Set-Cookie", header);
 }
 // 쿠키 읽기 (HMAC 검증 + 복호화)
 public String readSecureCookie(String value) throws Exception {
 if (value == null) return null;
 byte[] data;
 try { data = Base64.getUrlDecoder().decode(value); } catch (IllegalArgumentException e) { return null; }
 if (data.length < IV_LEN + HMAC_LEN + 1) return null;
 byte[] iv = Arrays.copyOfRange(data, 0, IV_LEN);
 byte[] hmac = Arrays.copyOfRange(data, IV_LEN, IV_LEN + HMAC_LEN);
 byte[] ciphertext = Arrays.copyOfRange(data, IV_LEN + HMAC_LEN, data.length);
 // 복호화 전 HMAC 검증
 Mac mac = Mac.getInstance("HmacSHA256");
 mac.init(new SecretKeySpec(hmacKey, "HmacSHA256"));
 mac.update(iv); mac.update(ciphertext);
 byte[] calc = mac.doFinal();
 if (!MessageDigest.isEqual(hmac, calc)) return null; // 변조 탐지 후 복호화
 Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
 cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(encKey, "AES"), new IvParameterSpec(iv));
 return new String(cipher.doFinal(ciphertext), StandardCharsets.UTF_8);
 }
}
```

**※ ASP.NET**

```
MachineKey 적용 예시
<!-- web.config -->
<machineKey
 validationKey="AutoGenerate,IsolateApps"
 decryptionKey="AutoGenerate,IsolateApps"
 validation="HMACSHA256"
 decryption="AES" />
<!-- cookie.aspx.cs -->
// 쿠키 발급 (FormsAuthenticationTicket 활용)
var ticket = new FormsAuthenticationTicket(
 1, "username", DateTime.Now, DateTime.Now.AddMinutes(30), true, "role=admin");
string encrypted = FormsAuthentication.Encrypt(ticket); // 내부적으로 AES + HMAC 적용
var cookie = new HttpCookie("AuthCookie", encrypted) {
// 쿠키 보안 적용
 HttpOnly = true,
 Secure = true,
 SameSite = SameSiteMode.Lax
};
Response.Cookies.Add(cookie);
```

**※ PHP**

```
OpenSSL + HMAC 적용 예시
<?php
function setSecureCookie($name, $value, $encKey, $hmacKey) {
 $iv = random_bytes(16); // AES-256-CBC IV
 $ciphertext = openssl_encrypt($value, "AES-256-CBC", $encKey, OPENSSL_RAW_DATA, $iv);
 // HMAC 생성 (무결성 검증용)
 $hmac = hash_hmac('sha256', $ciphertext, $hmacKey, true);
 // payload = IV + HMAC + 암호문
 $payload = base64_encode($iv . $hmac . $ciphertext);
 setcookie($name, $payload, [
 'expires' => time() + 3600,
 'httponly' => true,
 'secure' => true,
 'samesite' => 'Lax'
 ]);
}
function getSecureCookie($name, $encKey, $hmacKey) {
 if (!isset($_COOKIE[$name])) return null;
 $data = base64_decode($_COOKIE[$name]);
 $iv = substr($data, 0, 16);
 $hmac = substr($data, 16, 32);
 $ciphertext = substr($data, 48);
 $calcHmac = hash_hmac('sha256', $ciphertext, $hmacKey, true);
 if (!hash_equals($hmac, $calcHmac)) {
 return null; // 무결성 검증 실패
 }
 return openssl_decrypt($ciphertext, "AES-256-CBC", $encKey, OPENSSL_RAW_DATA, $iv);
}
?>
```

---

## 19. 관리자 페이지 노출

### AE (상) 관리자 페이지 노출

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 유추 가능한 URL 또는 설계상의 오류로 인해 관리자 페이지 및 메뉴에 접근 가능 여부 점검 |
| 점검 목적 | 관리자 페이지의 URL을 추측하기 어렵게 설정하고, 웹 사이트 설계 오류를 수정하여 비인가자의 관리자 메뉴 접근을 방지하기 위함 |
| 보안 위험 | 웹 관리자의 권한이 노출될 경우, 웹 사이트 변조뿐만 아니라 취약성 정도에 따라 웹 애플리케이션 서버의 권한까지도 노출될 가능성이 있으므로 시스템 전체의 보안이 심각하게 위협받을 수 있음 |
| 참고 | ※ 소스코드 및 취약점 점검 필요 |
| **점검 대상 및 판단 기준** | |
| 대상 | 웹 애플리케이션 소스코드, 웹 애플리케이션 서버, 웹 방화벽 |
| 판단 기준 | **양호**: 유추하기 쉬운 URL로 관리자 페이지 접근이 불가능한 경우<br>**취약**: 유추하기 쉬운 URL로 관리자 페이지 접근 또는 계정 로그인이 가능한 경우 |
| 조치 방법 | 유추하기 어려운 이름(포트 번호 변경 포함)으로 관리자 페이지를 변경하여 비인가자가 접근할 수 없도록 하고, 근본적인 해결을 위해 지정된 IP만 관리자 페이지에 접근할 수 있도록 제한함. 단, 부득이하게 관리자 페이지를 외부에 노출해야 하는 경우, 관리자 페이지 로그인 시 2차 인증(OTP, VPN, 인증서 등)을 적용 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

```
- 점검 방법
Step 1) 유추하기 쉬운 URL, 포트 등 접속을 시도하여 관리자 페이지가 노출되는지 확인
[ 유추하기 쉬운 관리자 페이지 URL 접근 시도 ]

Step 2) 추측하기 쉬운 관리자 계정(admin, adm, administrator, manager 등) 및 비밀번호를 입력하여 로그인 가능한지 확인
[ 추측 가능한 관리자 계정 로그인 유무 확인 ]
```

```
- 조치 방법
1. 일반 사용자의 접근이 불필요한 관리자 로그인 페이지 주소를 유추하기 어려운 URL 및 포트로 변경
2. 관리자 페이지에 접근 가능한 IP를 지정하여 지정된 IP만 관리자 페이지에 접근 가능하도록 제한
3. 부득이하게 관리자 페이지를 외부에 노출해야 하는 경우, 관리자 페이지 로그인 시 2차 인증(OTP, VPN, 인증서 등)을 적용
4. 지정된 IP만 관리자 페이지에 접근 가능하도록 제한관리자 페이지의 하위 페이지 URL을 직접 입력하여 접근하지 못하도록 페이지 별 세션 검증 필요
```

---

## 20. 자동화 공격

### AU (상) 자동화 공격

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 웹 애플리케이션의 특정 프로세스(로그인 시도, 게시글 등록, SMS 발송 등)에 대한 반복적인 요청 시 통제 여부를 확인하여, 자동화 공격(봇 공격 등)을 방지 여부 점검 |
| 점검 목적 | 무차별 대입 공격 및 자동화 공격으로 인한 자원 고갈, 계정 탈취, 서비스 거부 상태를 방지하기 위함 |
| 보안 위험 | 웹 애플리케이션의 특정 프로세스에 대한 반복적인 요청을 통제하지 않을 경우, 무차별 대입 공격으로 사용자 계정을 탈취할 수 있으며, 자동화 공격을 통해 게시글 등록 또는 SMS 발송 요청을 반복하여 웹 애플리케이션 자원을 고갈시킬 수 있음 |
| 참고 | ※ 소스코드 및 취약점 점검 필요 |
| **점검 대상 및 판단 기준** | |
| 대상 | 웹 애플리케이션 소스코드, 웹 방화벽 |
| 판단 기준 | **양호**: 웹 애플리케이션의 특정 프로세스에 대한 반복적인 요청 시 통제가 적절한 경우<br>**취약**: 웹 애플리케이션의 특정 프로세스에 대한 반복적인 요청 시 통제가 미흡한 경우 |
| 조치 방법 | 웹 애플리케이션의 특정 프로세스에 대한 대량 사용을 통제하는 로직을 구현하고, 웹 방화벽의 룰셋을 설정하여 대량의 불특정 프로세스 요청을 차단 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

```
- 점검 방법
Step 1) 로그인 실패 일정 횟수 초과 시 반복적인 요청에 대한 통제가 미흡한지 확인
[ 자동화 공격을 통한 사용자 계정 로그인 유무 확인 ]

Step 2) 본인인증(계좌 인증, SMS인증 등)을 반복적으로 시도하여 반복적인 요청에 대한 통제가 미흡한지 확인
[ 자동화 공격을 통한 인증번호 탈취 유무 확인 ]
```

```
- 조치 방법
1. 로그인 시도, 게시글 등록, 본인인증(계좌 인증, SMS 발송 등)에 대한 사용자 요청에 대하여 횟수 제한을 설정 또는 *캡차 등 일회성 확인 로직을 구현해야 함
2. 자동화 공격을 시도하면 짧은 시간에 다량의 패킷이 전송되므로 이를 공격으로 감지하고 방어할 수 있는 IDS/IPS 시스템을 구축해야 함.
```

> ※ 캡차(CAPTCHA): 사람과 컴퓨터를 구분하기 위한 자동화된 테스트
> [ 캡차(CAPTCHA) 예시 ]

---

## 21. 불필요한 Method 악용

### WM (상) 불필요한 Method 악용

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | PUT, DELETE, TRACE 등 불필요한 HTTP 메소드의 악용 여부 확인 |
| 점검 목적 | 불필요한 HTTP 메소드(PUT, DELETE, TRACE 등) 요청을 제한하여 서버의 무단 접근 및 악의적인 행위(임의 파일 생성, 데이터 삭제 등)를 방지하기 위함 |
| 보안 위험 | PUT, DELETE, TRACE 등의 메소드가 활성화되어 있는 것만으로는 취약 여부를 판단하기 어려우나, 해당 메소드들이 악용될 경우, 조작된 Server Side Script 파일 업로드, 민감 데이터 삭제, 서버 정보 노출 등이 가능함 |
| 참고 | ※ Server Side Script: 웹에서 사용되는 스크립트 언어 중 서버 측에서 실행되는 스크립트<br>※ XST(Cross-Site Tracing): TRACE 메소드를 악용하여 httpOnly 등으로 보호된 세션 및 쿠키를 탈취할 수 있는 공격 기법 |
| **점검 대상 및 판단 기준** | |
| 대상 | 웹 애플리케이션 서버 |
| 판단 기준 | **양호**: 웹 애플리케이션에 불필요한 메소드(PUT, DELETE, TRACE, CONNECT 등)로 변조한 요청 패킷 전송 시 해당 메소드를 통하여 임의의 행위로부터 악용이 제한되는 경우<br>**취약**: 웹 애플리케이션에 불필요한 메소드(PUT, DELETE, TRACE, CONNECT 등)로 변조한 요청 패킷 전송 시 해당 메소드를 통하여 임의의 행위에 대한 악용이 가능한 경우 |
| 조치 방법 | WEB/WAS의 설정파일을 변경하여 불필요한 메소드의 사용을 제한 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

```
- 점검 방법
Step 1) PUT 메소드를 사용하여 악성 파일(Server Side Script, 악성 스크립트 등) 생성 시도
[ 프록시 도구를 이용한 임의 파일 생성 시도 ]

Step 2) 생성된 악성 파일을 이용하여 웹쉘(Webshell) 업로드, 크로스사이트 스크립팅 등의 공격 수행 가능
[ 생성 파일 실행 유무 확인 ]

Step 3) DELETE 메소드를 사용하여 서버에 저장된 임의의 데이터 삭제 가능
[ 프록시 도구를 이용한 임의 파일 삭제 시도 ]
```

```
- 조치 방법
1. PUT, DELETE 메소드를 이용해 파일 생성/삭제가 가능한 WebDAV(Web Distributed Authoring and Versioning) HTTP 확장 프로그램은 비활성화를 권장하며, 부득이하게 사용해야할 경우 망 분리 되어있는 내부망에서 적절한 인증 절차를 거쳐 운용
2. RESTful API 애플리케이션 상의 PUT, DELETE 메소드의 경우 기본적으로 취약하게 설계된 메소드가 아니며, POST 메소드를 통하여 구현하는 것과 동일하게 핵심 비즈니스 로직에 대한 시큐어 코딩을 구현
3. 불필요하게 활성화된 메소드는 비활성화하여 잠재적인 취약점의 최소화를 권장
(웹 서버 설정 파일 구성은 리눅스 OS 내에서도 종류 및 버전에 따라 차이가 있으므로 개발 환경에 맞게 조치)
```

**● Apache**

```
§ 명령어를 통한 dav 및 dav_fs 모듈 비활성화(WebDAV)
WebDAV 기능 비활성화
sudo a2dismod dav
sudo a2dismod dav_fs
§ apache2.conf 파일 수정을 통한 WebDAV 서비스 비활성화
PUT, DELETE 메소드 비활성화 (WebDAV 서비스 비활성화)
/etc/apache2/apache2.conf (예시 :Apache/2.4.52-ubuntu)
...
<Directory "/var/www/html">
Dav On #On으로 활성화 되어있을 경우 Off 또는 지시어 삭제로 비활성 조치
 Options Indexes FollowSymLinks
 AllowOverride None
 Require all granted
 <LimitExcept GET POST PUT DELETE OPTIONS>
#PUT, DELETE 메소드 사용이 허용되어 있을 경우,
#PUT, DELETE 부분을 삭제하여 해당 메소드 사용을 금지
 Order Allow,Deny
 Deny from all
 </LimitExcept>
</Directory>
...
§ Apache의 경우 TRACE 메소드가 기본적으로 활성화 되어있음
§ 데비안 계열은 /etc/apache2/apache2.conf 파일 내 TraceEnable Off 지시어를 추가하는 것으로 비활성화 조치
(2.4.X 버전부터 /etc/apache2/conf-available/security.conf 파일에서 TRACE 사용을 별도로 관리하며, 기본적으로 비활성화 되어있음)
TRACE 메소드 비활성화
# /etc/apache2/apache2.conf (예시 :Apache/2.2.8-ubuntu)
...
TraceEnable Off # 파일 내용 하단에 추가
...
§ 레드햇 계열의 경우 httpd.conf 파일 수정을 통해 TRACE 메소드 비활성화 조치
TRACE 메소드 비활성화
# /etc/httpd/conf/httpd.conf (예시: Apache/2.4.6-CentOS)
...
TraceEnable Off # 파일 내용 하단에 추가
...
§ mod_rewrite 모듈을 이용한 CONNECT 메소드 비활성화
CONNECT 메소드 비활성화
# /etc/apache2/sites-available/000-default.conf (예시: Apache/2.4.52-ubuntu)
...
<VirtualHost *:80>
 ...
 <IfModule mod_rewrite.c>
 RewriteEngine On
 RewriteCond %{REQUEST_METHOD} ^CONNECT #CONNECT 비활성화
 RewriteRule .* - [F]
 </IfModule>
 ...
</VirtualHost>
```

**● Tomcat**

```
§ WebDAV 서비스 활성화 시 PUT, DELETE 메소드를 이용하여 임의의 파일 생성 및 삭제 가능
PUT, DELETE 메소드 비활성화 (WebDAV 서비스 비활성화)
// 아래 코드를 제거하여 WebDAV 서비스 비활성화 또는 readonly 옵션을 true로 설정하여 쓰기 권한 제거
<servlet>
 <servlet-name>webdav</servlet-name>
 <servlet-class>org.apache.catalina.servlets.WebdavServlet</servlet-class>
 <init-param>
 <param-name>debug</param-name>
 <param-value>1</param-value>
 </init-param>
 <init-param>
 <param-name>listings</param-name>
 <param-value>false</param-value>
 </init-param>
 <init-param>
 <param-name>readonly</param-name>
 <param-value>true</param-value> // true로 설정하여 쓰기 권한 제거
 </init-param>
 <load-on-startup>1</load-on-startup>
</servlet>
§server.xml 설정 파일 내 allowTrace="true" 설정 값을 제거하여 TRACE 메소드 비활성화
TRACE 메소드 비활성화
//
<Connector port="8080" protocol="HTTP/1.1"
 connectionTimeout="20000"
 redirectPort="8443"
 maxParameterCount="1000"
 allowTrace="true" // 설정 값 제거
 />
§ Tomcat의 경우 설계 목적이 웹 애플리케이션 서버임에 따라, 프록시 서버에서 주로 사용되는 CONNECT 메소드를 기본적으로 지원하지 않음
```

**● Nginx**

```
§ WebDAV 서비스 활성화 시 PUT, DELETE 메소드를 이용하여 임의의 파일 생성 및 삭제 가능
§ /etc/nginx/sites-available/default 설정 파일 수정(환경 : nginx/1.18)
PUT, DELETE 메소드 비활성화 (WebDAV 서비스 비활성화)
...
location /dav/ {
...
dav_methods PUT DELETE MKCOL COPY MOVE; #dav_methods 지시어 부분 삭제
...
}
§ Nginx는 보안상의 이유로 0.5.17버전 이후로 TRACE 메소드를 항상 405 응답 코드로 거부하도록 패치되었으며, 기본적으로 포워드 프록시 기능을 지원하지 않으므로 CONNECT 메소드를 허용하지 않음
```

**● IIS 5.0 이하**

```
§ IIS 5.0의 경우 기본적으로 WebDAV 기능이 활성화 되어있어 PUT/DELETE 등의 메소드를 통하여 임의적인 파일 생성 삭제가 가능하므로 WebDAV 기능을 비활성화하거나 서비스 중인 애플리케이션의 디렉터리 내 '쓰기' 권한을 제거하여 PUT/DELETE를 통한 파일 생성 삭제 제한 가능
§ 레지스트리 편집기(Regedt32.exe) → HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W3SVC\Parameters → 편집 → 값 추가 → 값 이름: DisableWebDAV, 데이터형식: REG_DWORD, 데이터: 1 → IIS 재시작
[ 생성 파일 실행 유무 확인 ]
§ 웹 애플리케이션 홈 디렉터리 또는 가상 디렉터리 내 쓰기 권한 제거
[ 디렉터리 쓰기 권한 제거 ]
```

**● IIS 6.0 이상**

```
§ IIS 6.0 이상의 버전의 경우 IIS 웹 서버 설치 시 WebDAV 기능이 비활성화 되어있으며, OPTIONS/TRACE/GET/HEAD/POST 메소드가 기본적으로 활성화되어있음
§ TRACE 메소드 비활성화를 위하여 요청 필터링 → HTTP 동사 → 동사 거부 메뉴에 TRACE 메소드 추가
[ IIS 관리자 요청 필터링 메뉴 접근 ]
[ 동사 거부 설정 내 TRACE 메소드 추가 ]
```

---

# XI. 가상화 장비

## 1. 계정 관리 (계속)

### HV-03 (상) 가상화 장비 루트계정 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 별도의 관리자 계정을 생성하여 관리 여부 점검 |
| 점검 목적 | 허용한 호스트만 서비스를 사용하게 하여 비인가자의 무단 접근 시도를 예방하기 위함 |
| 보안 위험 | 루트 계정은 누구나 알 수 있는 계정이기 때문에 비인가자의 접속 시도 및 비밀번호 무차별 대입 공격에 노출될 위험이 존재함 |
| 참고 | ※ 무차별 대입 공격(Brute-force Attack): 특정한 암호를 풀기 위해 가능한 모든 값을 대입하는 것 |
| **점검 대상 및 판단 기준** | |
| 대상 | VMware ESXi, vCenter |
| 판단 기준 | **양호**: 별도의 관리자 계정을 생성하여 가상화 장비가 관리된 경우<br>**취약**: 루트 계정으로 가상화 장비가 관리된 경우 |
| 조치 방법 | 별도의 계정을 생성하여 관리자 권한을 부여하고 루트 계정의 권한은 제거하거나 비활성화 |
| 조치 시 영향 | 일반적인 경우 영향 없음 |

#### 점검 및 조치 사례

**● VMware ESXi**

```
Step 1) Web 콘솔 페이지 접속
https://<VMware ESXi IP>
Step 2) 호스트 > 작업 > 사용 권한으로 이동
Step 3) root 계정의 관리자 권한이 제거되고 별도의 관리자 권한이 존재하는지 확인
[ 별도의 관리자 권한 확인 ]
Step 4) root 계정 이외에 관리자 권한이 부여된 계정이 없는 경우 별도의 계정 생성
호스트 > 관리 > 보안 및 사용자 > 사용자 추가
[ 별도의 계정 생성 ]
Step 5) 별도로 생성한 계정에 관리자 권한 부여
호스트 > 작업 > 사용 권한 > 사용자 추가
[ 계정 관리자 권한 부여 ]
Step 6) root 계정의 관리자 권한 제거
[ root 계정 관리자 권한 제거 ]
```

---

### HV-04 (상) 가상화 장비 계정 권한 관리

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 공용 계정 등 불필요한 계정이 존재하는지 여부 점검 |
| 점검 목적 | 사용하지 않는 불필요한 계정을 관리함으로써 관리되지 않는 계정을 통한 비인가자의 무단 접속 또는 공격을 차단하기 위함 |
| 보안 위험 | 시스템에 등록되어 있는 불필요한 계정을 관리하지 않을 경우 비인가자의 무단 접근이 가능하며, 공용 계정 및 퇴사자 계정이 존재할 경우 해당 계정을 통한 침해사고 발생 시 사후 추적이 어려울 수 있는 위험이 존재함 |
| 참고 | ※ 1인 1계정 사용을 원칙으로 운영해야 하며, 공용 계정은 가급적 사용을 지양해야 함 |
| **점검 대상 및 판단 기준** | |
| 대상 | VMware ESXi, vCenter, XenServer, KVM, Nutanix |
| 판단 기준 | **양호**: 불필요한 공용 계정 및 퇴사자 계정이 존재하지 않은 경우<br>**취약**: 불필요한 공용 계정 및 퇴사자 계정이 존재하는 경우 |
| 조치 방법 | 불필요한 공용 계정 및 퇴사자 계정 제거 |
| 조치 시 영향 | 애플리케이션에서 사용하는 계정의 경우 삭제 시 서비스 가용성에 영향을 줄 수 있음 |

#### 점검 및 조치 사례

**● VMware ESXi**

```
Step 1) Web 콘솔 페이지 접속
https://<VMware ESXi IP>
Step 2) 호스트 > 관리 > 보안 및 사용자 > 사용자로 이동
[ 등록된 계정 확인 ]
Step 3) 불필요한 계정이 존재하는 경우 해당 계정 삭제
[ 불필요한 계정 제거 ]
```

**● XenServer, KVM**

```
Step 1) 호스트 접속
Step 2) 등록되어 있는 계정 확인
$ grep /bin/bash /etc/passwd | cut -f1 -d:
root
user1
Step 3) 불필요한 계정이 존재하는 경우 해당 계정 삭제
$ userdel -r <계정명>
```

**● Nutanix**

```
Step 1) Nutanix Web 콘솔 페이지 접속
https://<Nutanix 웹 콘솔 IP>:9440 접속
Step 2) Settings > Users an Roles > Local User Management를 선택하고 불필요한 계정이 존재하는 경우 해당 계정 삭제
```

---

### HV-05 (상) 가상화 장비 사용자 인증 강화

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 사용자 계정별 적절한 권한이 부여 여부 점검 |
| 점검 목적 | 가상화 시스템에 등록한 계정들에 용도별 권한을 부여함으로써 권한 없는 사용자의 설정 변경으로 인한 시스템 침입 경로 유출 위험을 줄이고 관리자 계정이 아닌 일반 계정이 공격자에게 탈취되었을 때 가상화 시스템을 장악하지 못하도록 하기 위함 |
| 보안 위험 | 가상화 시스템에 등록된 계정이 모두 관리자 권한으로 부여된 경우 권한 없는 사용자의 의도하지 않은 설정 변경을 통하여 공격자에게 가상화 시스템 침입 경로 제공 위험이 존재함 |
| 참고 | ※ 최고 관리자 권한은 최소한의 계정에만 부여 |
| **점검 대상 및 판단 기준** | |
| 대상 | VMware ESXi, vCenter, XenServer, KVM, Nutanix |
| 판단 기준 | **양호**: 계정별 불필요한 권한이 부여되지 않은 경우<br>**취약**: 계정별 불필요한 권한이 부여된 경우 |
| 조치 방법 | 불필요한 권한이 부여된 계정에 대한 권한 제거 |
| 조치 시 영향 | 일반적 경우 영향 없음 |

#### 점검 및 조치 사례

**● VMware ESXi**

```
Step 1) Web 콘솔 페이지 접속
https://<VMware ESXi IP>
Step 2) 호스트 > 작업 > 사용 권한으로 이동
Step 3) 등록된 계정별 사용 권한 확인
[ 등록된 계정별 사용 권한 확인 ]
Step 4) 불필요한 권한이 부여되어 있는 경우 해당 계정 선택
Step 5) 역할에 맞는 권한으로 변경
[ 계정 권한 변경 ]
```

**● XenServer**

```
[Active Directory에 가입되어 있지 않은 경우]
Step 1) 호스트에 접속
Step 2) bash 사용자 목록 확인
$ grep /bin/bash /etc/passwd | cut -f1 -d:
root
user1
Step 3) 불필요한 계정 제거
$ gpasswd -d user1 users

[Active Directory에 가입되어 있는 경우]
Step 4) 호스트에 접속
Step 5) 계정별 부여된 권한 확인
$ xe subject-list
uuid ( RO): bb6dd239-1fa9-a06b-a497-3be28b8dca44
subject-identifier ( RO): S-1-5-21-1539997073-1618981536-2562117463-2244
other-config (MRO): subject-name: example01\user_vm_admin; subject-upn: \
 user_vm_admin@XENDT.NET; subject-uid: 1823475908; subject-gid: 1823474177; \
 subject-sid: S-1-5-21-1539997073-1618981536-2562117463-2244; subject-gecos: \
 user_vm_admin; subject-displayname: user_vm_admin; subject-is-group: false; \
 subject-account-disabled: false; subject-account-expired: false; \
 subject-account-locked: false;subject-password-expired: false
Step 6) 부적절한 권한이 있는 경우 기존의 역할을 제거하고 새로운 역할을 추가
$ xe subject-role-remove uuid=<subject uuid> role-name=<role_name_to_remove>
$ xe subject-role-add uuid=<subject uuid > role-name=<role_name_to_add>
```

**● KVM**

```
Step 1) 호스트에 접속
Step 2) bash 계정 목록 확인
$ grep /bin/bash /etc/passwd | cut -f1 -d:
root
user1
Step 3) 불필요한 계정 제거
$ gpasswd -d user1 users
```

**● Nutanix**

```
Step 1) 웹 콘솔에 접속하여 등록된 사용자 계정 및 권한 확인
https://<Nutanix 웹 콘솔 IP>:9440 접속
Settings > Users an Roles > Local User Management 선택
Step 1) 불필요한 권한이 부여되어 있는 경우 해당 계정 선택
roles (SRO): vm-admin
… 이하 생략 …
Step 2) 불필요한 권한 제거
```

---

### HV-06 (상) 비밀번호 관리정책 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 로그인 계정에 대한 비밀번호 관리 정책 설정 여부 점검 |
| 점검 목적 | 로그인 계정 비밀번호에 대한 관리 정책 미흡으로 인한 계정 탈취를 방지하기 위함 |
| 보안 위험 | 가상화 시스템에 등록된 계정이 유추하기 쉬운 비밀번호 설정 등 미흡한 비밀번호 관리 정책이 적용되어 있으면 무차별 대입 공격을 통한 계정 탈취로 인한 공격자에게 가상화 시스템 침입 경로 제공 위험이 존재함 |
| 참고 | ※ 정책 기준: 영문 숫자 특수문자 2개 조합 시 10자리 이상, 3개 조합 시 8자리 이상, 비밀번호 변경 기간 90일 이하 |
| **점검 대상 및 판단 기준** | |
| 대상 | VMware ESXi, vCenter, XenServer, KVM, Nutanix |
| 판단 기준 | **양호**: 로그인 계정 비밀번호 관리 정책이 적용된 경우<br>**취약**: 로그인 계정 비밀번호 관리 정책이 적용되지 않은 경우 |
| 조치 방법 | 로그인 계정 비밀번호를 관리 정책에 맞게 설정 |
| 조치 시 영향 | 일반적 경우 영향 없음 |

#### 점검 및 조치 사례

**● VMware ESXi**

```
Step 1) WEB 콘솔 페이지 접속
https://<VMware ESXi IP>
Step 2) 호스트> 관리 > 시스템 > 고급 설정으로 이동
Step 3) Security.PasswordQualityControl 설정값 확인
[ Security.PasswordQualityControl 설정값 확인 ]
Step 4) min = N0, N1, N2, N3, N4 중 N3, N4의 값이 8 미만일 경우 [옵션 편집]을 클릭하여 아래와 같이 수정
[ 옵션 값 수정 ]
Step 5) Security.PasswordMaxDays 설정값 확인
[ 최대 암호 수명 값 확인 ]
Step 6) 90일 이하로 설정되어 있지 않은 경우 [옵션 편집]을 클릭하여 아래와 같이 수정
[ 최대 암호 수명 값 90 설정 ]
```

> ※ (예시) retry = M min = N0, N1, N2, N3, N4
> § M : 암호 변경 시, 조건을 불만족하는 암호 입력 시 다시 암호를 되묻는 횟수
> § N0 : 문자 종류(대문자, 소문자, 숫자, 특수문자) 중 한 가지만 사용해 구성된 암호에 허용되는 최소 암호 글자 수
> § N1 : 문자 종류(대문자, 소문자, 숫자, 특수문자) 중 두 가지를 사용해 구성된 암호에 허용되는 최소 비밀번호 길이
> § N2 : 암호 문구 사용 시, 허용되는 최소 비밀번호 길이
> § N3 : 문자 종류(대문자, 소문자, 숫자, 특수문자) 중 세 가지를 사용해 구성된 암호에 허용되는 최소 비밀번호 길이
> § N4 : 문자 종류(대문자, 소문자, 숫자, 특수문자) 중 네 가지를 사용해 구성된 암호에 허용되는 최소 비밀번호 길이
> disabled : 길이에 관계 없이 해당 종류의 암호를 사용하지 않음
> 암호의 첫 문자로 사용되는 대문자와 마지막 문자로 사용되는 숫자는 문자 종류의 수로 포함되지 않음

**● VMware vCenter**

```
Step 1) vSphere Client 접속 후, 다음 메뉴에 접근하여 확인(vSphere Client 버전에 따라, 메뉴 명칭은 달라질 수 있음)
Step 2) (vCenter6.5) "관리" > "Single Sign On" > "구성" > "Policies" > "암호 정책" > 비밀번호 정책 확인
Step 3) (vCenter8) "관리" > "Single Sign On" > "구성" > "로컬 계정" > "암호 정책" > 비밀번호 정책 확인
Step 4) 비밀번호 정책 설정 적용
```

**● XenServer**

```
Step 1) XenServer 접속 > Local Command Shell 실행
Step 2) 아래 명령어를 통해 비밀번호 설정 확인
# cat /etc/login.defs | grep –i "PASS_MAX_DAYS“
# cat /etc/login.defs | grep –i "PASS_MIN_DAYS“
# cat /etc/login.defs | grep -i "PASS_MIN_LEN"
Step 3) 아래 명령어 적용
# vi /etc/login.defs
PASS_MIN_LEN 8
PASS_MAX_DAYS 90
PASS_MIN_DAYS 7
```

**● KVM**

```
[RHEL 8 이후 버전 기반 리눅스]
Step 1) 아래 경로 설정 파일 확인
/etc/security/faillock.conf
/etc/security/pwquality.conf
Step 2) 비밀번호 정책 설정이 되어 있지 않으면 적용 설정
비밀번호 정책 설정 예시(UNIX 기반)
예시)password requisite pam_cracklib.so try_first_pass retry=3 minlen=8 lcredit=-1 ucredit=-1 dcredit=-1 ocredit=-1
```

**● Nutanix**

```
Step 1) Controller VM에 접속하여 비밀번호 최소 사용 기간 확인
sudo cat /etc/login.defs | grep –v "^#" | grep "PASS_MAX_DAYS"
Step 2) Controller VM에 접속하여 비밀번호 최소 사용 기간을 90일로 설정
sudo vi /srv/salt/security/CVM/pamCVM.sls
passmaxdays:
 file:
 - replace
 - name: /etc/login.defs
 - pattern: ‘^PASS_MAX_DAYS.*’
 - repl: ‘PASS_MAX_DAYS 90’
Step 3) 변경된 설정을 /etc/login.defs 파일에 적용
sudo salt-call state.sls security/CVM/pamCVM
Step 4) checkusergroupsCVM.sls 파일에서 admin, nutanix 계정의 비밀번호 최대 사용기간 설정 변경
sudo vi /srv/salt/security/CVM/checkusergroupsCVM.sls
nutanix:
 user:
 - present
 - shell: /bin/bash
 - home: /home/nutanix
 - uid: 1000
 - gid_from_name: True
 - mindays: 1
 - maxdays: 92
admin:
 user:
 - present
 - shell: /bin/bash
 - home: /home/admin
 - uid: 2000
 - gid_from_name: True
 - mindays: -1
 - maxdays: 92
Step 5) 변경한 설정 적용
sudo salt-call state.sls security/CVM/checkusergroupsCVM
Step 6) Controller VM에 접속하여 비밀번호 최소길이 설정 확인
cat /etc/login.defs | grep -v "^#" | grep "PASS_MIN_LEN“
Step 7) 비밀번호 최소 길이를 8자리 이상으로 변경
sudo vi /srv/salt/security/CVM/pamCVM.sls
passminlendef:
 file:
 - replace
 - name: /etc/login.defs
 - pattern: '^PASS_MIN_LEN.*'
 - repl: 'PASS_MIN_LEN 9'
 - onlyif:
Step 8) 변경한 설정 적용
sudo salt-call state.sls security/CVM/pamCVM
```

> ※ 영문, 숫자, 특수문자 2개 조합 시 10자리 이상, 3개 조합 시 8자리 이상 설정 권고
> ※ 비밀번호 최대 사용 기간을 90일(3개월) 이하로 설정할 것을 권고.
> ※ 비밀번호 최소 사용 기간을 7일(1주) 이상으로 설정할 것을 권고.

---

### HV-07 (상) 계정 잠금 임계값 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 로그인 계정에 대한 비밀번호 관리 정책 설정 여부 점검 |
| 점검 목적 | 잘못된 비밀번호 입력을 제한하지 않으면 무차별 대입 공격을 통한 계정 탈취 위협이 발생할 수 있어 실패 횟수 설정을 통해 가상화 장비 내부 침입을 방지하기 위함 |
| 보안 위험 | 잘못된 비밀번호 입력을 제한하지 않으면 무차별 대입 공격을 통한 계정 탈취로 공격자에게 가상화 시스템 침입 경로 제공 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | VMware ESXi, vCenter, KVM |
| 판단 기준 | **양호**: 로그인 시도 실패 횟수에 따른 계정 잠금 설정이 적용된 경우<br>**취약**: 로그인 시도 실패 횟수에 따른 계정 잠금 설정이 적용되지 않은 경우 |
| 조치 방법 | 로그인 시도 실패 횟수 제한 설정 |
| 조치 시 영향 | 일반적 경우 영향 없음 |

#### 점검 및 조치 사례

**● VMware ESXi**

```
Step 1) Web 콘솔 페이지 접속
https://<VMware ESXi IP>
Step 2) 관리 > 설정 > 시스템 > 고급 설정으로 이동
Step 3) Security.AccountLockFailures 설정이 5 이하로 설정되어 있는지 확인
[ 계정 잠금 실패 값 확인 ]
Step 4) 5 이하로 설정되어 있지 않은 경우 [옵션 편집]을 클릭하여 아래와 같이 수정
[ 계정 잠금 실패 값 설정 ]
Step 5) Security.AccountUnlockTime 설정이 600초(10분) 이상으로 설정되어 있는지 확인
[ 계정 잠금 해제 시간 확인 ]
Step 6) 600초(10분) 이상으로 설정되어 있지 않은 경우 [옵션 편집]을 클릭하여 아래와 같이 수정
[ 계정 잠금 해제 시간 설정 ]
```

> ※ 시스템이 관련 기능을 지원하지 않을 경우, 내부 정책 확인

**● VMware vCenter**

```
Step 1) vSphere Client 접속 후, 다음 메뉴에 접근하여 확인(vSphere Client 버전에 따라, 메뉴 명칭은 달라질 수 있음)
(vCenter6.5) "관리" > "Single Sign On" > "구성" > "Policies" > "잠금정책(Lockout Policy)" > 접속제한 관련 설정(실패한 최대 로그인 시도 횟수, 실패 시간 간격, 잠금 해제 시간)을 확인
(vCenter8) "관리" > "Single Sign On" > "구성" > "로컬 계정" > "잠금정책(Lockout Policy)" > 접속제한 관련 설정(실패한 최대 로그인 시도 횟수, 실패 시간 간격, 잠금 해제 시간)을 확인
```

**● KVM**

```
Step 1) 예시) RHEL 8 이후 버전 기반 리눅스
아래 경로 설정 파일 확인
/etc/security/faillock.conf
/etc/security/pwquality.conf
Step 2) 비밀번호 정책 설정이 되어있지 않으면 적용 설정
비밀번호 정책 설정 예시
# vi /etc/pam.d/system-auth
auth required /lib/security/pam_tally.so deny=5 unlock_time=120
no_magic_root
account required /lib/security/pam_tally.so no_magic_root reset
```

---

## 2. 시스템 서비스 관리

### HV-08 (중) 시스템 사용 주의사항 출력 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | 원격 로그인 시 시스템 사용 주의사항 출력 여부 점검 |
| 점검 목적 | 원격 로그인 시 시스템 사용 주의사항을 안내해 사용자가 시스템에 접근 시 보안 정책을 인식하도록 하기 위함 |
| 보안 위험 | 사용자가 시스템에 접근 시 보안 정책을 인식하지 못해 인위적인 공격 또는 데이터 유출 등의 보안 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | VMware ESXi, vCenter, XenServer, KVM, Nutanix |
| 판단 기준 | **양호**: 시스템 사용 주의사항이 출력된 경우<br>**취약**: 시스템 사용 주의사항 미출력 또는 표시 문구 내에 시스템 버전 정보가 노출된 경우 |
| 조치 방법 | 시스템 사용 주의사항 출력 설정 |
| 조치 시 영향 | 일반적 경우 해당 없음 |

#### 점검 및 조치 사례

**● VMware ESXi**

```
Step 1) Web 콘솔 페이지 접속
https://<VMware ESXi IP>
Step 2) 호스트 > 관리 > 시스템 > 고급 설정으로 이동
Step 3) Annotaions.WelcomeMessage 설정 값 확인
[ 시스템 사용 주의사항 출력 값 확인 ]
Step 4) 시스템 사용 주의사항 문구가 설정되어 있지 않은 경우 [옵션 편집]을 클릭하여 문구 입력
- 다음의 파일들에 메시지 설정 존재 여부 확인
1. /etc/motd 에 시스템 사용 주의사항 설정
2. /etc/issue 파일에 로그인 경고 메시지 설정
3. /etc/ssh/sshd_config 배너 값 설정
```

**● VMware vCenter**

```
Step 1) vSphere Client 접속 후, 다음 메뉴에 접근하여 확인(vSphere Client 버전에 따라, 메뉴 명칭은 달라질 수 있음)
(vCenter6.5) "관리" > "Single Sign On" > "구성" > "로그인 배너" > 로그인 배너 설정 여부를 확인
(vCenter8) "관리" > "Single Sign On" > "구성" > "로그인 메시지" > 로그인 배너 설정 여부를 확인
```

**● KVM**

```
Step 1) 배너 설정 여부 확인
# cat /etc/ssh/sshd_config | grep "Banner"
Step 2) /etc/sshd/sshd_config 파일에 배너 내용 삽입
# vi /etc/sshd/sshd_config
Banner /etc/issue.net
(예시) This system is for the use of authorized users only.
```

**● XenServer**

```
Step 1) 배너 설정 여부 확인
# cat /etc/ssh/sshd_config | grep "Banner"
Step 2) /etc/sshd/sshd_config 파일에 배너 내용 삽입
# vi /etc/sshd/sshd_config
Banner /etc/issue.net
(예시) This system is for the use of authorized users only.
```

**● Nutanix**

```
[ 관리 웹 콘솔 배너 설정 ]
Step 1) 웹 콘솔에 접속
https://<Nutanix 관리 Web IP>:9440 접속
Step 2) Settings > Apperance > Welcome Banner 메뉴 선택 > 배너 입력 > Enable Banner 체크 > Save 버튼 클릭

[ SSH 배너 설정 ]
■ SSH 설정 파일 직접 변경
Step 1) AHV, Controller VM에 각각 SSH 접속
Step 2) 배너 파일 내용 입력
sudo vi /etc/issue
Step 3) ssh 설정 파일에서 배너 파일 경로 설정
sudo vi /etc/ssh/sshd_config
Banner /etc/issue
Step 4) ssh 데몬 재시작
systemctl restart sshd
■ DoD 배너 설정
Step 1) Controller VM 접속하여 DoD 배너 비활성화
ncli cluster edit-hypervisor-security-params enable-banner=false
nutanix@cvm$ ncli cluster edit-cvm-security-params enable-banner=false
Step 2) AHV 접속하여 DoD 배너 파일 백업
[root@AHV-host ~]# cp -a /etc/puppet/modules/kvm/files/issue.DoD \
/etc/puppet/modules/kvm/files/issue.DoD.bak
Step 3) AHV의 DoD 배너 파일 수정
[root@AHV-host ~]# vi /etc/issue.DoD
Step 4) Controller VM의 DoD 배너 파일 백업
nutanix@cvm$ sudo cp -a /srv/salt/security/CVM/sshd/DODbanner \
/srv/salt/security/CVM/sshd/DODbannerbak
Step 5) Controller VM의 DoD 배너 파일 수정
nutanix@cvm$ sudo vi /srv/salt/security/CVM/sshd/DODbanner
Step 6) AHV 및 Controller VM의 DoD 배너 활성화
nutanix@cvm$ ncli cluster edit-hypervisor-security-params enable-banner=true
nutanix@cvm$ ncli cluster edit-cvm-security-params enable-banner=true
```

---

### HV-09 (중) NTP 및 시각 동기화 설정

| 구분 | 내용 |
| :--- | :--- |
| **개요** | |
| 점검 내용 | NTP 설정을 통한 시간 동기화 여부 점검 |
| 점검 목적 | 시스템이 NTP를 통한 시간 동기화를 적용해 가상화 장비 침해, 장애 등의 위협 발생 시 원활한 로그 분석 수행이 가능하도록 하기 위함 |
| 보안 위험 | 시스템이 NTP를 통한 시간 동기화가 되지 않을 경우 가상화 장비 침해, 장애 등의 위협 발생 시 로그 분석을 통한 침입 경로 파악이 어려워 초기 대응 불가 위험이 존재함 |
| 참고 | - |
| **점검 대상 및 판단 기준** | |
| 대상 | VMware ESXi, vCenter, XenServer, KVM, Nutanix |
| 판단 기준 | **양호**: NTP서버와 시간 동기화 설정을 적용한 경우<br>**취약**: NTP 서버와 시간 동기화 설정을 적용하지 않은 경우 |
| 조치 방법 | NTP 설정 및 시각 동기화 설정 |
| 조치 시 영향 | 일반적 경우 영향 없음 |

#### 점검 및 조치 사례

**● VMware ESXi**

```
Step 1) Web 콘솔 페이지 접속
https://<VMware ESXi IP>
Step 2) 호스트 > 관리 > 시스템 > 시간 및 날짜로 이동
Step 3) NTP 설정 확인
[ NTP 설정 확인 ]
Step 4) NTP 서버가 설정되어 있지 않은 경우, [NTP 설정 편집]을 클릭하여 NTP 서버 정보 입력
[ NTP 클라이언트 사용 설정 ]
```

**● VMware vCenter**

```
Step 1) vCenter Server 관리 페이지(https://<주소>:5480/) 접속 후, 다음 메뉴에 접근하여 확인(vCenter 버전에 따라, 메뉴 명칭은 달라질 수 있음)
# "시간" > "시간 동기화" > NTP 설정 여부를 확인
```

**● KVM**

```
Step 1) PHC 사용 여부 확인
Step 2) 사용하지 않으면 활성화 적용
# echo ptp_kvm > /etc/modules-load.d/ptp_kvm.conf
Step 3) /dev/ptp0 시계를 chrony 구성에 대한 참조로 추가 설정
# echo "refclock PHC /dev/ptp0 poll 2" >> /etc/chrony.conf
Step 4) chrony 데몬 다시 시작
# systemctl restart chronyd
```

**● XenServer**

```
Step 1) XenServer 접속 > Network and Management Interface > Network Time (NTP) > Provide NTP Servers Manually > 별도 NTP 서버 지정 설정 적용
```

**● Nutanix**

```
Step 1) 웹 콘솔에 접속
https://<Nutanix 웹 콘솔 IP:9440>
Step 2) Settings > NTP Servers 선택하여 NTP 서버가 설정되어 있는지 확인
Step 3) 설정되어 있지 않은 경우 NTP 서버를 입력하고 Add 버튼을 클릭
Step 4) Controller VM에 접속하여 타임존 설정
ncli cluster set-timezone timezone="Asia/Seoul“
Step 5) Controller VM에 접속하여 Nutanix 호스트 타임존 설정
hostssh "date; mv /etc/localtime /etc/localtime.bak; ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime; date“
```

> ※ Nutanix를 처음 설치하면 타임존이 UTC로 설정되어 있어 실제 시간과 차이가 발생

---

*(Part 13 끝. 이상으로 Web Application의 나머지 항목과 가상화 장비의 일부 항목이 완료되었습니다. 다음 Part 14에서는 가상화 장비의 나머지 항목(HV-10 ~ HV-25)과 클라우드 상세 항목(CA-01 ~ CA-19)이 이어집니다.)*