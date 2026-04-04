import SwiftUI

/// Completed 전용 Workspace —
/// 작업 성공 후 결과물을 확인하고 다운로드하는 화면.
///
/// 액션 우선순위: FCPXML > SRT > 미리보기 > 새 작업
struct CompletedWorkspaceView: View {
    @ObservedObject var store: WorkflowStore

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 완료 헤더
            completedHeader

            Divider()

            // MARK: - SRT 전체 미리보기 (스크롤)
            srtPreviewSection

            Divider()

            // MARK: - 액션 버튼
            actionsSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Completed Header

    private var completedHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 32))
                .foregroundStyle(.green)

            VStack(alignment: .leading, spacing: 2) {
                Text("작업이 완료되었습니다")
                    .font(.title2)
                    .fontWeight(.bold)

                if let doc = store.selectedDocument {
                    Text("\(doc.segments.count)개 세그먼트 생성")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(20)
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
        .background(Color(.textBackgroundColor).opacity(0.3))
    }

    // MARK: - Actions

    private var actionsSection: some View {
        HStack(spacing: 16) {
            // FCPXML (최우선)
            Button {
                // 향후 FCPXML 내보내기
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "film")
                    Text("FCPXML 다운로드")
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            // SRT
            Button {
                // 향후 SRT 내보내기
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "doc.text")
                    Text("SRT 다운로드")
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.large)

            Spacer()

            // 새 작업
            Button {
                store.startNewWorkflow()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle")
                    Text("새 작업")
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .padding(20)
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
