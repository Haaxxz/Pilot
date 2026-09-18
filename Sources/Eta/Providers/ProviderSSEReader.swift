import Foundation

public struct ServerSentEvent {
    public let event: String?
    public let data: String
    public let id: String?
    public let retry: Int?
}

public class ProviderSSEReader {
    private var buffer = ""
    private var currentEvent: String?
    private var currentData = ""
    private var currentId: String?
    private var currentRetry: Int?
    
    public init() {}
    
    /// Process a new chunk of data and return any complete SSE events found
    public func processChunk(_ data: Data) -> [ServerSentEvent] {
        guard let chunkString = String(data: data, encoding: .utf8) else {
            return []
        }
        
        buffer += chunkString
        var events: [ServerSentEvent] = []
        
        while let range = buffer.range(of: "\n\n") {
            let rawEvent = String(buffer[..<range.lowerBound])
            buffer = String(buffer[range.upperBound...])
            
            if let event = parseEvent(rawEvent) {
                events.append(event)
            }
        }
        
        return events
    }
    
    private func parseEvent(_ rawEvent: String) -> ServerSentEvent? {
        let lines = rawEvent.components(separatedBy: "\n")
        var hasData = false
        
        currentData = ""
        currentEvent = nil
        currentId = nil
        currentRetry = nil
        
        for line in lines {
            if line.hasPrefix(":") { continue } // Comment line
            
            if let colonIndex = line.firstIndex(of: ":") {
                let field = String(line[..<colonIndex])
                let valueIndex = line.index(after: colonIndex)
                let rawValue = String(line[valueIndex...])
                
                // SSE Spec: If value starts with a space, remove it
                let value = rawValue.hasPrefix(" ") ? String(rawValue.dropFirst()) : rawValue
                
                switch field {
                case "event":
                    currentEvent = value
                case "data":
                    if hasData {
                        currentData += "\n"
                    }
                    currentData += value
                    hasData = true
                case "id":
                    currentId = value
                case "retry":
                    if let retryValue = Int(value) {
                        currentRetry = retryValue
                    }
                default:
                    break // Ignore unknown fields
                }
            } else if !line.isEmpty {
                // Field name only (empty value)
                let field = line
                if field == "data" {
                    if hasData {
                        currentData += "\n"
                    }
                    hasData = true
                }
            }
        }
        
        if hasData {
            return ServerSentEvent(
                event: currentEvent,
                data: currentData,
                id: currentId,
                retry: currentRetry
            )
        }
        
        return nil
    }
}

