# Problem Analysis

## Problem Definition
DizzyFlow의 메인 UI 레이아웃 리팩토링 과정에서 macOS 네이티브 `NavigationSplitView`의 툴바(Unified Window Toolbar) 특성으로 인해 `SettingsBarView`(설정 메뉴)와 `DizzyFlow` 글로벌 창 타이틀의 배치가 의도대로 나오지 않는 문제가 다수 발생함.

1. **타이틀 강제 중앙 정렬 문제**: 컨텐츠 뷰에 툴바 아이템을 배치(`placement: .navigation`) 시, 암시적으로 윈도우 타이틀이 센터(`principal` 영역)로 밀려나 이중으로 글자가 보이는 문제.
2. **Spacer를 활용한 좌측 정렬 실패**: `.automatic` 그룹에서 `Spacer`를 사용할 때, 요소들이 윈도우 레이아웃 엔진에 의해 우측(`trailing` 영역) 끝으로 완전히 쏠려버리는 문제.

## Root Cause
- macOS SwiftUI의 `UnifiedWindowToolbarStyle`은 사이드바와 디테일 뷰를 단일 윈도우 툴바로 통합 렌더링함.
- `ToolbarItemPlacement`에 따른 암묵적인 구역 할당(`Leading`, `Principal`, `Trailing`)이 iOS와 다르게 동작(매우 강력하고 강제적임).
- 뷰 구조 상에서 `ToolbarItemGroup`이 아이템을 병합하는 방식과 유연 공간(`NSToolbarFlexibleSpaceItem`)의 한계를 오인함.

## Constraints
- "DizzyFlow" 메인 타이틀은 반드시 좌상단 원래 자리(사이드바 툴바 영역)를 지켜야 함.
- "SettingsBarView"는 컨텐츠 화면 쪽의 좌측(구분선과 가까운 중앙 부근)에 위치해야 하며, 우측으로 쏠리거나 좌측 타이틀을 밀어내서는 안 됨.
- "Inspector" 토글 버튼은 기존대로 가장 우측에 위치해야 함.
