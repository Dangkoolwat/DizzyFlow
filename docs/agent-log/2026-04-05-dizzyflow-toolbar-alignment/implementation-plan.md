# Implementation Plan

## Steps
1. **Remove Hacks**: 기존에 `Spacer()`를 통해 강제 위치 조정을 시도했던 부분을 삭제.
2. **SettingsBarView Placement Update**: 툴바 내에 위치하는 설정바의 `ToolbarItem` placement를 `.automatic` 또는 `.navigation`에서 `.principal`로 교체.
3. **Sidebar Title Fix**: "DizzyFlow" 타이틀이 제대로 Leading 영역에 남도록 `.navigationTitle("DizzyFlow")`를 사이드바 내부 `List` 계층에 단일 선언 유지.

## Affected Modules
- `ContentView.swift` (레이아웃 계층의 툴바 선별)

## Risk Areas
- iOS나 iPadOS로 타겟을 확장할 때 `.principal` 작동 방식이 macOS와 조금 다를 수 있으나, 현재 본 앱은 macOS 데스크탑 전용 목적이 크므로 위험도 낮음.
