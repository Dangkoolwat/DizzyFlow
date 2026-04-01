import Foundation

enum SidebarSection: String, CaseIterable, Identifiable {
    case home
    case documents
    case recent

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .documents:
            return "Documents"
        case .recent:
            return "Recent"
        }
    }

    var systemImage: String {
        switch self {
        case .home:
            return "house"
        case .documents:
            return "doc.on.doc"
        case .recent:
            return "clock"
        }
    }
}
