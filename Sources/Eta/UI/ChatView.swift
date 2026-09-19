import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var inputText: String = ""
    @State private var showingAttachments = false
    @State private var selectedModelId: String? = "gpt-4o"
    @State private var effort: ReasoningEffort = .default
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                ModelSelectorView(selectedModelId: $selectedModelId)
                Spacer()
                ReasoningEffortSelector(effort: $effort)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .zIndex(1)
            
            // Messages Area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.messages, id: \.id) { message in
                            MessageRow(message: message)
                                .id(message.id)
                        }
                        
                        if viewModel.isGenerating {
                            HStack {
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                            .id("generating")
                        }
                    }
                    .padding(.top, 8)
                    .padding(.bottom, 20)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    withAnimation {
                        proxy.scrollTo(viewModel.messages.last?.id, anchor: .bottom)
                    }
                }
                .onChange(of: viewModel.isGenerating) { isGen in
                    if isGen {
                        withAnimation { proxy.scrollTo("generating", anchor: .bottom) }
                    }
                }
                // Dismiss keyboard on scroll
                .onTapGesture {
                    isInputFocused = false
                }
            }
            
            Divider()
            
            // Input Area
            HStack(alignment: .bottom, spacing: 12) {
                Button(action: { showingAttachments = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(width: 32, height: 32)
                        .background(Color(UIColor.secondarySystemFill))
                        .clipShape(Circle())
                }
                .padding(.bottom, 4)
                .sheet(isPresented: $showingAttachments) {
                    AttachmentPicker(isPresented: $showingAttachments)
                }
                
                TextField("Message Eta...", text: $inputText, axis: .vertical)
                    .focused($isInputFocused)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(20)
                    .lineLimit(1...6)
                
                Button(action: sendMessage) {
                    Image(systemName: viewModel.isGenerating ? "stop.fill" : "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle().fill(
                                viewModel.isGenerating ? Color.red : (inputText.isEmpty ? Color.blue.opacity(0.5) : Color.blue)
                            )
                        )
                }
                .padding(.bottom, 4)
                .disabled(inputText.isEmpty && !viewModel.isGenerating)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func sendMessage() {
        if viewModel.isGenerating {
            // Handle cancellation logic here
            viewModel.isGenerating = false
            return
        }
        
        guard !inputText.isEmpty else { return }
        
        let userMsg = ConversationMessageEntity(
            id: UUID().uuidString, conversationId: "1", sortIndex: viewModel.messages.count,
            type: "user", content: inputText, imagesJson: "[]", isEdited: false,
            imageCount: 0, toolsJson: "[]"
        )
        viewModel.messages.append(userMsg)
        inputText = ""
        isInputFocused = false
        
        viewModel.isGenerating = true
        
        // Simulated network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let astMsg = ConversationMessageEntity(
                id: UUID().uuidString, conversationId: "1", sortIndex: viewModel.messages.count,
                type: "assistant", content: "I've processed your request. Let me know how else I can help!",
                imagesJson: "[]", isEdited: false, reasoningTokens: effort != .off ? 245 : 0, imageCount: 0, toolsJson: "[]"
            )
            if self.viewModel.isGenerating {
                self.viewModel.messages.append(astMsg)
                self.viewModel.isGenerating = false
            }
        }
    }
}
