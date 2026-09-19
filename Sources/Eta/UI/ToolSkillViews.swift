import SwiftUI

struct MarkdownRenderer: View {
    let content: String
    
    var body: some View {
        // Swift natively supports basic Markdown in Text starting iOS 15
        Text(try! AttributedString(markdown: content, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)))
            .font(.body)
    }
}

struct ToolCatalogView: View {
    var body: some View {
        List {
            Section("Device") {
                Text("tool_get_clipboard")
                Text("tool_set_clipboard")
                Text("tool_set_alarm")
            }
            Section("Terminal") {
                Text("tool_run_command")
            }
            Section("Browser") {
                Text("tool_browser_use")
            }
            Section("Memory") {
                Text("tool_memory_get")
            }
        }
        .navigationTitle("Tool Catalog")
    }
}

struct DeviceToolsSettingsView: View {
    var body: some View {
        Form {
            Section("Permissions") {
                Toggle("Read Clipboard", isOn: .constant(true))
                Toggle("Write Clipboard", isOn: .constant(true))
                Toggle("Set Alarms", isOn: .constant(true))
            }
        }
        .navigationTitle("Device Tools")
    }
}

struct SkillDetailView: View {
    let skillId: String
    
    var body: some View {
        List {
            Text("Skill Configuration details for \(skillId)")
        }
        .navigationTitle("Skill Detail")
    }
}

struct SkillEditorView: View {
    var body: some View {
        Form {
            TextField("Skill Name", text: .constant(""))
            TextEditor(text: .constant("Instructions..."))
        }
        .navigationTitle("Edit Skill")
    }
}

