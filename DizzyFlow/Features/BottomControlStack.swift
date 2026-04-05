import SwiftUI

/// 하단 2층 구조 컨테이너 — 모든 워크스페이스 뷰 공용.
///
/// 구조:
///   - 1층 (Status Layer): 설정 피커 또는 상태 메시지
///   - 2층 (Action Bar): 캡슐형 액션 버튼 세트
///
/// `.ultraThinMaterial` 배경으로 Tahoe/Sequoia 공통 레이어감을 확보한다.
struct BottomControlStack<StatusContent: View, ActionContent: View>: View {
    @ViewBuilder let statusContent: () -> StatusContent
    @ViewBuilder let actionContent: () -> ActionContent

    var body: some View {
        VStack(spacing: 16) {
            // --- 1층: 설정 또는 상태 메시지 ---
            statusContent()
                .padding(.horizontal, 24)

            // --- 2층: 액션 바 ---
            actionContent()
                .padding(.horizontal, 16)
        }
        .padding(.vertical, 20)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) { Divider() }
    }
}

#Preview("BottomControlStack") {
    VStack {
        Spacer()
        BottomControlStack {
            HStack {
                Label("작업이 완료되었습니다.", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                Spacer()
            }
        } actionContent: {
            HStack(spacing: 12) {
                CapsuleActionButton(title: "FCPXML", icon: "film", isPrimary: true) {}
                CapsuleActionButton(title: "SRT", icon: "doc.text") {}
                Spacer()
            }
        }
    }
}
