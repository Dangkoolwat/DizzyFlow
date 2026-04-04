# 해결 제안

## 1. 개요
DizzyFlow의 상태 머신을 6단계(`idle`, `ready`, `processing`, `completed`, `failed`, `cancelled`)로 확장하고, 사이드바를 플랫(Flat)하게 리팩토링하여 워크플로우 가독성과 조작 편의성을 극대화함.

## 2. 해결 방안
- **상태 머신 확장**: `WorkflowStore` 내 `WorkflowPhase`를 6단계로 재정의하고, `ProcessingStep`(5단계: 오디오 분석 -> VAD -> 전사 -> SRT -> FCPXML)을 추가하여 실시간 진행 상태를 상세화함.
- **사이드바 플랫 리팩토링**: `SidebarDestination`을 도입하여 Home, 생성된 문서 리스트, Settings를 단일 레벨에서 탐색 가능하도록 변경. `DocumentsWorkspaceView`는 자체 리스트 없이 개별 문서의 상태 라우팅만 담당하도록 전환.
- **Safe Lock 구현**: `isProcessing` 플래그를 활용하여 작업 처리 중 사이드바와 인스펙터의 인터랙션을 `.disabled()` 및 오퍼시티 조절로 차단.
- **Ready 상태 시각화**: `PendingFileInfo` 모델을 통해 파일명 기반의 Mock 메타데이터(크기, 재생 시간, 포맷, 코덱)를 생성하고 Home 화면 및 인스펙터에서 시각적 확신감을 제공.
- **macOS 14.6 호환성 확보**: macOS 15+ 전용 `onScrollPhaseChange` API를 대체할 수동 자동 스크롤 제어 버튼(`scrollControlButton`)을 구현하고 `.foregroundStyle(.accent)`를 `Color.accentColor`로 수정.

## 3. 대안 및 비교
- **대안**: 기존 Documents 섹션 내부 리스트 유지
- **장점**: UI 계층 구조 명확
- **단점**: 작업 전환 시 뎁스가 깊어지고, 여러 작업의 진행 상황을 동시에 모니터링하기 어려움.
- **결정**: 프로젝트 지침(`vision.md`)에 따라 "문서 자체가 사이드바에 나타나는" 플랫 구조를 채택.
