import Foundation

/// 사이드바 선택 모델 — Home, 개별 문서, Settings를 단일 레벨로 표현한다.
///
/// 기존 SidebarSection(home/documents/recent) 이중 구조를 대체하여
/// UX 문서 기준의 플랫 사이드바를 구현한다.
enum SidebarDestination: Hashable {
    case home
    case document(UUID)
    case settings
}
