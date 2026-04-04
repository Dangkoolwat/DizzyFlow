import SwiftUI

/// Cancelled 전용 Workspace —
/// 사용자 취소 안내와 Restart(rerun) 기능을 제공하는 화면.
struct CancelledWorkspaceView: View {
    @ObservedObject var store: WorkflowStore

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // MARK: - 취소 아이콘 + 메시지
            VStack(spacing: 20) {
                Image(systemName: "pause.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.orange)

                VStack(spacing: 8) {
                    Text("사용자가 취소한 작업입니다")
                        .font(.title)
                        .fontWeight(.bold)

                    if let doc = store.selectedDocument {
                        Text(doc.title)
                            .font(.title3)
                            .foregroundStyle(.secondary)

                        if !doc.segments.isEmpty {
                            Text("취소 시점까지 \(doc.segments.count)개 세그먼트 생성됨")
                                .font(.subheadline)
                                .foregroundStyle(.tertiary)
                        }
                    }
                }
            }

            Spacer()

            Divider()

            // MARK: - 액션
            HStack(spacing: 16) {
                // Restart (rerun)
                Button {
                    store.restartProcessing()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.clockwise")
                        Text("다시 시작")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    CancelledWorkspaceView(store: WorkflowStore())
}
