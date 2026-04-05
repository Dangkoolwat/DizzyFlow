import SwiftUI

/// 하단 2층 구조 컨테이너 — 모든 워크스페이스 뷰 공용.
///
/// 구조:
///   - 1층 (Status Layer): 설정 피커 또는 상태 메시지 — 라운딩 카드
///   - 2층 (Action Bar): 캡슐형 액션 버튼 세트 — 라운딩 카드
///
/// 카드 배경은 `Color.black.opacity()`로 미세한 어둡기 차이만 주어
/// macOS 14/15, 라이트/다크 모두에서 자연스럽게 녹아드는 구분감을 제공한다.
struct BottomControlStack<StatusContent: View, ActionContent: View>: View {
    @ViewBuilder let statusContent: () -> StatusContent
    @ViewBuilder let actionContent: () -> ActionContent

    var body: some View {
        VStack(spacing: 10) {
            // --- 1층: 설정 또는 상태 메시지 ---
            statusContent()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.03))
                )

            // --- 2층: 액션 바 ---
            actionContent()
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.black.opacity(0.05))
                )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
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
