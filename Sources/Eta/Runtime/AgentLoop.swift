import Foundation

public enum AgentEvent {
    case runStarted(initialImages: Int, toolCount: Int, terminalTools: Bool)
    case roundStarted
    case modelRetryScheduled(attempt: Int, error: String)
    case providerRequestStarted
    case providerResponseStarted
    case assistantBlockStart(kind: String) // text, thinking, tool_call
    case assistantBlockDelta(text: String)
    case assistantBlockEnd
    case toolStarted(id: String, name: String, arguments: String)
    case toolFinished(id: String, result: String)
    case runFinished
    case runFailed(error: String)
}

public class AgentLoop {
    private let client: AgentProviderClient
    private let toolExecutor: ToolExecutor
    private let providerSetting: ProviderSetting
    private let model: Model
    private let onEvent: (AgentEvent) -> Void
    
    private var history: [OpenAIMessage] = []
    
    public init(
        client: AgentProviderClient,
        toolExecutor: ToolExecutor,
        providerSetting: ProviderSetting,
        model: Model,
        initialHistory: [OpenAIMessage] = [],
        onEvent: @escaping (AgentEvent) -> Void
    ) {
        self.client = client
        self.toolExecutor = toolExecutor
        self.providerSetting = providerSetting
        self.model = model
        self.history = initialHistory
        self.onEvent = onEvent
    }
    
    public func run(prompt: String) async throws -> String {
        onEvent(.runStarted(initialImages: 0, toolCount: 0, terminalTools: true)) // Placeholder stats
        
        var currentPrompt = prompt
        var finalResponse = ""
        
        // Loop up to max turns to prevent infinite loops
        for turn in 1...10 {
            onEvent(.roundStarted)
            onEvent(.providerRequestStarted)
            
            do {
                let stream = try await client.complete(
                    prompt: currentPrompt,
                    history: history,
                    model: model,
                    setting: providerSetting
                )
                
                onEvent(.providerResponseStarted)
                onEvent(.assistantBlockStart(kind: "text"))
                
                var assistantContent = ""
                for try await delta in stream {
                    assistantContent += delta
                    onEvent(.assistantBlockDelta(text: delta))
                }
                
                onEvent(.assistantBlockEnd)
                
                // Add the interaction to history
                history.append(OpenAIMessage(role: "user", content: currentPrompt))
                history.append(OpenAIMessage(role: "assistant", content: assistantContent))
                
                // Simplified Tool Call Detection
                // In a real implementation we would parse the JSON structure or specific tags
                if let toolMatch = extractToolCall(from: assistantContent) {
                    onEvent(.toolStarted(id: "call_1", name: toolMatch.name, arguments: toolMatch.args))
                    
                    // Execute Tool
                    let result = try await toolExecutor.execute(toolName: toolMatch.name, arguments: ["command": toolMatch.args])
                    
                    onEvent(.toolFinished(id: "call_1", result: result))
                    
                    // Prepare next prompt with tool result
                    currentPrompt = "Tool result: \(result)"
                } else {
                    // No tools called, loop finishes
                    finalResponse = assistantContent
                    break
                }
                
            } catch {
                onEvent(.runFailed(error: error.localizedDescription))
                throw error
            }
        }
        
        onEvent(.runFinished)
        return finalResponse
    }
    
    private func extractToolCall(from text: String) -> (name: String, args: String)? {
        // Very basic stub: if model outputs "TOOL: name ARGS: text"
        if text.contains("TOOL: tool_run_command") {
            return ("tool_run_command", "ls -la") // Hardcoded for demonstration
        }
        return nil
    }
}

