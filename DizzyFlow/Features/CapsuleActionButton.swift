import SwiftUI

/// 캡슐형 액션 버튼 — 하단 2층 구조의 Action Bar에서 사용.
///
/// `isPrimary`에 따라 `.borderedProminent` / `.bordered` 스타일을 자동 분기하며,
/// 파괴적 액션(삭제, 취소 등)은 `isDestructive`로 지정 가능.
struct CapsuleActionButton: View {
    let title: String
    let icon: String
    var isPrimary: Bool = false
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        if isPrimary {
            actionButton
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(isDestructive ? .red : nil)
        } else {
            actionButton
                .buttonStyle(.bordered)
                .controlSize(.large)
                .tint(isDestructive ? .red : nil)
        }
    }

    private var actionButton: some View {
        Button(role: isDestructive ? .destructive : nil) {
            action()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: icon)
                Text(title)
            }
        }
    }
}

#Preview("Capsule Buttons") {
    HStack(spacing: 12) {
        CapsuleActionButton(title: "FCPXML", icon: "film", isPrimary: true) {}
        CapsuleActionButton(title: "SRT", icon: "doc.text") {}
        CapsuleActionButton(title: "취소", icon: "xmark.circle.fill", isDestructive: true) {}
    }
    .padding()
}
