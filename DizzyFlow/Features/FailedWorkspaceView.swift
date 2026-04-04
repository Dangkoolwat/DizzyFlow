import SwiftUI

/// Failed 전용 Workspace —
/// 실패 사실과 실패 지점을 즉시 사용자에게 전달하는 화면.
///
/// Restart는 기본 비제공 (cancel과 fail은 성격이 다름).
struct FailedWorkspaceView: View {
    @ObservedObject var store: WorkflowStore

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // MARK: - 실패 아이콘 + 메시지
            VStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.red)

                VStack(spacing: 8) {
                    Text("작업에 실패했습니다")
                        .font(.title)
                        .fontWeight(.bold)

                    // 실패 단계
                    if let step = store.selectedDocument?.failedStep {
                        Text("실패 단계: \(step)")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    // 실패 설명
                    if let message = store.selectedDocument?.failureMessage {
                        Text(message)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 400)
                    }
                }
            }

            Spacer()

            Divider()

            // MARK: - 액션
            HStack {
                Spacer()

                Button {
                    store.startNewWorkflow()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus.circle")
                        Text("새 작업")
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                Spacer()
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    FailedWorkspaceView(store: WorkflowStore())
}
