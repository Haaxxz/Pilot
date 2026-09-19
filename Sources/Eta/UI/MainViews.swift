import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundColor(.blue)
            Text("Eta AI Agent")
                .font(.largeTitle)
                .bold()
            Text("Ready to assist you.")
                .foregroundColor(.secondary)
        }
    }
}





