import SwiftUI

/// Processing 전용 Workspace —
/// Safe Lock 상태에서의 중앙 작업 영역.
///
/// 구성:
/// - 전용 진행 바
/// - 현재 단계 메시지
/// - 누적 스크롤형 실시간 결과 영역
/// - Job Cancel 버튼
struct ProcessingWorkspaceView: View {
    @ObservedObject var store: WorkflowStore

    /// 사용자가 수동 스크롤 중인지 추적
    @State private var isUserScrolling = false

    /// 자동 스크롤 대상 ID
    private let bottomAnchorID = "bottomAnchor"

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 진행 바
            progressSection

            Divider()

            // MARK: - 누적 스크롤 결과 영역
            scrollableResultsSection

            Divider()

            // MARK: - Job Cancel 버튼
            cancelSection
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.windowBackgroundColor).opacity(0.96))
    }

    // MARK: - Progress Section

    private var progressSection: some View {
        VStack(spacing: 12) {
            // 현재 단계 메시지
            HStack {
                if let step = store.currentProcessingStep {
                    Image(systemName: stepIcon(for: step))
                        .foregroundStyle(Color.accentColor)
                        .imageScale(.large)

                    Text(step.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Spacer()

                    Text("\(Int(step.progress * 100))%")
                        .font(.title3)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView()
                        .controlSize(.small)

                    Text("처리 준비 중...")
                        .font(.title3)
                        .foregroundStyle(.secondary)

                    Spacer()
                }
            }

            // 전용 진행 바
            if let step = store.currentProcessingStep {
                ProgressView(value: step.progress)
                    .progressViewStyle(.linear)
                    .tint(.accentColor)
                    .animation(.easeInOut(duration: 0.5), value: step.progress)
            } else {
                ProgressView()
                    .progressViewStyle(.linear)
            }

            // 세그먼트 카운트 표시
            if let doc = store.selectedDocument, !doc.segments.isEmpty {
                HStack {
                    Text("생성된 세그먼트: \(doc.segments.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                }
            }
        }
        .padding(20)
    }

    // MARK: - Scrollable Results

    private var scrollableResultsSection: some View {
        Group {
            if let doc = store.selectedDocument {
                if doc.segments.isEmpty {
                    // 아직 세그먼트가 없을 때
                    VStack {
                        Spacer()

                        VStack(spacing: 12) {
                            ProgressView()
                            Text("엔진이 결과를 생성하는 중입니다...")
                                .font(.body)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                    }
                } else {
                    ZStack(alignment: .bottomTrailing) {
                        ScrollViewReader { proxy in
                            ScrollView {
                                LazyVStack(spacing: 4) {
                                    ForEach(doc.segments) { segment in
                                        SegmentCardView(
                                            segment: segment,
                                            isHighlighted: segment.id == doc.currentlyProcessingID
                                        )
                                        .id(segment.id)
                                    }

                                    // 스크롤 앵커
                                    Color.clear
                                        .frame(height: 1)
                                        .id(bottomAnchorID)
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                            }
                            .onChange(of: doc.segments.count) { _, _ in
                                if !isUserScrolling {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        proxy.scrollTo(bottomAnchorID, anchor: .bottom)
                                    }
                                }
                            }
                        }

                        // 자동 스크롤 토글 + 복귀 버튼
                        scrollControlButton
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var scrollControlButton: some View {
        Button {
            isUserScrolling.toggle()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: isUserScrolling ? "arrow.down" : "pause")
                Text(isUserScrolling ? "자동 스크롤 켜기" : "자동 스크롤 끄기")
            }
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(radius: 4)
        }
        .buttonStyle(.plain)
        .padding(16)
    }

    // MARK: - Cancel Section

    private var cancelSection: some View {
        HStack {
            Spacer()

            Button(role: .destructive) {
                store.cancelProcessing()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "xmark.circle.fill")
                    Text("작업 취소")
                }
                .font(.body)
                .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .controlSize(.large)

            Spacer()
        }
        .padding(20)
    }

    // MARK: - Helpers

    private func stepIcon(for step: ProcessingStep) -> String {
        switch step {
        case .audioAnalysis:    return "waveform"
        case .vadAnalysis:      return "waveform.badge.magnifyingglass"
        case .transcription:    return "text.bubble"
        case .srtGeneration:    return "doc.text"
        case .fcpxmlGeneration: return "film"
        }
    }
}

#Preview {
    ProcessingWorkspaceView(store: WorkflowStore())
}
