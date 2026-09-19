import SwiftUI

struct ToolsView: View {
    var body: some View {
        List {
            NavigationLink("Agent Tool Catalog", value: AppRoute.tools)
            Text("Browser Tools: Enabled")
            Text("Terminal Tools: Enabled")
            Text("Device Tools: Enabled")
        }
        .navigationTitle("Tools")
    }
}

struct SkillsView: View {
    var body: some View {
        List {
            Section("Built-in") {
                Text("Self-Improving Agent")
                Text("Skill Creator")
                Text("Skill Installer")
            }
            Section("Custom") {
                Text("No custom skills installed.")
            }
        }
        .navigationTitle("Skills")
    }
}

struct MemoryView: View {
    var body: some View {
        Form {
            Section("Agent Memory") {
                Toggle("Enable Memory", isOn: .constant(true))
                Button("View Draft Memory") {}
                Button("Clear Memory") {}.foregroundColor(.red)
            }
        }
        .navigationTitle("Memory")
    }
}

struct WorkspaceView: View {
    var body: some View {
        List {
            Text("Workspace Directory: /Documents")
        }
        .navigationTitle("Workspace")
    }
}

struct SharedFoldersView: View {
    var body: some View {
        List {
            Text("No shared folders. On iOS, use the Files app to interact with the app sandbox.")
        }
        .navigationTitle("Shared Folders")
    }
}

struct LinuxFilesView: View {
    var body: some View {
        VStack {
            Text("Linux Files Not Supported")
                .font(.headline)
            Text("The PRoot environment is not available on iOS. File interactions are limited to the app sandbox.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
        }
        .navigationTitle("Linux Files")
    }
}

