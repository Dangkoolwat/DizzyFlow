import SwiftUI
import UniformTypeIdentifiers

/// Home Workspace — Idle/Ready 상태의 메인 작업 영역.
///
/// - Idle: 파일 드롭/선택 유도 + 상단 설정 바
/// - Ready: Mock 썸네일 + 파일 메타 확인 + 설정 요약 + "시작하기" 버튼
///
/// 상세 메타 정보(포맷, 코덱 등)는 Inspector에서 표시.
/// 중앙 Workspace에서는 "확신감"을 위한 시각 요소만 배치.
struct HomeWorkspaceView: View {
    @ObservedObject var store: WorkflowStore
    @State private var isTargeted = false

    var body: some View {
        VStack(spacing: 0) {
            // 메인 콘텐츠
            if store.pendingFile != nil {
                readyContent
            } else {
                idleContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Idle Content

    private var idleContent: some View {
        VStack(spacing: 24) {
            Spacer()

            VStack(spacing: 6) {
                Image(systemName: "waveform.and.mic")
                    .font(.system(size: 48))
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 8)

                Text("DizzyFlow")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundStyle(.primary)

                Text("Workflow-first subtitle tool")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }

            // 파일 드롭 영역
            dropZone

            // 파일 선택 버튼
            Button {
                simulateFileSelection()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "folder.badge.plus")
                    Text("미디어 파일 선택")
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)

            Text("미디어 파일을 드래그하거나 선택하여 자막 워크플로우를 시작하세요.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 360)

            Spacer()
        }
        .padding(40)
    }

    // MARK: - Ready Content

    private var readyContent: some View {
        VStack(spacing: 24) {
            Spacer()

            if let file = store.pendingFile {
                // 파일 확인 카드 (썸네일 + 메타 요약)
                fileConfirmationCard(file: file)

                // 설정 요약 카드
                settingsSummaryCard

                // 시작 버튼
                Button {
                    store.startProcessing()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "play.fill")
                        Text("시작하기")
                    }
                    .font(.title3)
                    .fontWeight(.semibold)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)

                // 파일 변경
                Button("다른 파일 선택") {
                    store.clearPendingFile()
                }
                .buttonStyle(.plain)
                .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(40)
    }

    // MARK: - File Confirmation Card

    /// 사용자에게 "내가 올린 파일이 맞다"는 확신을 주는 시각적 카드.
    /// Mock 썸네일(Placeholder) + 파일명 + 핵심 메타만 포함.
    /// 상세 기술 메타는 Inspector에서 담당.
    private func fileConfirmationCard(file: PendingFileInfo) -> some View {
        HStack(spacing: 16) {
            // Mock 썸네일 영역
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(.controlBackgroundColor),
                                Color(.controlBackgroundColor).opacity(0.6)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 80)

                // 파일 타입에 따른 아이콘
                Image(systemName: file.systemIcon)
                    .font(.system(size: 32))
                    .foregroundStyle(Color.accentColor.opacity(0.8))
            }

            // 파일 정보
            VStack(alignment: .leading, spacing: 6) {
                Text(file.fileName)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(1)

                HStack(spacing: 12) {
                    metaBadge(icon: "clock", text: file.displayDuration)
                    metaBadge(icon: "internaldrive", text: file.displaySize)
                }

                Text(file.displayFormat)
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.accentColor.opacity(0.2), lineWidth: 1)
        )
        .frame(maxWidth: 420)
    }

    /// 메타정보 소형 배지
    private func metaBadge(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(.secondary)

            Text(text)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Settings Summary Card

    private var settingsSummaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("적용 설정")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .textCase(.uppercase)

            settingSummaryRow(label: "FPS", value: store.selectedFPS)
            settingSummaryRow(label: "언어", value: store.selectedLanguage)
            settingSummaryRow(label: "FCP 템플릿", value: store.selectedTemplate)
            settingSummaryRow(label: "전사 모델", value: store.selectedModel)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.controlBackgroundColor))
        )
        .frame(maxWidth: 320)
    }

    // MARK: - Drop Zone

    private var dropZone: some View {
        RoundedRectangle(cornerRadius: 16)
            .strokeBorder(
                style: StrokeStyle(lineWidth: 2, dash: [8])
            )
            .frame(maxWidth: .infinity, minHeight: 160, maxHeight: 160)
            .foregroundStyle(isTargeted ? Color.accentColor : Color.secondary)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isTargeted
                          ? Color.accentColor.opacity(0.05)
                          : Color.clear)
            )
            .overlay(
                VStack(spacing: 8) {
                    Image(systemName: "arrow.down.doc")
                        .font(.title)
                        .foregroundStyle(isTargeted ? Color.accentColor : Color.secondary)

                    Text("여기에 미디어 파일을 드래그하세요")
                        .font(.headline)
                        .foregroundStyle(isTargeted ? .primary : .secondary)
                }
            )
            .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
                handleDrop(providers: providers)
                return true
            }
    }

    // MARK: - Helpers

    private func settingSummaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(width: 80, alignment: .trailing)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }

    /// 파일 드롭 처리 — 프로토타입이므로 파일명만 추출하여 Store에 전달
    private func handleDrop(providers: [NSItemProvider]) {
        guard let provider = providers.first else { return }
        provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { item, _ in
            guard let data = item as? Data,
                  let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
            DispatchQueue.main.async {
                store.prepareReady(fileName: url.lastPathComponent)
            }
        }
    }

    /// 파일 선택 시뮬레이션 (프로토타입)
    private func simulateFileSelection() {
        store.prepareReady(fileName: "Interview_2026_04.mov")
    }
}

#Preview {
    HomeWorkspaceView(store: WorkflowStore())
}
