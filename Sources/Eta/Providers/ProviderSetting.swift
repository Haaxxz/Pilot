import Foundation

public enum ProviderType {
    public static let openaiCompatible = "openai_compatible"
    public static let anthropic = "anthropic"
    public static let custom = "custom"
}

public enum ProviderSourceType {
    public static let custom = "custom"
    public static let openai = "openai"
    public static let anthropic = "anthropic"
    public static let bailian = "bailian"
    public static let deepseek = "deepseek"
    public static let moonshot = "moonshot"
    public static let mimo = "mimo"
    public static let minimax = "minimax"
    public static let stepfun = "stepfun"
    public static let siliconflow = "siliconflow"
    public static let openrouter = "openrouter"
}

public enum OpenAiEndpointMode {
    public static let chatCompletions = "chat_completions"
    public static let responses = "responses"
}

public struct CustomHeader: Codable {
    public var name: String
    public var value: String
}

public struct CustomBody: Codable {
    public var key: String
    // Since we need to represent arbitrary JSON elements, we can use a wrapper or AnyCodable in Swift.
    // For simplicity, we use String here to represent serialized JSON if needed, or implement a custom AnyCodable.
    public var value: String
}

public protocol ProviderSetting: Codable {
    var id: String { get }
    var name: String { get }
    var baseUrl: String { get }
    var sourceType: String { get }
    var apiKey: String { get }
    var isEnabled: Bool { get }
    var isBuiltIn: Bool { get }
    var sortOrder: Int { get }
    var systemPrompt: String? { get }
    var customHeaders: [CustomHeader] { get }
    var customBody: [CustomBody] { get }
    var createdAt: Int64 { get }
    var hostedWebSearchEnabled: Bool { get }
}

public struct OpenAiCompatibleProviderSetting: ProviderSetting {
    public var id: String
    public var name: String
    public var baseUrl: String
    public var sourceType: String = ProviderSourceType.custom
    public var apiKey: String = ""
    public var isEnabled: Bool = true
    public var isBuiltIn: Bool = false
    public var sortOrder: Int = 0
    public var systemPrompt: String? = nil
    public var customHeaders: [CustomHeader] = []
    public var customBody: [CustomBody] = []
    public var createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    public var endpointMode: String = OpenAiEndpointMode.chatCompletions
    public var hostedWebSearchEnabled: Bool = false
}

public struct AnthropicProviderSetting: ProviderSetting {
    public static let defaultAnthropicVersion = "2023-06-01"
    
    public var id: String
    public var name: String
    public var baseUrl: String
    public var sourceType: String = ProviderSourceType.custom
    public var apiKey: String = ""
    public var isEnabled: Bool = true
    public var isBuiltIn: Bool = false
    public var sortOrder: Int = 0
    public var systemPrompt: String? = nil
    public var customHeaders: [CustomHeader] = []
    public var customBody: [CustomBody] = []
    public var createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    public var anthropicVersion: String = defaultAnthropicVersion
    public var hostedWebSearchEnabled: Bool = false
}

public struct CustomProviderSetting: ProviderSetting {
    public var id: String
    public var name: String
    public var baseUrl: String
    public var sourceType: String = ProviderSourceType.custom
    public var apiKey: String = ""
    public var isEnabled: Bool = true
    public var isBuiltIn: Bool = false
    public var sortOrder: Int = 0
    public var systemPrompt: String? = nil
    public var customHeaders: [CustomHeader] = []
    public var customBody: [CustomBody] = []
    public var createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    public var endpointMode: String = OpenAiEndpointMode.chatCompletions
    public var hostedWebSearchEnabled: Bool = false
}

