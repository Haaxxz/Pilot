import SwiftUI

struct AttachmentPicker: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {}) {
                    Label("Photo Library", systemImage: "photo")
                }
                Button(action: {}) {
                    Label("Files", systemImage: "folder")
                }
                Button(action: {}) {
                    Label("File Path", systemImage: "link")
                }
            }
            .navigationTitle("Add Attachment")
            .navigationBarItems(trailing: Button("Cancel") { isPresented = false })
        }
    }
}

struct ModelSelectorView: View {
    @Binding var selectedModelId: String?
    
    var body: some View {
        Menu {
            Button("GPT-4o") { selectedModelId = "gpt-4o" }
            Button("Claude 3.5 Sonnet") { selectedModelId = "claude-3-5-sonnet" }
        } label: {
            HStack {
                Text(selectedModelId ?? "Select Model")
                Image(systemName: "chevron.up.chevron.down")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(8)
        }
    }
}

struct ReasoningEffortSelector: View {
    @Binding var effort: ReasoningEffort
    
    var body: some View {
        Menu {
            ForEach(ReasoningEffort.allCases, id: \.self) { e in
                Button(e.displayName) { effort = e }
            }
        } label: {
            HStack {
                Image(systemName: "brain")
                Text(effort.displayName)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(effort != .off ? Color.purple.opacity(0.2) : Color(UIColor.secondarySystemBackground))
            .foregroundColor(effort != .off ? .purple : .primary)
            .cornerRadius(8)
        }
    }
}

struct RunTraceView: View {
    let events: [AgentEvent]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(events.indices, id: \.self) { index in
                    Text(String(describing: events[index]))
                        .font(.caption)
                        .fontDesign(.monospaced)
                }
            }
            .padding()
        }
        .navigationTitle("Run Trace")
    }
}

