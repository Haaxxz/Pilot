import AppIntents
import Foundation

struct AskEtaIntent: AppIntent {
    static let title: LocalizedStringResource = "Ask Eta"
    static let description: IntentDescription = "Send a message to Eta and get a response."
    
    @Parameter(title: "Prompt", description: "What do you want to ask Eta?")
    var prompt: String
    
    @Parameter(title: "Thinking Effort", default: "default")
    var effort: String
    
    // To present UI or speak results, we return a snippet.
    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // In a real implementation, this would spin up the AgentLoop with the selected Model
        // and return the response. We simulate the delay and result for the intent here.
        
        // Let's pretend we query the local agent loop
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        let response = "I received your prompt: '\(prompt)'. This is a Siri shortcut response from Eta."
        
        return .result(dialog: IntentDialog(stringLiteral: response))
    }
}

struct EtaAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AskEtaIntent(),
            phrases: [
                "Ask \(.applicationName)",
                "Message \(.applicationName)",
                "Talk to \(.applicationName)"
            ],
            shortTitle: "Ask Eta",
            systemImageName: "sparkles"
        )
    }
}

