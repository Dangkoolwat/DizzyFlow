# Proposal

## Solution Approach
- `toolbar` 배치를 통해 macOS의 `UnifiedWindowToolbarStyle` 고유의 3영역 레이아웃 시스템(`.navigation`, `.principal`, `.primaryAction`)에 순응한다.
- `navigationTitle("DizzyFlow")`는 기존처럼 `sidebar`에 남겨두어 Leading 영역(왼쪽 끝)을 사수하게 한다.
- `SettingsBarView`의 배치를 `.principal`(중앙)로 변경하여, 의도하지 않게 우측 끝(`.automatic`)으로 밀리거나 좌측 타이틀(`.navigation`)을 침범하는 이슈를 근본적으로 차단한다.
- 이로써 `DizzyFlow`(좌측) - (공백) - `설정메뉴`(중앙) - (공백) - `인스펙터`(우측) 과 같은, 매우 안정적이고 네이티브 친화적인 레이아웃 구조가 완성된다.

## Alternatives Considered
- **Detail View에 `.navigation` 배치 사용**: 이는 좌측 아이템을 좌측 끝 윈도우 영역까지 밀어내어 윈도우 타이틀과 충돌하게 하므로 실패함.
- **Separate ToolbarItem + Spacer 사용 (`.automatic` 영역 직렬화)**: `NSToolbarFlexibleSpaceItem`의 작동이 전체 그룹을 우측 컨테이너에 넣고 우측 방향으로 클러스터링을 유도하여, 결국 우측 끝으로 날아가므로 실패함.

## Trade-offs
- `.principal`은 화면(디테일 영역 기준이 아닌 활성 윈도우 기준)의 정중앙에 위치하게 된다. 사용자가 분할선의 "바로 오른쪽" 빈틈에 바짝 붙기를 원했던 초기 의도와는 다르게 스크린 정중앙의 위치를 강제받게 되나, UI/UX상 컨텐츠 헤더 컨트롤은 보통 중앙 배치가 균형이 맞고 Apple 데스크탑 철학과 일치하므로 가장 타당한 득실 비율을 가짐.
