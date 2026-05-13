# Skill: code-review-refactoring (Workloads)

특정 Workload에 대해 **리팩토링 문서 기반 현황 요약**과 **코드 리뷰(추가 제안)**를 수행한다. **기능·범위·시리즈 정렬**은 `.cursor/plan/workloads/{workload-name}.md`가 우선이고, **리팩토링 이슈·Rev·체크리스트**는 `.cursor/refactoring/workloads/{workload-name}.md`를 본다. 소스는 그다음에 읽어 **새 revision·체크리스트 항목**을 제안한다.

`session-restore` 와 겹칠 수 있는데, **Workload 이름 + 리팩토링/코드리뷰**가 함께 있으면 **본 스킬을 우선**한다. (전체 Workspace 요약만 필요하면 `session-restore` 를 따른다.)

---

## Trigger

아래에 **가깝게** 해당하면 실행한다 (표현은 달라도 된다).

### A. 현황·진행률

- `"{workload} 리팩토링 현황"`, `"리팩토링 어디까지"`, `"체크리스트 남은 것"`, `"Rev 몇까지"`
- **예:** `gallery-spring-boot 리팩토링 현황은?`

### B. 코드 리뷰·추가 제안

- `"{workload} 코드 리뷰"`, `"다시 봐줘"`, `"또 이슈 있나"`, `"변경분 기준으로"`
- **예:** `gallery-spring-boot 코드 리뷰해보자`

### B′. 검증·코드 동작 질문 (같은 어젠다)

- **검증:** `"Docker 빌드 검증해"`, `"이 경로 맞아?"`, `"실행해봐줘"` (코드·설정과 연결된 경우)
- **질문:** `"왜 이렇게 동작해?"`, `"로컬 스토리지 경로는 어디야?"`  
→ **`.cursor/refactoring/workloads/{workload}.md`** 에 요지를 남길지 판단할 때 **본 스킬·`refactoring-tracking` 룰**의 **문서 반영** 규칙을 따른다.

### C. 모호할 때

- Workload 디렉터리명(예: `gallery-spring-boot`)이 없으면 **하나 물어보거나**, 문맥상 단 하나의 Workload만 있으면 그것을 쓴다.

---

## Workload 이름 매핑

- **문서 경로:** `Cloud/Workloads/.cursor/refactoring/workloads/{workload-name}.md`
- `{workload-name}` 은 **저장소상 디렉터리 이름**과 같다 (예: `gallery-spring-boot`).
- 문서가 없으면: **생성할지 사용자에게 묻거나**, 코드 리뷰 결과만 대화로 주고 문서화는 **명시 요청 시**에 한다 (`AGENTS.md` · 본 스킬의 기본 원칙).

---

## Workflow

### Step 1. 문서 로드 (순서 고정)

1. **`.cursor/plan/workloads/{workload-name}.md`** — **필수로 먼저** 읽는다 (개요·기능 표·설정·시리즈 정렬). 없으면 `matrix.md`·Workload `README.md`로 보조하고, 부족하면 사용자에게 plan 초안 여부를 확인한다. (룰: `workloads-plan-first.mdc`)
2. **`.cursor/refactoring/workloads/{workload-name}.md`** — 있으면 **전체**를 읽는다 (Revision·체크리스트).

### Step 2-A. 「현황」요청일 때

- **Revision 이력 표**를 한 줄 요약한다.
- **가장 최신 Rev**의 체크리스트에서 **`- [ ]` / `- [x]` 개수** 또는 항목 나열(미완료 위주).
- **다음 액션** 1~2개 (사용자가 구현·검증하기 쉬운 순).

### Step 2-B. 「코드 리뷰」요청일 때

1. **문서에 이미 있는 이슈**는 중복하지 않는다 (짧게 언급만).
2. `Cloud/Workloads/{workload-name}/` 이하 **소스·설정**을 필요한 범위만 다시 읽는다 (주: `src/main`, `pom.xml`, `application*.yaml` 등).
3. 사용자가 **「방금 커밋」「이 브랜치만」** 등 범위를 주면 `git diff` / `git log` 로 **최근 변경**을 보강한다. 없으면 **현재 트리 기준**으로만 리뷰한다.
4. **새 이슈·개선안**을 우선순위(높음: 안전·버그 / 중간: 품질 / 낮음: 스타일)로 정리한다.
5. **문서 반영 (코드 리뷰 어젠다)**
   - **검증·코드 리뷰·리팩터링**은 같은 **코드 리뷰 어젠다**다. 사용자가 **코드에 대해 묻거나** 검증·개선을 논의하면, **새 결론·이슈·체크 항목**이 생겼을 때 **기본적으로** `.cursor/refactoring/workloads/{workload-name}.md`에 **현재 Rev에 보태거나 새 `## Rev N`** 으로 남긴다. **Revision 이력 표**도 함께 갱신한다.
   - **예외:** 사용자가 **문서에 쓰지 말라**고 했거나, Workload가 불명확할 때는 대화만 한다.
   - (과거 규칙) **「Rev에 올려」** 같은 명시가 없어도, 위 **어젠다 반영**이 기본이다.

### Step 3. 출력 형식 (대화)

- **현황:** 짧은 요약 + bullet.
- **코드 리뷰:** 기존 문서 항목 vs **신규**를 구분해 bullet (신규에만 `제안:` 등 표시 가능).
- 과도한 코드 인용은 피하고, 파일 경로·클래스명 정도로 충분하면 그렇게 한다.

### Step 4. 코드·설정 수정 금지 (기본)

- **사용자가 구현·패치·적용을 명시하지 않은 한** 소스·빌드 파일을 **수정하지 않는다**.
- 예외: **`.cursor/refactoring/workloads/{workload}.md`** 만 갱신하는 것(어젠다 반영)은 **구현이 아니라 추적**이므로, Step 2-B·위 **문서 반영** 규칙에 따라 허용된다.

### Step 5. Handoff

- `refactoring` 문서·코드 변경은 **git·문서**로 추적하면 된다. `context_bridge.md` append 는 **스킬·룰·AGENTS 운영 변경**이 있을 때만 `AGENTS.md` Memory Rule 을 따른다.

---

## Related

- **룰:** `.cursor/rules/refactoring-tracking.mdc`, `.cursor/rules/workloads-plan-first.mdc`
- **계획·기능 표(최우선):** `.cursor/plan/workloads/{workload-name}.md`
- **전체 세션 복원(다른 트리거):** `.cursor/skills/session-restore/SKILL.md`
- 상위 규칙: `Cloud/Workloads/AGENTS.md`
