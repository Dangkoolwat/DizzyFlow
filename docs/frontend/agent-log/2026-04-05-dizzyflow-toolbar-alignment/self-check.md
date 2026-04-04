# Self-Check

## Checklist

- **Architecture compliance**: ✅ SwiftUI NavigationSplitView macOS Unified Toolbar 디자인 가이드라인 준수.
- **Simplicity**: ✅ 복잡한 Spacer나 임의 Layout 개입을 없애고 네이티브 Toolbar API(.principal)로 단순화.
- **Security considerations**: ✅ 해당 사항 없음 (UI 변경).
- **Impact awareness**: ✅ 다른 앱/윈도우의 제목 규칙이나 사이드바 제어를 방해하지 않음.
- **Rollback possibility**: ✅ 단일 뷰(ContentView)의 1줄짜리 Enum(placement) 변경 사항이므로 즉시 롤백 가능.

결과: ✅ Pass
