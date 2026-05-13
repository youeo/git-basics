# Workloads Plan

이 디렉터리는 **Cloud Series**와 **`Cloud/Workloads` 애플리케이션** 사이의 연결을 추적하고, **Workload별 기능 목록**을 한곳에서 정리한다.

## 목적

- 시리즈 문서는 각 시리즈 디렉터리에 있고, **실행 코드는 Workloads**에 있으므로, 둘 사이의 **매핑·상태**를 분리해 둔다.
- Workload가 늘어나도 **어느 시리즈 Lab·챕터와 대응하는지**를 표와 시리즈별 문서로 유지한다.

## 새 Workload를 계획할 때 (권장 흐름)

1. **먼저** `workloads/{name}.md` 초안을 둔다. (개요, 시리즈와의 관계, 기능·비기능, 설정 키, 구현/예정 구분은 가벼워도 됨.)
2. `matrix.md` 와 관련 `series/*.md` 를 같은 맥락으로 맞춘다.
3. 그다음 `Cloud/Workloads/{name}/` 코드·설정을 붙이거나 고치면서, **기능 표·문서를 앞서 갱신**해 나간다.

즉 **계획 문서가 앞서고, 구현이 따라오는** 쪽을 기본으로 한다. 에이전트·사람 모두 **같은 Workload를 기획·개선할 때** 이 파일을 진입점으로 삼는다. (Cursor용 **plan 전용 스킬**은 아직 두지 않는다. 여러 Workload에서 패턴이 겹치면 그때 공통 스킬을 검토한다.)

### 이미 코드가 있고 나중에 붙인 경우 (가져오기)

저장소에 **먼저** `gallery-spring-boot/` 같은 디렉터리와 코드가 있고, Workloads 쪽 **계획 문서는 나중에** 맞추는 경우도 있다. 이 땐 흐름이 거꾸로일 수 있다.

1. **코드·설정을 먼저** 살펴보고 (`이 프로젝트 코드 먼저 살펴봐` 등).
2. 그 결과를 바탕으로 **`workloads/{name}.md` 를 새로 쓰거나 채워** 시리즈·기능 표를 맞춘다.
3. 이후부터는 위의 **「계획 문서 ↔ 코드」** 동기화 규칙과 같다.

맨바닥 기획이 **유일한** 시작 방식은 아니다. 다만 **추적·개선을 이어갈 때**는 결국 `plan/workloads/{name}.md` 가 Single Source of Truth에 가깝게 맞춰지는 것이 좋다.

## 파일 구조

```text
.cursor/plan/
├── README.md                 ← 본 파일 (인덱스·갱신 규칙)
├── matrix.md                 ← Series × Workload 연결 요약표
├── series/                   ← 클라우드 시리즈별 연결·노트
│   ├── aws-fundamentals.md
│   ├── aws-iac-with-cloudformation.md
│   ├── terraform-core.md
│   ├── aws-infrastructure-architecture-and-design.md
│   ├── gcp-fundamentals.md
│   └── gcp-iac-with-terraform.md
└── workloads/                ← Workload별 기능·설정·시리즈 정렬
    └── gallery-spring-boot.md
```

## 갱신 규칙

1. **새 Workload 디렉터리**가 추가되면 `.cursor/plan/workloads/{name}.md` 를 만들고 `matrix.md` 와 해당 `series/*.md` 를 갱신한다.
2. **시리즈가 저장소에 추가**되면 `series/` 에 파일을 추가하고 `matrix.md` 에 행을 추가한다.
3. **기능 추가·제거**는 먼저 `.cursor/plan/workloads/{name}.md` 의 기능 표·구현 상태를 고친 뒤, 필요 시 시리즈 문서와 교차 확인한다.
4. **시리즈–Workload 관계나 범위 결정**이 바뀌면 본 디렉터리·`matrix.md`·시리즈 문서를 갱신한다. (git으로 추적.) `context_bridge.md` 는 **AGENTS·룰·스킬·운영 지시**가 바뀔 때만 `AGENTS.md` Memory Rule 을 따른다.

## 관련 문서

- Workloads 전역 규칙·**새 세션 플로우(Cold Start)**: `../../AGENTS.md` (`# Agent Session Flow`)
- 운영·규칙 맥락(선택): `../memory/context_bridge.md` — `AGENTS.md` `# Memory Rule`
- AWS Fundamentals 시리즈 기획( Gallery 단계 등): `../../../AWS Fundamentals/.cursor/plans/series-hierarchy.md`
