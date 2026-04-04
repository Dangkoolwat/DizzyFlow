# DizzyFlow

## Revision History
| Date | Contributor | Summary |
| --- | --- | --- |
| 2026-04-01 | Sanghyouk Jin | README/AGENT 문서를 Apple 기준 한국어 주석, 테스트, App Store 준비, 에이전트 안내 중심으로 확대 |
| 2026-04-04 | Sanghyouk Jin / OpenAI ChatGPT | UX/UI 기준 문서 경로, Settings 구조, 현재 버전과 2.0 범위 구분을 반영해 README 갱신 |

DizzyFlow는 Final Cut Pro 같은 도구를 사용하는 크리에이터를 위한 workflow-first subtitle platform이다.

이 프로젝트는 단순한 전사 도구가 아니다.  
사용자의 작업 흐름을 보호하고, 작업 속도를 높이기 위한 시스템이다.

---

## 🚀 Current Status

초기 프로토타입 (v0.1)

- NavigationSplitView 레이아웃
- 상태 전이를 갖춘 WorkflowStore
- SubtitleDocument 코어 모델
- Mock workflow
- 읽기 전용 Inspector panel
- Settings UX 구조 정의 완료
- 모델 관리 UX 구조 정의 완료

### 현재 워크플로우 단계

    Idle
    Ready
    Processing
    Completed
    Failed
    Cancelled

---

## 🧠 Philosophy

- 기술은 엔진룸에 숨긴다
- 사용자는 모델이 아니라 작업 목적을 선택한다
- 기능 확장보다 workflow 안정성을 우선한다
- 모든 데이터는 SubtitleDocument를 중심으로 흐른다
- Review는 optional이다
- cancellation과 typed error는 초반부터 설계한다

---

## 🏗 Architecture Overview

    Sidebar → 사용자 진입 / 내비게이션
    Workspace → 메인 작업 영역
    Inspector → tips와 상태 안내를 포함한 읽기 전용 컨텍스트 패널

핵심 구성요소:

- WorkflowStore (상태 전이의 진입점)
- SubtitleDocument (정규화된 데이터 모델)
- SwiftUI + Observation (@Observable)

---

## 📁 Project Structure

    App
    Domain
    Features
    Infrastructure
    Shared
    docs/ux
    docs/ui

---

## 📚 UX / UI Design Notes

다음 문서는 현재 DizzyFlow 프로토타입의 UX/UI 기준 문서다.

    docs/ux/dizzyflow_ux_idle_ready.md
    docs/ux/dizzyflow_ux_processing_terminal_states.md
    docs/ui/dizzyflow_settings_ux.md
    docs/ux/dizzyflow_scope_current_vs_v2.md

문서 목적:

- Idle / Ready / Processing / Terminal States 흐름 고정
- Sidebar / Workspace / Inspector 역할 정의
- Settings 화면 구조와 Safe Lock 규칙 정리
- 현재 버전 범위와 2.0 논의 범위 분리

현재 버전에서 다루는 범위:

- Home workflow
- Processing / Completed / Failed / Cancelled UX
- Settings
    - General
    - VAD
    - Preprocessor
    - Models
    - About & License
- Inspector Tips 가이드
- WhisperKit Intel Mac 비활성화 규칙

차기 버전(2.0)에서 별도 논의할 범위:

- AI 편집 (GEM4)
- 고급 버전 관리

---

## 🧭 Workflow Summary

### Home / Idle

- 앱 시작 시 기본 진입 위치
- 상단 설정 바에서 주요 설정을 미리 조정 가능
- Sidebar에는 기존 Document 목록 표시
- 새 작업은 아직 시작되지 않은 상태

### Ready

- 파일이 선택된 상태
- 시작 전 검토 단계
- 시작 버튼을 눌러야 Document 생성 및 Processing 진입

### Processing

- Safe Lock 적용
- 취소(Job Cancel)만 활성화
- 실시간 결과는 누적 스크롤 방식으로 표시
- 상단 영역은 설정 UI가 아니라 상태 메시지 영역으로 전환

### Terminal States

- Completed
- Failed
- Cancelled

Completed는 결과 사용에 집중하고,  
Failed는 실패 지점 안내에 집중하며,  
Cancelled는 Restart를 통한 rerun을 허용한다.

---

## ⚙️ Settings Summary

Settings는 단순 옵션 창이 아니라
DizzyFlow의 실행 환경과 엔진 자산을 관리하는 운영 워크스페이스다.

기본 구조:

    Sidebar | Settings Main | Inspector

Settings Main 내부 구조:

    좌측 카테고리 | 우측 세부 설정

현재 카테고리:

- General
- VAD
- Preprocessor
- Models
- About & License

핵심 규칙:

- Inspector는 Tips! 형식의 read-only 가이드 패널
- General / VAD / Preprocessor는 저장 버튼 사용
- Models는 카드 기반 직접 액션 구조
- WhisperKit은 Intel Mac에서 전체 비활성화
- 무거운 작업에는 Settings Safe Lock 적용 가능

---

## 한국어 주석 & 스타일 가이드

- 모든 소스 주석은 한국어로 작성하며, Apple Human Interface Guidelines 및 Swift API Design Guidelines의 톤/명명 규칙을 이어받습니다.
- 수정 이력(문서, 리팩토링, API 등)은 상단 Revision History 또는 AGENT.md의 changelog 블록에 간단히 정리해서 기록합니다.
- 주석은 커밋 메시지와 함께 보존되며, 중복된 설명을 줄이기 위해 View/Store/Domain 레이어별로 주석 기준을 통일합니다.

---

## ⚠️ What is NOT included (yet)

- 실제 STT 엔진 통합
- 실제 import/export 파이프라인
- 전체 편집 UI
- AI 편집 워크플로우 (GEM4)
- 고급 버전 관리
- 프로덕션 수준의 최종 모델 자산 파이프라인

---

## 🛣 Roadmap (short)

- Home workflow entry
- SubtitleSegment model
- Result rendering
- File input pipeline
- Engine abstraction
- Settings implementation
- Model management implementation

---

## 🧪 Testing

- `xcodebuild test -scheme DizzyFlow` (macOS 대상)으로 현재 단위/UI 테스트를 실행합니다.
- `DizzyFlowTests`와 `DizzyFlowUITests` 아래의 타겟이 모두 성공해야 머지 전 상태에서 문서화된 테스트 요구가 충족됩니다.
- 실패가 발생하면 로그를 붙여서 수정 이력 및 문제 원인을 설명하고, 재실행 기준(시스템 버전, Xcode 버전 등)을 명시합니다.

---

## 📦 macOS 앱 준비 상태

- Apple App Store 심사 기준을 충족하도록 샌드박스, 코드 서명, 프라이버시 노티스, 접근성, 적절한 권한(entitlements)을 항상 점검합니다.
- Human Interface Guidelines(HIG)과 접근성/VoiceOver 체크리스트를 따라 UI 가독성과 키보드/포커스 흐름을 확보합니다.
- 앱에서 파일 접근이 필요한 경우 사용자 설명과 권한 요청을 명확하게 문서화합니다.
- 애플 리뷰에 영향을 줄 수 있는 개인정보(마이크, 카메라)나 네트워크 사용은 별도 문단에 명시하고, 로그에 상용 API 키를 남기지 않습니다.

---

## 🤝 Working with the agent

- Apple 개발이 처음이라면, 에이전트에게 HIG, Swift API Design, sandboxing, App Store Review Guideline 요약을 요청해 기준을 정리하고 붙여넣어 주세요.
- 새로운 구조나 라이브러리를 제안할 때는 애플 플랫폼 호환성(메모리 footprint, sandbox, entitlements) 검토를 먼저 부탁합니다.
- UI/UX 관련 구현 전에는 아래 문서를 먼저 확인하도록 안내하세요.

    docs/ux/dizzyflow_ux_idle_ready.md
    docs/ux/dizzyflow_ux_processing_terminal_states.md
    docs/ui/dizzyflow_settings_ux.md
    docs/ux/dizzyflow_scope_current_vs_v2.md

---

## 👤 Author

Sanghyouk Jin

---

