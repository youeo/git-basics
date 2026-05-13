# gallery-spring-boot — 코드 리뷰 어젠다 (트래킹)

**대상 경로:** `Cloud/Workloads/gallery-spring-boot`  
**문서 역할:** **검증·코드 리뷰·리팩터링**을 한 **코드 리뷰 어젠다**로 본다. 이슈·개선안·검증 결과·코드 동작에 대한 Q&A 결론을 **revision** 단위로 쌓고, **체크리스트**로 구현·검증 여부를 추적한다. 새로운 이슈가 나오면 **새 revision** 블록을 아래에 추가한다 (기존 revision 본문은 삭제하지 않는다).

---

## 사용 방법 (사람·에이전트 공통)

1. **구현 전:** 해당 revision의 `- [ ]` 항목을 기준으로 범위를 합의한다.
2. **구현 후:** 검증이 끝난 항목만 `- [x]` 로 바꾼다. 부분 완료는 `- [ ]` 옆에 짧은 메모.
3. **재검토:** 같은 코드를 다시 보며 새 이슈가 나오면 **Revision 이력**에 행을 추가하고, **`## Rev N — …`** 섹션을 새로 만들어 체크리스트를 적는다.
4. **에이전트 지시 예:** 「`.cursor/refactoring/workloads/gallery-spring-boot.md` Rev 2 기준으로 검증해」 또는 「Rev 3 추가해서 새 이슈만 정리해」
5. **에이전트 (코드 관련 대화):** 사용자가 **코드에 대해 묻거나**(동작·경로·설정), **검증을 요청하거나**, **리팩터링·Docker·빌드를 논하면** 그 세션의 결론·할 일을 **가능하면 이 문서의 최신 Rev에 반영**한다. 사용자가 **문서에 쓰지 말라고 한 경우**만 생략한다.

---

## Revision 이력

| Rev | 날짜 (KST) | 한 줄 요약 | 상태 |
|-----|------------|------------|------|
| 1 | 2026-03-26 | 초기 코드 리뷰 — 구조·안전·일관성 이슈 정리 | 열림 |
| 2 | 2026-03-26 | 리팩토링 구현안(제안만, 코드 미적용) — 적용 시 검증 항목 | 열림 |
| 3 | 2026-03-26 | Docker·README·이미지 경로·Dockerfile 최적화 제안(대화형 코드 리뷰) | 열림 |
| 4 | 2026-03-26 | Dockerfile 최적화 적용·컨테이너 로컬 저장소 고정 정책 | 열림 |

---

## Rev 1 — 초기 코드 리뷰 (이슈 목록)

> 출처: Spring MVC·트랜잭션·스토리지 관점의 정적 리뷰. **우선순위는 구현자가 조정.**

### 위험도·버그 소지

- [ ] **`ItemRepository` 생성자:** `DataSource.getConnection()`을 열고 닫지 않음 → 풀 누수 가능. (로그용 메타데이터면 제거하거나 try-with-resources / 별도 초기화 훅으로 대체.)
- [ ] **삭제 순서:** DB 삭제 후 스토리지 삭제 시, 스토리지 실패 시 불일치. (트랜잭션 커밋 후 스토리지 삭제, 보상 로직, 또는 정책 문서화.)
- [ ] **업로드 `null`:** `LocalImageStorage`가 실패 시 `null` 반환 가능 → `ItemService`가 그대로 저장하면 `url` null row 가능.
- [ ] **로컬 확장자:** `lastIndexOf('.')`가 `-1`일 때 `substring` 예외 가능.
- [ ] **S3 삭제:** `.com/` 문자열 파싱에 의존 → URL 형식이 바뀌면 깨짐. (키를 DB에 별도 저장·URI 파싱 등.)

### 품질·일관성

- [ ] **예외 응답:** Thymeleaf 앱인데 404/500 처리가 텍스트·JSON 혼재 가능. (`text/pain` 오타 등.)
- [ ] **`WebMvcConfigurer` + `@ConditionalOnProperty`:** 메서드 단 조건은 스프링 버전에 따라 헷갈릴 수 있음 → 전용 `@Configuration` 분리 검토.
- [ ] **설정 메시지:** `fs.path` 등 프로퍼티 키와 불일치 메시지 정리.
- [ ] **네이밍:** `unregistItem` → `unregisterItem` 등 표준 영어 철자.
- [ ] **I/O:** `getBytes()` 전부 로드, 스트림·`transferTo`·크기 검증 검토.
- [ ] **보안·HTTP:** 삭제가 `GET` → `POST` + (향후 Security 시) CSRF 검토.
- [ ] **테스트:** `contextLoads` 외 회귀 테스트 부재.

---

## Rev 2 — 리팩토링 구현안 (제안 전용, 미코드화)

> 아래는 **한 세션에서 논의·시도되었으나 저장소에는 반영하지 않은** 개선 방향이다. 적용할 때 Rev 1 항목과 매핑하여 체크하면 된다.

### Repository·Service

- [ ] `ItemRepository`: 생성자 DB 메타 로그 제거 또는 안전한 방식으로 대체.
- [ ] `ItemService`: `@Transactional`, `registerItem`에서 빈 파일·저장 실패 시 예외 처리.
- [ ] `ItemService.unregisterItem`: DB 커밋 후 `TransactionSynchronization.afterCommit`에서 스토리지 삭제.
- [ ] 예외: `ResponseStatusException` 등으로 사용자 메시지와 HTTP 상태 정렬.

### Controller·UI

- [ ] 삭제 라우트: `GET /{id}/delete` → `POST /{id}/delete`, Thymeleaf에서 form/button으로 변경.
- [ ] Flash attribute로 검증 오류 메시지 표시 (`index.html` 등).

### Storage

- [ ] `LocalImageStorage`: `Files`/`transferTo`, 확장자 안전 처리, 경로 traversal 방어.
- [ ] `S3ImageStorage`: 업로드는 스트림+사이즈, 삭제는 `URI`로 path→key 추출.

### 설정

- [ ] `ImageStorageConfig`에서 정적 리소스 핸들러만 별 설정 클래스(`@ConditionalOnProperty` 클래스 단위).

### 예외·에러 페이지

- [ ] `GlobalExceptionHandler`: Thymeleaf용 `error/404`, `error/error` (스택 미노출).
- [ ] `WhitelabelErrorController`: HTML/JSON 정책 통일.

### 테스트

- [ ] MockMvc 또는 슬라이스 테스트로 업로드·삭제·리다이렉트 최소 검증.

---

## Rev 3 — Docker·README·운영 경로·Dockerfile 최적화 (코드 리뷰 기록)

> 출처: 대화형 리뷰. **구현·문서 반영 여부는 체크박스로 추적.** 패치 초안은 **제안**이며, 적용 시 BuildKit·`dependency:go-offline` 동작을 로컬에서 한 번 확인할 것.

### 문서·검증

- [x] **`README.md`:** Docker 빌드(`--build-arg application=gallery` 필수)·`docker run` 조합 예시 1)~4) 추가, 이미지 태그 **`gallery:local`**, 위치는 **JAR 섹션 다음·라이선스 앞**.
- [x] **Docker 빌드 검증:** `--build-arg application=gallery` 있으면 성공, 없으면 실패(필수 인자 정책 확인).
- [x] **런타임 경로 정리:** `application=gallery` 일 때 **`WORKDIR /gallery`**, 로컬 스토리지 **`/gallery/uploads`**, prod 파일 로그 **`/gallery/gallery-logs/`** (`logback-prod`, 상대 경로 기준).

### Dockerfile 최적화 (Rev 4 에서 적용·체크)

- [x] **`# syntax=docker/dockerfile:1`** 및 BuildKit 전제.
- [x] **레이어 캐시:** `pom`/`mvnw`/`.mvn` → `dependency:go-offline` → `COPY src` → `package`.
- [x] **BuildKit:** `RUN --mount=type=cache,target=/root/.m2` (Maven 캐시).
- [x] **런타임:** `mkdir -p uploads` + `chown spring:spring` (`WORKDIR` = `/gallery` 일 때 **`/gallery/uploads`**).
- [x] **`.dockerignore`:** `.git`, IDE, `README.md` 등 제외(프로젝트 루트 파일 존재).

---

## Rev 4 — Dockerfile 최적화 적용·컨테이너 로컬 저장소 고정

> 구현 반영. **의도:** 컨테이너는 샌드박스로 보고, 호스트에서 **절대경로로 로컬 저장 위치를 바꾸는 설정**은 권한·마운트 혼란을 부르기 쉬워 **이미지 안에서는 상대 경로 `uploads` 로 고정**한다.

### Dockerfile·런타임

- [x] **빌드 최적화:** `dependency:go-offline`, `COPY src` 분리, `--mount=type=cache` for `~/.m2`.
- [x] **`APP_STORAGE_LOCAL_PATH` ENV 제거** (이전에는 `uploads` 를 ENV로 두던 방식에서 변경).
- [x] **로컬 경로 고정:** `ENTRYPOINT` 에서 `JarLauncher` **뒤에** `--app.storage.local.path=uploads` 전달. Spring 외부 설정 우선순위상 **명령줄 인자가 env·기본 yaml보다 우선**하므로, `-e APP_STORAGE_LOCAL_PATH=/절대/경로` 로 덮어쓰기 어렵게 한다(컨테이너 내부는 항상 `WORKDIR/uploads` → 예: `/gallery/uploads`).
- [x] **엔트리포인트 순서:** `java` 의 메인 클래스 **앞**에 `--app.storage...` 를 두면 JVM이 인식하지 못하므로, **`JarLauncher` 다음**에 애플리케이션 인자를 둔다.

### 후속(선택)

- [x] **README Docker 절:** 로컬 스토리지 고정·볼륨 마운트 예시 추가됨.
- [ ] **코드 레벨 잠금:** env를 완전히 무시하려면 `@Configuration` 에서 프로파일 `docker` 또는 `Environment` 검사 등 별도 설계(현재는 Spring 우선순위에 의존).

### (예약) Rev 5 — 사용자 검증 라운드

- [ ] (비어 있음)

---

## 메모

- 이 파일은 **내부 추적용**이다. 공개 `README.md`에 넣지 않는다 (`AGENTS.md` Core Principles §6).
- `.cursor/plan/workloads/gallery-spring-boot.md`의 **기능 표**와 충돌하면 기능 표·본 문서 중 하나를 갱신한다 (git으로 추적).
