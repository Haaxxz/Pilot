import Foundation
import UIKit

public class AgentLocalTools: ToolExecutor {
    public init() {}
    
    public func execute(toolName: String, arguments: [String: Any]) async throws -> String {
        switch toolName {
        case "tool_get_clipboard":
            return await MainActor.run {
                if let text = UIPasteboard.general.string {
                    return "Clipboard content:\n\(text)"
                }
                return "Clipboard is empty or does not contain text."
            }
            
        case "tool_set_clipboard":
            guard let text = arguments["text"] as? String else {
                return "Error: missing 'text' argument"
            }
            await MainActor.run {
                UIPasteboard.general.string = text
            }
            return "Successfully copied to clipboard."
            
        case "tool_set_alarm":
            // iOS implementation would use EventKit or URL Schemes to Clock app
            guard let hour = arguments["hour"] as? Int,
                  let minute = arguments["minute"] as? Int else {
                return "Error: missing 'hour' or 'minute' arguments"
            }
            return "Simulated: Alarm set for \(String(format: "%02d:%02d", hour, minute)) on iOS."
            
        case "tool_run_command":
            guard let command = arguments["command"] as? String else {
                return "Error: missing 'command' argument"
            }
            return "Executed in sandbox: \(command)\n(Note: PRoot is unavailable on iOS)"
            
        default:
            return "Tool \(toolName) is not supported on iOS or not implemented yet."
        }
    }
}

