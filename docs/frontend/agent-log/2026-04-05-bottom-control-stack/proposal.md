# Proposal

## Solution Approach
상단 SettingsBarView의 설정/메시지 로직을 완전히 제거하고, 모든 워크스페이스 뷰 하단에 통일된 2층 구조(BottomControlStack)를 이식한다.

- **1층 (Status Layer)**: 단계에 따라 설정 피커(Idle/Ready) 또는 상태 메시지(Processing/Terminal)를 표시
- **2층 (Action Bar)**: 캡슐형 버튼(CapsuleActionButton)으로 단계별 주요 액션 제공

## Alternatives Considered
1. 상단 툴바에 설정만 남기는 하이브리드 방식 → 사용자 가이드에서 명시적으로 "상단 비움" 지시
2. 하단 1층 구조(액션만) → 설정/메시지 표시 공간 부족

## Trade-offs
- 상단 빈 공간이 생기나, 향후 검색이나 제목 표시 등으로 활용 가능
- 하단에 모든 핵심 정보가 집중되어 시선 이동 최소화
