# Problem Analysis

## Problem Definition
DizzyFlow V1.0의 상단 툴바에 설정 피커(FPS, 언어 등)와 프로세싱 상태 메시지가 혼재되어 있어 공간 활용이 비효율적이고, 각 워크스페이스 뷰(Processing, Completed, Failed, Cancelled)의 하단 액션 영역이 서로 다른 구조로 파편화되어 있었음.

## Root Cause
- 상단 툴바의 `.principal` 영역에 설정과 메시지를 동시 관리하면서 macOS 네이티브 툴바 레이아웃과 충돌 발생
- 각 워크스페이스 뷰가 독립적으로 하단 액션 영역을 구현하여 UI 일관성 부재
- Tahoe/Sequoia 간 시각적 구분감(레이어 엣지) 미확보

## Constraints
- 모든 워크플로우 단계(Idle, Ready, Processing, Completed, Failed, Cancelled)에 통일된 하단 구조 적용 필요
- Idle/Ready에서는 1층에 설정 피커, 나머지에서는 상태 메시지를 표시
- `.ultraThinMaterial` 배경으로 Tahoe/Sequoia 공통 레이어감 확보 필수
