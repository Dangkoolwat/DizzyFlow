import SwiftUI

struct PlaceholderWorkspaceView: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            Text(title)
                .font(.title)
                .fontWeight(.semibold)

            Text(message)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding(40)
    }
}

#Preview {
    PlaceholderWorkspaceView(
        title: "Recent Workflows",
        message: "Recent workflows will appear here."
    )
}
