# Skill: session-restore (Workloads)

세션 재시작(또는 컨텍스트 단절) 시, Workloads Workspace의 **마지막 결정·범위·연결 관계**를 빠르게 복원하고 현재 상태를 리포팅하기 위한 workflow다.

---

## Trigger

사용자 프롬프트에 다음이 포함되면 실행한다:

- "세션 복원", "상태 복원", "복구", "리포트", "현황", "컨텍스트 복원"
- "AGENTS.md 읽고 지금까지 작업 과정 리포팅"
- "새 세션", "이어서" (맥락 복구가 필요하다고 판단될 때)

---

## Workflow

### Step 1. 필수 문서 로드

Workspace 루트를 `Cloud/Workloads` 로 둔다.

- `AGENTS.md`
- `.cursor/memory/context_bridge.md`
- `.cursor/plan/matrix.md`
- (선택) 활성 Workload가 있으면 `.cursor/plan/workloads/{해당}.md`
- (선택) 리팩토링·리뷰 라운드가 있으면 `.cursor/refactoring/workloads/{해당}.md` (미완료 체크·최신 revision)

### Step 2. 상태 리포트 출력 (대화로만)

다음을 간결하게 요약한다:

- **역할**: 이 Workspace는 시리즈 문서가 아니라 **실행 코드·설정·`.cursor/plan` 기반 추적**이 중심임 (`AGENTS.md` 요약).
- **최근 memory** (`context_bridge.md`): 최근 5개 항목 또는 마지막 날짜 블록 위주 — **운영·스킬·룰** 위주이며 코드 이력은 없을 수 있다 (`AGENTS.md` Memory Rule).
- **Series ↔ Workload**: `matrix.md` 표의 현재 상태(primary / planned / —).
- **Workload 기능 요약**: `.cursor/plan/workloads/*.md`에 적힌 구현/계획 한 줄이 있으면 인용.
- **리팩토링 진행**: `.cursor/refactoring/workloads/*.md`가 있으면 열린 revision·미체크 항목 한 줄.
- **다음에 할 수 있는 작업** 1~2개 (memory·plan·사용자 목표와 무충돌하게).

### Step 3. 변경 금지

세션 복원 단계에서는 사용자의 명시적 요청이 없는 한 **파일을 수정하지 않는다**.

---

## Related

- `AGENTS.md` 의 `# Agent Session Flow` 가 상위 규칙이다. 충돌 시 `AGENTS.md` 를 따른다.
- Workload 이름과 **리팩토링 현황 / 코드 리뷰**가 함께 나오면 `session-restore` 대신 **`.cursor/skills/code-review-refactoring/SKILL.md`** 를 따른다 (`AGENTS.md` §4·§5).
