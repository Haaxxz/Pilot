import SwiftUI

struct MessageRow: View {
    let message: ConversationMessageEntity
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.type == "user" {
                Spacer(minLength: 40)
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(ChatBubbleShape(isUser: true))
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    if let reasoning = message.reasoningTokens, reasoning > 0 {
                        DisclosureGroup {
                            Text("Thought process evaluated \(reasoning) tokens...")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        } label: {
                            HStack {
                                Image(systemName: "brain")
                                Text("Thinking (\(reasoning) tokens)")
                            }
                            .font(.caption.bold())
                            .foregroundColor(.purple)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    MarkdownRenderer(content: message.content)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(ChatBubbleShape(isUser: false))
                    
                    if let toolName = message.toolName {
                        HStack(spacing: 6) {
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .foregroundColor(.orange)
                            Text("\(toolName): \(message.resultSummary ?? "Running...")")
                                .lineLimit(1)
                        }
                        .font(.caption2)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color(UIColor.tertiarySystemBackground))
                        .cornerRadius(8)
                    }
                }
                Spacer(minLength: 40)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
    }
}

// Custom shape for iMessage-style bubbles
struct ChatBubbleShape: Shape {
    let isUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [
                .topLeft,
                .topRight,
                isUser ? .bottomLeft : .bottomRight
            ],
            cornerRadii: CGSize(width: 16, height: 16)
        )
        return Path(path.cgPath)
    }
}

class ChatViewModel: ObservableObject {
    @Published var messages: [ConversationMessageEntity] = []
    @Published var isGenerating: Bool = false
}

struct ConversationDrawer: View {
    var body: some View {
        List {
            Section("Today") {
                Text("App Architecture Design").lineLimit(1)
                Text("SwiftUI Layout Debugging").lineLimit(1)
            }
            Section("Previous 7 Days") {
                Text("Database Migration Script").lineLimit(1)
            }
        }
        .navigationTitle("History")
    }
}
