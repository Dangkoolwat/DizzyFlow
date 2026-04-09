# DizzyFlow UX / Settings Scope Update

Last updated: 2026-04-05

이 문서는 DizzyFlow 프로토타입 문서에서 현재 버전에 포함할 범위와
차기 버전(2.0)으로 미루는 기능 범위를 명확히 구분하기 위한 기준 문서다.

이 문서의 목적은 다음과 같다.

- 현재 프로토타입 문서 범위를 흔들리지 않게 유지한다
- 에이전트와 개발자가 현재 구현 대상과 향후 논의 대상을 혼동하지 않게 한다
- 지금 필요한 workflow, settings, state transition 문서화에 집중하도록 돕는다

---

## 1. 현재 버전 문서화 범위

현재 버전에서는 다음 항목을 중심으로 문서를 정리한다.

    Home / Idle / Ready / Processing / Completed / Failed / Cancelled 흐름
    Sidebar / Workspace / Inspector의 역할
    Document 상태 표시와 재진입 UX
    Settings 화면 구조 및 카테고리
    General / VAD / Preprocessor / Models / About & License
    Safe Lock 전략
    WhisperKit의 Intel Mac 비활성화 규칙
    Inspector의 read-only Tips 형식 가이드
    WorkflowPhase 6단계 표준 방향
    footer-first workflow 구조
    BottomControlStack 기반의 Support Region / Action Row 구조

즉 현재 문서는
실제 프로토타입에서 반영 가능한 범위와
지금 당장 구현/설계 기준으로 필요한 부분까지만 다룬다.

---

## 2. 차기 버전(2.0)으로 미루는 기능

다음 기능은 이미 논의가 있었더라도
현재 버전 범위를 넘기 때문에 2.0에서 별도로 다룬다.

### 2.1 AI 편집 (GEM4)

AI 기반 편집 기능은 향후 DizzyFlow 2.0에서 다룬다.

현재 버전에서는 다음을 문서에 반영하지 않는다.

    GEM4 전용 Settings 카테고리
    프롬프트 편집 화면
    AI 편집 워크플로우
    AI 기반 후처리 / 문장 정제 / 스타일 변환
    AI 편집용 모델 관리

즉 GEM4는
향후 계획으로만 남기고
현재 버전 문서의 구현 범위에서는 제외한다.

### 2.2 고급 버전 관리

Document의 고급 버전 관리 기능도 2.0에서 별도 논의한다.

현재 버전에서는 다음을 정식 기능으로 문서화하지 않는다.

    다중 버전 비교
    버전 브랜치
    버전 히스토리 UI
    결과물 간 diff 보기
    편집 결과의 버전 파생 관리

즉 현재 버전은
문서 상태 중심의 terminal UX와
기본 결과 확인 UX까지만 다룬다.

---

## 3. 현재 버전의 문서화 원칙

현재 문서를 작성할 때는 다음 기준을 따른다.

### 포함할 것

    지금 프로토타입에서 실제로 구현 가능한 것
    UI/UX 흐름을 고정하는 데 필요한 것
    에이전트가 오해 없이 구현하기 위한 역할/상태 정의
    Settings / Workflow / Safe Lock 기준
    WorkflowPhase의 6단계 정렬 방향
    footer-first interaction 구조
    processing 중 protected interaction 규칙

### 제외할 것

    아직 구현 계획만 있고 구조가 고정되지 않은 것
    2.0 논의 대상 기능
    GEM4 세부 편집 UX
    고급 버전 관리 UX
    아직 확정되지 않은 실험적 기능

---

## 4. 문서에 남기는 방식

AI 편집(GEM4)와 고급 버전 관리는
현재 문서 본문에서 구현 범위처럼 다루지 않는다.

대신 다음과 같은 방식으로만 남긴다.

    향후 계획
    차기 버전(2.0) 논의 대상
    현재 버전 범위 제외

예시 문구:

    이 기능은 차기 버전(2.0)에서 별도 논의 및 설계를 진행한다.
    현재 프로토타입 범위에는 포함하지 않는다.

저신뢰 구간 시각 가이드 역시
현재 버전에서는 방향성 수준으로만 정리하고,
구체 구현은 추후 confidence 기준과 함께 다시 논의한다.

---

## 5. 실무적 의미

이 기준을 두는 이유는 다음과 같다.

    문서 범위가 흔들리지 않게 하기 위함
    에이전트가 아직 없는 기능을 현재 구현 대상으로 오해하지 않게 하기 위함
    지금 필요한 프로토타입 완성에 집중하기 위함
    현재 버전 논의와 2.0 논의를 분리하기 위함

즉 지금은
현재 흐름과 설정, 상태 전이, 모델 관리, 전처리 UX를 먼저 고정하고
AI 편집과 고급 버전 관리는 다음 단계에서 깊게 다루는 것이 맞다.

---

## 6. 요약

### 현재 버전

    workflow 기본 흐름
    terminal states
    settings 구조
    models / preprocessor / VAD / general
    safe lock
    inspector tips
    WorkflowPhase 6단계 방향 정리
    processing 하이라이트 방향
    preprocessor 옵션 구체화
    footer-first layout 구조
    BottomControlStack 기반 하단 지원 구조

### 2.0

    AI 편집 (GEM4)
    고급 버전 관리

이 기준을 바탕으로
README, AGENTS.md, 그리고 UX 관련 문서들을 현재 프로토타입 범위에 맞게 유지한다.
