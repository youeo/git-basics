# `.cursor/refactoring`

Workload **애플리케이션 코드**에 대한 **코드 리뷰 어젠다**를 **revision + 체크리스트**로 쌓는 내부 전용 디렉터리다. 여기서 말하는 어젠다에는 **정적 코드 리뷰**, **리팩터링 논의**, **빌드·Docker·실행 등 검증**, **코드 동작·경로에 대한 Q&A 결론**이 모두 포함된다.

- 시리즈·기능 매핑은 `.cursor/plan/` 을 본다.
- 본 디렉터리는 **구현 검증·후속 리뷰 라운드**용이며, 공개 README에는 넣지 않는다.

**파일 규칙:** `workloads/{workload-directory-name}.md` (예: `gallery-spring-boot.md`).

**워크플로:** 작업 전 `.cursor/plan/workloads/{name}.md` 우선 (`workloads-plan-first` 룰). 스킬·룰은 `.cursor/skills/README.md` · `refactoring-tracking.mdc` 참고.
