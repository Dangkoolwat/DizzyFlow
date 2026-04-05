import SwiftUI

/// 하단 2층 구조 컨테이너 — 모든 워크스페이스 뷰 공용.
///
/// 구조:
///   - 1층 (Status Layer): 설정 피커 또는 상태 메시지
///   - 2층 (Action Bar): 캡슐형 액션 버튼 세트
///
/// 상단 모서리를 라운딩한 컨테이너 배경(`Color.black.opacity(0.05)`)으로
/// 중앙 콘텐츠 영역과의 시각적 구분을 제공한다.
struct BottomControlStack<StatusContent: View, ActionContent: View>: View {
    @ViewBuilder let statusContent: () -> StatusContent
    @ViewBuilder let actionContent: () -> ActionContent

    var body: some View {
        VStack(spacing: 12) {
            // --- 1층: 설정 또는 상태 메시지 ---
            statusContent()
                .padding(.horizontal, 16)

            // --- 2층: 액션 바 ---
            actionContent()
                .padding(.horizontal, 16)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.05))
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 12, topTrailingRadius: 12))
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
                Text("10개 세그먼트")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
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
