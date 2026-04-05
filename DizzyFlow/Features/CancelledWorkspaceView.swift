import SwiftUI

/// Cancelled 전용 Workspace —
/// 사용자 취소 안내와 Restart(rerun) 기능을 제공하는 화면.
///
/// 구성:
/// - 중앙: 취소 아이콘 + 메시지
/// - 하단: 2층 구조 (1층: 취소 안내 + 중단 시점 / 2층: 다시 시작 + 새 작업)
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
            // 1층: 취소 안내 + 중단 시점 정보
            HStack {
                Label {
                    Text("사용자가 작업을 취소했습니다.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "pause.circle.fill")
                        .foregroundStyle(.orange)
                }

                Spacer()

                if let doc = store.selectedDocument, !doc.segments.isEmpty {
                    Text("중단 시점: \(doc.segments.count)개 세그먼트")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }
        } actionContent: {
            // 2층: 다시 시작 + 새 작업
            HStack(spacing: 12) {
                CapsuleActionButton(
                    title: "다시 시작",
                    icon: "arrow.clockwise",
                    isPrimary: true
                ) {
                    store.restartProcessing()
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
}

#Preview {
    CancelledWorkspaceView(store: WorkflowStore())
}
