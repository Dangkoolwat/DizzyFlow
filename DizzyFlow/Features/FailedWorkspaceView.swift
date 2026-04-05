import SwiftUI

/// Failed 전용 Workspace —
/// 실패 사실과 실패 지점을 즉시 사용자에게 전달하는 화면.
///
/// 구성:
/// - 중앙: 실패 아이콘 + 메시지
/// - 하단: 2층 구조 (1층: 실패 단계 + 오류 원인 / 2층: 새 작업)
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

            // MARK: - 하단 2층 구조
            bottomControlArea
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - 하단 2층 구조

    private var bottomControlArea: some View {
        BottomControlStack {
            // 1층: 실패 단계 + 오류 원인 요약
            HStack {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        if let step = store.selectedDocument?.failedStep {
                            Text("실패 단계: \(step)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        if let message = store.selectedDocument?.failureMessage {
                            Text(message)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                                .lineLimit(1)
                        }
                    }
                } icon: {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.red)
                }

                Spacer()
            }
        } actionContent: {
            // 2층: 새 작업
            HStack(spacing: 12) {
                CapsuleActionButton(
                    title: "새 작업",
                    icon: "plus.circle",
                    isPrimary: true
                ) {
                    store.startNewWorkflow()
                }

                Spacer()
            }
        }
    }
}

#Preview {
    FailedWorkspaceView(store: WorkflowStore())
}
