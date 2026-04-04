import Foundation

/// 개별 자막 세그먼트 — 엔진이 처리한 단위 결과를 표현한다.
struct SubtitleSegment: Identifiable, Hashable {
    let id: UUID
    var index: Int
    var startTime: TimeInterval
    var endTime: TimeInterval
    var text: String

    init(
        id: UUID = UUID(),
        index: Int,
        startTime: TimeInterval,
        endTime: TimeInterval,
        text: String
    ) {
        self.id = id
        self.index = index
        self.startTime = startTime
        self.endTime = endTime
        self.text = text
    }
}
