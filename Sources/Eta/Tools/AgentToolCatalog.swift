import Foundation

public struct ToolDefinition: Codable {
    public let type: String = "function"
    public let function: FunctionDefinition
    
    public struct FunctionDefinition: Codable {
        public let name: String
        public let description: String
        public let parameters: Parameters
    }
    
    public struct Parameters: Codable {
        public let type: String = "object"
        public let properties: [String: Property]
        public let required: [String]?
    }
    
    public struct Property: Codable {
        public let type: String
        public let description: String?
        public let `enum`: [String]?
        public let items: [String: String]? // Simplified for Array type
    }
}

public protocol ToolExecutor {
    func execute(toolName: String, arguments: [String: Any]) async throws -> String
}

public class AgentToolCatalog {
    public static func build(
        terminalTools: Bool,
        browserTools: Bool,
        deviceDirectTools: Bool,
        deviceSensitiveReadTools: Bool,
        deviceSensitiveActionTools: Bool,
        skillGitHubDiscovery: Bool,
        skillGitHubInstall: Bool,
        memoryTools: Bool,
        memoryWritable: Bool
    ) -> [ToolDefinition] {
        var tools: [ToolDefinition] = []
        
        // Base Device Tools (Alarms, Clipboard, etc.)
        if deviceDirectTools {
            tools.append(contentsOf: AgentDeviceToolCatalog.build())
        }
        
        if browserTools {
            tools.append(contentsOf: AgentBrowserToolCatalog.build())
        }
        
        if terminalTools {
            tools.append(contentsOf: AgentTerminalToolCatalog.build())
        }
        
        if memoryTools {
            tools.append(contentsOf: AgentMemoryToolCatalog.build(writable: memoryWritable))
        }
        
        // Add more tools based on config
        
        return tools
    }
}

public class AgentDeviceToolCatalog {
    public static func build() -> [ToolDefinition] {
        return [
            ToolDefinition(
                function: .init(
                    name: "tool_get_clipboard",
                    description: "Get current text from system clipboard.",
                    parameters: .init(properties: [:], required: [])
                )
            ),
            ToolDefinition(
                function: .init(
                    name: "tool_set_clipboard",
                    description: "Set text to system clipboard.",
                    parameters: .init(
                        properties: [
                            "text": .init(type: "string", description: "Text to copy", enum: nil, items: nil)
                        ],
                        required: ["text"]
                    )
                )
            ),
            ToolDefinition(
                function: .init(
                    name: "tool_set_alarm",
                    description: "Set an alarm. (Uses EventKit/Shortcuts on iOS)",
                    parameters: .init(
                        properties: [
                            "hour": .init(type: "integer", description: "0-23", enum: nil, items: nil),
                            "minute": .init(type: "integer", description: "0-59", enum: nil, items: nil)
                        ],
                        required: ["hour", "minute"]
                    )
                )
            )
        ]
    }
}

public class AgentBrowserToolCatalog {
    public static func build() -> [ToolDefinition] {
        return [
            ToolDefinition(
                function: .init(
                    name: "tool_browser_use",
                    description: "Interact with a WKWebView browser session.",
                    parameters: .init(
                        properties: [
                            "action": .init(type: "string", description: "navigate, click, type, scroll, extract", enum: ["navigate", "click", "type", "scroll", "extract"], items: nil),
                            "url": .init(type: "string", description: "URL to navigate to", enum: nil, items: nil),
                            "selector": .init(type: "string", description: "CSS selector", enum: nil, items: nil),
                            "text": .init(type: "string", description: "Text to type", enum: nil, items: nil)
                        ],
                        required: ["action"]
                    )
                )
            )
        ]
    }
}

public class AgentTerminalToolCatalog {
    public static func build() -> [ToolDefinition] {
        return [
            ToolDefinition(
                function: .init(
                    name: "tool_run_command",
                    description: "Run a shell command in the app sandbox.",
                    parameters: .init(
                        properties: [
                            "command": .init(type: "string", description: "Command to run", enum: nil, items: nil)
                        ],
                        required: ["command"]
                    )
                )
            )
        ]
    }
}

public class AgentMemoryToolCatalog {
    public static func build(writable: Bool) -> [ToolDefinition] {
        return [
            ToolDefinition(
                function: .init(
                    name: "tool_memory_get",
                    description: "Retrieve items from agent memory.",
                    parameters: .init(
                        properties: [
                            "query": .init(type: "string", description: "Search query", enum: nil, items: nil)
                        ],
                        required: ["query"]
                    )
                )
            )
        ] // In reality we add tool_memory_write if writable
    }
}

