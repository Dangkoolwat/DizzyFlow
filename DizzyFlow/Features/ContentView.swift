import SwiftUI

/// 메인 앱 레이아웃 — 플랫 사이드바 + Workspace + Inspector (3패널)
///
/// 사이드바 구조:
///   - Home (최상단, 고정)
///   - Documents (WorkflowStore.documents 직접 나열)
///   - Settings (최하단, 고정)
///
/// Safe Lock:
///   Processing 중 사이드바와 Inspector의 인터랙션을 차단한다.
struct ContentView: View {
    @ObservedObject var store: WorkflowStore
    @State private var sidebarSelection: SidebarDestination? = .home
    @State private var showsInspector: Bool = true

    var body: some View {
        NavigationSplitView {
            sidebar
        } detail: {
            HStack(spacing: 0) {
                mainWorkspace
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped() // Tahoe(v14) 스크롤 콘텐츠 비침 방지

                if showsInspector {
                    Divider()

                    inspectorPanel
                        .frame(width: 280)
                        .background(.background)
                }
            }
            .overlay(alignment: .top) { Divider() } // Sequoia(v15) 상단 구분선
            .toolbar {
                // --- 테마 전환기 (아이콘 테마명 메뉴) ---
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        ForEach(AppTheme.allCases) { theme in
                            Button {
                                store.appTheme = theme
                            } label: {
                                HStack {
                                    Image(systemName: theme.symbol)
                                    Text(theme.rawValue)
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: store.appTheme.symbol)
                            Text(store.appTheme.rawValue)
                                .font(.body)
                        }
                    }
                    .menuStyle(.borderlessButton)
                    .buttonStyle(.plain) // 타호(v14) 테두리 제거
                    .help("앱 테마 변경")
                }

                // --- 인스펙터 토글 ---
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showsInspector.toggle()
                    } label: {
                        Image(systemName: "sidebar.right")
                    }
                    .buttonStyle(.plain) // 타호(v14) 테두리 제거
                    .help(showsInspector ? "Hide Inspector" : "Show Inspector")
                }
            }
            .toolbarBackground(.visible, for: .windowToolbar) // 스크롤 시 콘텐츠 비침 방지
        }
        .frame(minWidth: 1000, minHeight: 640)
        .preferredColorScheme(store.appTheme.colorScheme)
        // Document 선택 동기화: Store → Sidebar
        .onChange(of: store.selectedDocumentID) { _, newID in
            if let newID {
                sidebarSelection = .document(newID)
            }
        }
        // Sidebar 선택 → Store 동기화
        .onChange(of: sidebarSelection) { _, newValue in
            switch newValue {
            case .document(let id):
                if store.selectedDocumentID != id {
                    store.selectDocument(store.documents.first { $0.id == id })
                }
            case .home, .settings, .none:
                if store.selectedDocumentID != nil {
                    store.selectDocument(nil)
                }
            }
        }
    }

    // MARK: - Sidebar (플랫 구조)

    private var sidebar: some View {
        List(selection: $sidebarSelection) {
            // Home (최상단)
            Label("Home", systemImage: "house")
                .tag(SidebarDestination.home)

            // Documents (직접 나열)
            Section("Documents") {
                if store.documents.isEmpty {
                    Text("아직 작업이 없습니다")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                } else {
                    ForEach(store.documents) { document in
                        documentRow(for: document)
                            .tag(SidebarDestination.document(document.id))
                    }
                }
            }
            // Settings moved to safeAreaInset
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                if sidebarSelection == .settings {
                    sidebarSelection = .home
                } else {
                    sidebarSelection = .settings
                }
            } label: {
                HStack {
                    Label("Settings", systemImage: "gear")
                        .padding(.horizontal, 4)
                        .foregroundStyle(sidebarSelection == .settings ? Color.accentColor : Color.primary)
                    Spacer()
                }
                .padding(.vertical, 6)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(sidebarSelection == .settings ? Color.accentColor.opacity(0.15) : Color.clear)
                    .padding(.horizontal, 8)
            )
        }
        .navigationSplitViewColumnWidth(min: 220, ideal: 240, max: 300)
        .navigationTitle("DizzyFlow")
        .disabled(store.isProcessing)
        .opacity(store.isProcessing ? 0.5 : 1.0)
    }

    /// 사이드바 문서 행 — 제목 + 상태 배지
    private func documentRow(for document: SubtitleDocument) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(document.title)
                    .lineLimit(1)

                if let fileName = document.inputFileName {
                    Text(fileName)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .lineLimit(1)
                }
            }

            Spacer()

            phaseBadge(for: document.workflowPhase)
        }
    }

    @ViewBuilder
    private func phaseBadge(for phase: WorkflowPhase) -> some View {
        switch phase {
        case .idle:
            EmptyView()
        case .ready:
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.blue)
                .font(.caption)
        case .processing:
            ProgressView()
                .controlSize(.mini)
        case .completed:
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .font(.caption)
        case .failed:
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.red)
                .font(.caption)
        case .cancelled:
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.orange)
                .font(.caption)
        }
    }

    // MARK: - Main Workspace (선택 기반 라우팅)

    @ViewBuilder
    private var mainWorkspace: some View {
        switch sidebarSelection {
        case .home, .none:
            HomeWorkspaceView(store: store)

        case .document:
            DocumentDetailView(store: store)

        case .settings:
            SettingsWorkspaceView(store: store)
        }
    }

    // MARK: - Inspector

    private var inspectorPanel: some View {
        InspectorPanelView(
            destination: sidebarSelection ?? .home,
            store: store
        )
    }
}

// MARK: - Legacy Placeholder Removed

#Preview {
    ContentView(store: WorkflowStore())
}
