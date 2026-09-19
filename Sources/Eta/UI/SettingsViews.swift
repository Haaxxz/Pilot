import SwiftUI

struct SettingsView: View {
    @ObservedObject var defaults = UserDefaultsStore.shared
    
    var body: some View {
        Form {
            Section(header: Text("Agent Configuration")) {
                Toggle("Enable Thinking", isOn: Binding(
                    get: { defaults.agentThinkingEnabled },
                    set: { defaults.agentThinkingEnabled = $0 }
                ))
                Toggle("Terminal Tools", isOn: Binding(
                    get: { defaults.agentTerminalTools },
                    set: { defaults.agentTerminalTools = $0 }
                ))
                Toggle("Browser Tools", isOn: Binding(
                    get: { defaults.agentBrowserTools },
                    set: { defaults.agentBrowserTools = $0 }
                ))
            }
            
            Section(header: Text("Platform Status")) {
                NavigationLink("Permissions", value: AppRoute.permissions)
                NavigationLink("System Enhancements", value: AppRoute.systemEnhance)
            }
            
            Section(header: Text("About")) {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("3.0.4")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct PermissionsView: View {
    var body: some View {
        Form {
            Section(header: Text("iOS Permissions")) {
                Text("Notifications")
                Text("Location")
                Text("Photos")
                Text("Microphone")
            }
            
            Section(footer: Text("Unlike Android, iOS requires explicit user permission for most capabilities. Background activity is strictly limited by the system.")) {
                EmptyView()
            }
        }
    }
}

struct SystemEnhancementsView: View {
    var body: some View {
        Form {
            Section(header: Text("Android Features"), footer: Text("These features require Xposed/LSPosed or system-level APIs that are not available on iOS. The iOS port uses native alternatives where possible.")) {
                
                UnavailableFeatureRow(
                    title: "Circle to Search Gesture",
                    description: "Requires Android gesture bar hooking"
                )
                
                UnavailableFeatureRow(
                    title: "Hardware Power Button",
                    description: "Cannot intercept power button on iOS. Use Siri Shortcuts instead."
                )
                
                UnavailableFeatureRow(
                    title: "System UI Takeover",
                    description: "Cannot inject UI over other apps on iOS."
                )
                
                UnavailableFeatureRow(
                    title: "PRoot Linux Environment",
                    description: "Cannot execute arbitrary ELF binaries on iOS."
                )
            }
            
            Section(header: Text("iOS Alternatives")) {
                Button("Install Siri Shortcut") {
                    // Siri shortcut installation logic
                }
                Text("Share Sheet Extension is installed automatically.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct UnavailableFeatureRow: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                Text("Unavailable")
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.red.opacity(0.1))
                    .foregroundColor(.red)
                    .cornerRadius(4)
            }
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

