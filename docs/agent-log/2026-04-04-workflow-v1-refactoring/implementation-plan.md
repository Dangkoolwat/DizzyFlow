# 구현 계획

## 1. 개요
DizzyFlow의 워크플로우를 6단계 상태 머신으로 재구현하고, 사이드바를 플랫(Flat)하게 리팩토링하는 단계별 계획임.

## 2. 작업 단계
1. **Domain 레이어 업데이트**: `SubtitleDocument` 필드(segments, 메타 데이터 등) 추가 및 `SubtitleSegment` 모델 생성.
2. **App 레이어 리팩토링**: `WorkflowStore` 내 6단계 `WorkflowPhase` 전이 로직 및 `ProcessingStep` 피드백 구현.
3. **Sidebar 리팩토링**: `SidebarDestination` 전역 선언 및 `ContentView`의 리스트 표시 로직을 플랫 구조로 변경.
4. **Workspace 컴포넌트 개발**:
   - `DocumentDetailView`: 상태별 라우팅 컨테이너.
   - `ProcessingWorkspaceView`: 진행 바 + 실시간 결과 누적 스크롤.
   - `Completed/Failed/CancelledWorkspaceView`: 터미널 상태 전용 대기 화면.
5. **Inspector 레이어 고도화**: `SidebarDestination` 및 `WorkflowPhase`에 따른 컨텍스트 메타 정보 및 Tips! 가이드 구성.
6. **빌드 안정화**: macOS 14.6 호환성 문제 해결 및 UTIs 임포트 추가.

## 3. 영향 범위
- `WorkflowStore`: 앱의 핵심 상태 관리 로직 전면 개편.
- `ContentView`: 3패널 레이아웃 및 제어 흐름 수정.
- `SidebarSection`: 기존 이중 계층 구조를 플랫 구조로 대체.

## 4. 위험 요소
- **안정성**: 작업 처리 중 사이드바와 인벤토리 인터랙션이 불가능한 Safe Lock이 의도대로 동작하는지 검증 필요.
- **가독성**: 사이드바에 문서가 많아질 경우 리스트 표현 방식에 대한 고려 필요.
