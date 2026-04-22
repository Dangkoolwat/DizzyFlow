# 🤖 DizzyFlow Agent Knowledge Base (AGENTS.md)

이 문서는 DizzyFlow 프로젝트에 참여하는 모든 AI 에이전트가 준수해야 할 엄격한 운영 절차, 아키텍처 원칙 및 기술 표준을 정의합니다. 에이전트는 작업을 시작하기 전 이 문서를 반드시 숙지해야 합니다.

---

## ⚡ 퀵 운영 규칙 (Quick Operating Rules)

### 1. 지시 우선순위 (Instruction Priority)
충돌 발생 시 다음 순서를 따르십시오:
1. 사용자의 명시적 지시 (Chat)
2. 본 `AGENTS.md`
3. 프로젝트 문서 (`docs/` 하위)
4. 소스 코드 및 테스트 코드
5. 에이전트의 일반적인 기본 지식

### 2. 작업 분류 및 승인 절차
에이전트는 모든 요청을 먼저 다음 두 범주 중 하나로 분류한 뒤 대응합니다.

- **Trivial (사소한 작업 - Fast Track)**: 
  - 단순 오타 수정, 주석 업데이트, 사용자용 정적 문구 수정, 미세한 레이아웃(Padding/Spacing) 조정, Dead Code 제거.
  - **절차**: 별도의 제안 없이 즉시 구현 가능.
- **Non-trivial (사소하지 않은 작업 - Standard)**: 
  - `WorkflowPhase` 상태 전이 수정, `WorkflowStore` 로직 변경, `SubtitleDocument` 데이터 처리, 새로운 UI 컴포넌트 추가, macOS 호환성 관련 수정, 아키텍처/폴더 구조 변경.
  - **절차**: 요청 분석 후 2~3가지 접근 방식 제안 -> **사용자의 명시적 승인(예: "Go", "진행") 확인 후 구현 시작.**

### 3. 긴급 수정 규정 (Emergency Fast Track)
다음 상황에 한해 제안 단계 없이 즉시 수정을 허용합니다.
- 빌드 실패 복구, 앱 실행 불가 크래시 복구, 잘못 커밋된 민감 정보 제거.
- **단, 변경 범위를 최소화하고 사후에 원인과 검증 결과를 즉시 보고해야 합니다.**

---

## 🤝 협업 및 승인 프로세스 (Mandatory Workflow)

### 1단계: 분석 및 제안 (Inquiry & Proposal)
- **지식 그래프(docs/graphify)**를 먼저 확인하여 수정 대상의 의존 관계를 파악합니다.
- 문제의 핵심과 제약 사항을 분석하여 2~3가지 기술적 대안을 제시합니다.
- **승인 전에는 구현을 시작하지 않습니다.**

### 2단계: 구현 (Implementation)
- 승인된 범위 내에서만 구현하며, 불필요한 리팩토링이나 기능 확장을 금지합니다.
- **Footer-First UI** 및 **SSOT(WorkflowStore)** 원칙을 엄격히 준수합니다.

### 3단계: 테스트 및 리포팅 (Verification & Reporting)
- **[MANDATORY] 모든 코드 수정 완료 후, 반드시 프로젝트 전체 빌드(`xcodebuild` 등)를 수행하여 문법 오류 및 사이드 이펙트 유무를 확인해야 합니다.**
- **필수 검증 체크리스트**:
  - [ ] **빌드(Compilation) 및 앱 실행 성공 여부 (필수)**
  - [ ] `WorkflowStore`의 상태 전이 안정성 (Idle -> Ready -> Processing 등)
  - [ ] Footer 기반 컨트롤(`BottomControlStack`)의 정상 작동 여부
  - [ ] macOS 14/15 호환성 및 레이아웃 유지 여부
- **결과 보고는 "Required Output Format"을 엄격히 따릅니다.**

---

## 📚 프로젝트 지식 베이스 (Project Knowledge Base)

이 프로젝트는 `graphify`를 통해 생성된 구조적 지식 그래프를 포함하고 있습니다.

### 1. 지식 그래프 자원 (Knowledge Graph Resources)
- **리포트**: [docs/graphify/GRAPH_REPORT.md](file:///Users/sanghyoukjin/XcodeProjects/DizzyFlow/docs/graphify/GRAPH_REPORT.md)
- **핵심 추상화 노드 (God Nodes)**: 다음 노드 수정 시 특히 주의하십시오:
  - `WorkflowStore`, `InspectorPanelView`, `WorkflowPhase`, `SettingsCategory`, `ProcessingStep`
- **시각화**: [docs/graphify/graph.html](file:///Users/sanghyoukjin/XcodeProjects/DizzyFlow/docs/graphify/graph.html)

### 2. 에이전트 준수 사항
- **사전 분석 필수**: Non-trivial 작업 전, 반드시 `GRAPH_REPORT.md`를 읽고 의존 관계를 파악하십시오.
- **최신화**: 코드 구조에 중대한 변화가 생겼을 경우, `updateGraphify` 명령을 실행하십시오.

---

## 🧠 핵심 제품 철학 및 원칙 (Core Principles)

- **Workflow Stability First**: 기능 확장보다 워크플로우 안정성이 우선입니다.
- **Intent over Features**: 사용자는 모델이 아닌 의도를 선택합니다.
- **SSOT**: `WorkflowStore`가 상태의 유일한 원천입니다. 상태 전이는 View가 아닌 Store에서 발생해야 합니다.
- **Footer-First UI**: 주요 컨트롤은 항상 하단(`BottomControlStack`)에 위치합니다. 상단 툴바에 주요 액션을 배치하지 마십시오.
- **Interaction Safety**: `isProcessing` 상태에서는 사이드바 및 인스펙터 조작이 제한되어야 합니다.

---

## 📁 레이어 책임 및 구조 (Architecture)

- **App**: 앱 수준 상태 흐름 및 Store 진입점 소유.
- **Domain**: `SubtitleDocument` 등 순수 모델 및 도메인 로직.
- **Features**: SwiftUI 화면, 패널, 워크플로우 전용 프리젠테이션 로직.
- **Infrastructure**: 서비스, 엔진(Sherpa, Whisper), 어댑터 등 외부 연동 경계.
- **Shared**: 재사용 가능한 유틸리티, `CapsuleActionButton`, `UpwardMenuPicker` 등 공용 컴포넌트.

---

## 🧭 macOS 호환성 및 로컬라이징

- **MacOS Baseline**: macOS 14/15를 주 검증 대상으로 하되, macOS 13 하위 호환성을 고려한 기존 코드를 존중하십시오.
- **Localization**: KR/EN 리소스를 항상 동기화하고, `docs/ux/terms.md`의 용어 정의를 준수하십시오.

---

## 🚫 금지 조항 (Forbidden Actions)

- 명시적 지시 없는 파일명/폴더 구조 변경.
- 승인 없이 새로운 프레임워크(SwiftData 등) 도입.
- `WorkflowStore`를 우회하는 상태 관리.
- 사용자 승인 없는 `commit` 및 `push`.

---

## 📤 출력 형식 (Required Output Format)

작업 완료 후 다음 구조로 응답하십시오:
1. **Files Changed**: 변경된 파일 목록
2. **Reasoning**: 채택한 접근 방식의 이유
3. **Alternatives**: 고려했던 대안들
4. **Full Code Changes**: 전체 코드 변경 사항 (Diff)
5. **Validation Results**: 빌드/테스트/셀프 체크 결과
6. **Intentionally Omitted**: 의도적으로 구현하지 않은 사항
7. **Risks**: 향후 리스크 또는 후속 조치

---
*Last Updated: 2026-04-22 (by Antigravity - Optimized for Agent Clarity)*
