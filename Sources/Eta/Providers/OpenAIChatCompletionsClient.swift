import Foundation

public struct OpenAIRequest: Codable {
    public var model: String
    public var messages: [OpenAIMessage]
    public var temperature: Double?
    public var stream: Bool
    public var maxTokens: Int?
    // Tools and reasoning options omitted for brevity
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature, stream
        case maxTokens = "max_tokens"
    }
}

public struct OpenAIMessage: Codable {
    public var role: String
    public var content: String
    // We would use an enum/union for content to support images, but keeping simple for now
}

public protocol AgentProviderClient {
    func complete(
        prompt: String,
        history: [OpenAIMessage],
        model: Model,
        setting: ProviderSetting
    ) async throws -> AsyncThrowingStream<String, Error>
}

public class OpenAIChatCompletionsClient: AgentProviderClient {
    public init() {}
    
    public func complete(
        prompt: String,
        history: [OpenAIMessage],
        model: Model,
        setting: ProviderSetting
    ) async throws -> AsyncThrowingStream<String, Error> {
        
        var messages = history
        messages.append(OpenAIMessage(role: "user", content: prompt))
        
        let requestBody = OpenAIRequest(
            model: model.modelId,
            messages: messages,
            stream: true
        )
        
        let url = URL(string: setting.baseUrl)!.appendingPathComponent("chat/completions")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(setting.apiKey)", forHTTPHeaderField: "Authorization")
        
        // Add custom headers
        for customHeader in setting.customHeaders {
            request.addValue(customHeader.value, forHTTPHeaderField: customHeader.name)
        }
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        return AsyncThrowingStream { continuation in
            Task {
                do {
                    let (result, response) = try await URLSession.shared.bytes(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        continuation.finish(throwing: URLError(.badServerResponse))
                        return
                    }
                    
                    if !(200...299).contains(httpResponse.statusCode) {
                        // Gather error body
                        var errorBody = ""
                        for try await line in result.lines {
                            errorBody += line
                        }
                        continuation.finish(throwing: NSError(domain: "ProviderError", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorBody]))
                        return
                    }
                    
                    let reader = ProviderSSEReader()
                    
                    for try await byte in result {
                        let events = reader.processChunk(Data([byte]))
                        for event in events {
                            if event.data == "[DONE]" {
                                continuation.finish()
                                return
                            }
                            
                            // Naive extraction of choices[0].delta.content
                            // In real implementation we'd use JSONDecoder
                            if event.data.contains("\"content\":") {
                                // simplified extraction for demonstration
                                if let data = event.data.data(using: .utf8),
                                   let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                                   let choices = json["choices"] as? [[String: Any]],
                                   let delta = choices.first?["delta"] as? [String: Any],
                                   let content = delta["content"] as? String {
                                    continuation.yield(content)
                                }
                            }
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}

