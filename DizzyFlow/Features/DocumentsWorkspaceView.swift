import SwiftUI

/// Document Detail View — 사이드바에서 선택된 문서의 상태별 상세 화면.
///
/// 더 이상 자체 리스트를 관리하지 않으며,
/// `workflowPhase`에 따라 적절한 Workspace View를 분기하는 컨테이너 역할만 수행한다.
struct DocumentDetailView: View {
    @ObservedObject var store: WorkflowStore

    var body: some View {
        Group {
            if let document = store.selectedDocument {
                VStack(spacing: 0) {
                    // 상단 설정/메시지 바
                    SettingsBarView(store: store)

                    Divider()

                    // 상태에 따른 메인 콘텐츠
                    phaseContent(for: document)
                }
            } else {
                noDocumentSelectedView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Phase-based Routing

    @ViewBuilder
    private func phaseContent(for document: SubtitleDocument) -> some View {
        switch document.workflowPhase {
        case .idle, .ready:
            idleReadyContent(for: document)

        case .processing:
            ProcessingWorkspaceView(store: store)

        case .completed:
            CompletedWorkspaceView(store: store)

        case .failed:
            FailedWorkspaceView(store: store)

        case .cancelled:
            CancelledWorkspaceView(store: store)
        }
    }

    // MARK: - Idle / Ready Detail

    private func idleReadyContent(for document: SubtitleDocument) -> some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 8) {
                Text(document.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(document.workflowPhase.rawValue.capitalized)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            if let fileName = document.inputFileName {
                HStack(spacing: 6) {
                    Image(systemName: "doc")
                        .foregroundStyle(.secondary)
                    Text(fileName)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding(40)
    }

    // MARK: - No Document

    private var noDocumentSelectedView: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "waveform.and.mic")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)

            VStack(spacing: 8) {
                Text("DizzyFlow")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Workflow-first subtitle prototype")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            Text("Home에서 미디어를 가져와 워크플로우를 시작하세요.\n완료된 문서는 사이드바에서 선택할 수 있습니다.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(40)
    }
}

#Preview {
    DocumentDetailView(store: WorkflowStore())
}
