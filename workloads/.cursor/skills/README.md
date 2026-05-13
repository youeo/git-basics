# Workloads `.cursor/skills`

Workload **코드·설정**을 다룰 때 선택적으로 따르는 워크플로 모음이다. 트리거와 절차는 각 `SKILL.md`에 적는다.

**공통 전제:** 특정 `{workload-name}`을 대상으로 하면 **먼저** `.cursor/plan/workloads/{workload-name}.md`를 읽는다 (`AGENTS.md`, `workloads-plan-first` 룰).

**Memory (`context_bridge.md`):** 스킬·룰·`AGENTS` 운영 변경 시에만 append. 코드·plan·refactoring 일상 갱신은 git으로 충분 (`AGENTS.md` Memory Rule).

| 스킬 | 역할 |
|------|------|
| [session-restore](session-restore/SKILL.md) | 세션 복원·전체 Workloads 맥락 리포트 |
| [code-review-refactoring](code-review-refactoring/SKILL.md) | 리팩토링 문서 현황, 코드 리뷰·Rev 제안 |

추가 예정(이름 가칭):

- **plan / 기획 전용 스킬** — 아직 없음. `plan/workloads/{name}.md` 를 어떻게 깔고 이어갈지는 **`.cursor/plan/README.md` 의 「새 Workload를 계획할 때」** 와 수동 워크플로로 둔다. 여러 Workload에서 **공통 절차**가 보이면 그때 스킬 초안을 검토한다.
- 기능 개선/아이디어 반영, 배포·프로파일 점검 등 — 필요해지면 본 표와 `AGENTS.md` §5 류에 연결한다.
