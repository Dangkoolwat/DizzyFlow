import SwiftUI

/// 상단 설정 바 — V1.0 이후 설정 및 메시지 로직이 하단 2층 구조(BottomControlStack)로 이관됨.
///
/// 현재 이 뷰는 비어 있으며, 향후 상단 전용 기능(검색 등)이 추가될 경우 재활용할 수 있다.
struct SettingsBarView: View {
    @ObservedObject var store: WorkflowStore

    var body: some View {
        EmptyView()
    }
}

#Preview("Empty") {
    SettingsBarView(store: WorkflowStore())
}
