import SwiftUI

/// 개별 세그먼트 카드 — 실시간 결과 영역에서 사용.
/// 현재 처리 중인 세그먼트는 시각적으로 하이라이트된다.
struct SegmentCardView: View {
    let segment: SubtitleSegment
    let isHighlighted: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 타임코드
            VStack(alignment: .trailing, spacing: 2) {
                Text(formatTime(segment.startTime))
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.secondary)

                Text(formatTime(segment.endTime))
                    .font(.caption)
                    .monospacedDigit()
                    .foregroundStyle(.tertiary)
            }
            .frame(width: 70, alignment: .trailing)

            // 세그먼트 번호 인디케이터
            Circle()
                .fill(isHighlighted ? Color.accentColor : Color.secondary.opacity(0.3))
                .frame(width: 8, height: 8)
                .padding(.top, 5)

            // 자막 텍스트
            Text(segment.text)
                .font(.body)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isHighlighted
                      ? Color.accentColor.opacity(0.08)
                      : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(
                    isHighlighted
                        ? Color.accentColor.opacity(0.4)
                        : Color.clear,
                    lineWidth: 1.5
                )
        )
        .animation(.easeInOut(duration: 0.3), value: isHighlighted)
    }

    private func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
    }
}

#Preview {
    VStack(spacing: 8) {
        SegmentCardView(
            segment: SubtitleSegment(
                index: 1,
                startTime: 0,
                endTime: 2.5,
                text: "안녕하세요, DizzyFlow 데모입니다."
            ),
            isHighlighted: false
        )

        SegmentCardView(
            segment: SubtitleSegment(
                index: 2,
                startTime: 2.5,
                endTime: 5.0,
                text: "현재 처리 중인 세그먼트입니다."
            ),
            isHighlighted: true
        )
    }
    .padding()
}
