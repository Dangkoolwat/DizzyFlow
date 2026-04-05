import SwiftUI

/// Completed 전용 Workspace —
/// 작업 성공 후 결과물을 확인하고 다운로드하는 화면.
///
/// 구성:
/// - 중앙: SRT 전체 미리보기 (스크롤)
/// - 하단: 2층 구조 (1층: 완료 메시지 / 2층: FCPXML, SRT, 새 작업)
struct CompletedWorkspaceView: View {
    @ObservedObject var store: WorkflowStore

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - SRT 전체 미리보기 (스크롤)
            srtPreviewSection

            // MARK: - 하단 2층 구조
            bottomControlArea
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - SRT Preview

    private var srtPreviewSection: some View {
        ScrollView {
            if let doc = store.selectedDocument {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(doc.segments) { segment in
                        VStack(alignment: .leading, spacing: 4) {
                            // SRT 인덱스
                            Text("\(segment.index)")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(.secondary)

                            // 타임코드
                            Text("\(formatSRTTime(segment.startTime)) --> \(formatSRTTime(segment.endTime))")
                                .font(.caption)
                                .monospacedDigit()
                                .foregroundStyle(.tertiary)

                            // 자막 내용
                            Text(segment.text)
                                .font(.body)
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.textBackgroundColor).opacity(0.6)) // Tahoe 대비 강화
    }

    // MARK: - 하단 2층 구조

    private var bottomControlArea: some View {
        BottomControlStack {
            // 1층: 완료 메시지
            HStack {
                Label {
                    Text("작업이 완료되었습니다. 결과를 내려받거나 새 작업을 시작할 수 있습니다.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }

                Spacer()

                if let doc = store.selectedDocument {
                    Text("\(doc.segments.count)개 세그먼트")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        } actionContent: {
            // 2층: 액션 버튼
            HStack(spacing: 12) {
                CapsuleActionButton(
                    title: "FCPXML",
                    icon: "film",
                    isPrimary: true
                ) {
                    // 향후 FCPXML 내보내기
                }

                CapsuleActionButton(
                    title: "SRT",
                    icon: "doc.text"
                ) {
                    // 향후 SRT 내보내기
                }

                CapsuleActionButton(
                    title: "새 작업",
                    icon: "plus.circle"
                ) {
                    store.startNewWorkflow()
                }

                Spacer()
            }
        }
    }

    // MARK: - Helpers

    private func formatSRTTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 1000)
        return String(format: "%02d:%02d:%02d,%03d", hours, minutes, seconds, milliseconds)
    }
}

#Preview {
    CompletedWorkspaceView(store: WorkflowStore())
}
