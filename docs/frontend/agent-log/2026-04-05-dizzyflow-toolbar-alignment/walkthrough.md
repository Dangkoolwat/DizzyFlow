# Walkthrough

이번 레이아웃 개선 프로세스에서는 DizzyFlow macOS 데스크탑의 툴바 배치(Top Toolbar Layout)를 고도화했습니다. 

## 시도 및 해결 과정
1. 1차 시도 (`ToolbarItemGroup.navigation`): macOS Unified 툴바 렌더링에 의해 메인 타이틀을 중앙으로 밀어내는 부작용 발생.
2. 2차 시도 (`Spacer`를 통한 수동 정렬): 예상치 못하게 설정 그룹(`SettingsBarView`)이 맨 우측의 인스펙터 버튼 옆까지 밀려버리는 현상 발견.
3. 3차 최종 해결 (`placement: .principal`): 억지로 디테일 뷰 좌측에 끼워넣는 대신, 가장 안정적이고 중앙에 집중된 Principal 영역에 위치하도록 개선.

## 최종 적용 모습
1. **DizzyFlow**: 윈도우 창 맨 왼쪽(Leading Edge)에 항상 위치합니다.
2. **SettingsBarView (설정 및 메세지 공간)**: 윈도우 창 정중앙(Principal Edge)에 위치합니다. 
3. **인스펙터 (사이드바 토글)**: 윈도우 창 맨 오른쪽(Trailing Edge)에 항상 위치합니다.

## 결과 
이제 화면 폭을 늘릭거나 줄여도 툴바 요소들이 중앙과 양 끝을 기준으로 균형감 있게 정렬되어 우수한 시각적 밀도와 안정감을 제공합니다.
