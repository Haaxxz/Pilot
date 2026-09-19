import Foundation
import GRDB

public struct ProviderEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "model_providers"
    
    public var id: String
    public var type: String
    public var name: String
    public var baseUrl: String
    public var apiKey: String
    public var isEnabled: Bool
    public var isBuiltIn: Bool
    public var sortOrder: Int
    public var systemPrompt: String?
    public var customHeadersJson: String
    public var customBodyJson: String
    public var createdAt: Int64
    public var endpointMode: String
    public var hostedWebSearchEnabled: Bool
    public var anthropicVersion: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case type
        case name
        case baseUrl = "base_url"
        case apiKey = "api_key"
        case isEnabled = "is_enabled"
        case isBuiltIn = "is_built_in"
        case sortOrder = "sort_order"
        case systemPrompt = "system_prompt"
        case customHeadersJson = "custom_headers_json"
        case customBodyJson = "custom_body_json"
        case createdAt = "created_at"
        case endpointMode = "endpoint_mode"
        case hostedWebSearchEnabled = "hosted_web_search_enabled"
        case anthropicVersion = "anthropic_version"
    }
}

public struct ProviderModelEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "provider_models"
    
    public var id: String
    public var providerId: String
    public var modelId: String
    public var displayName: String
    public var isEnabled: Bool
    public var isBuiltIn: Bool
    public var sortOrder: Int
    public var ownedBy: String?
    public var contextWindow: Int?
    public var contextWindowOverride: Int?
    public var inputModalitiesJson: String
    public var outputModalitiesJson: String
    public var attachment: Bool?
    public var toolCall: Bool?
    public var reasoning: Bool?
    public var reasoningCapabilitiesJson: String
    public var reasoningOverride: Bool?
    public var reasoningCapabilitiesOverrideJson: String
    public var structuredOutput: Bool?
    public var supportsTemperature: Bool?
    public var customHeadersJson: String
    public var customBodyJson: String
    public var source: String
    public var createdAt: Int64
    
    enum CodingKeys: String, CodingKey {
        case id
        case providerId = "provider_id"
        case modelId = "model_id"
        case displayName = "display_name"
        case isEnabled = "is_enabled"
        case isBuiltIn = "is_built_in"
        case sortOrder = "sort_order"
        case ownedBy = "owned_by"
        case contextWindow = "context_window"
        case contextWindowOverride = "context_window_override"
        case inputModalitiesJson = "input_modalities_json"
        case outputModalitiesJson = "output_modalities_json"
        case attachment
        case toolCall = "tool_call"
        case reasoning
        case reasoningCapabilitiesJson = "reasoning_capabilities_json"
        case reasoningOverride = "reasoning_override"
        case reasoningCapabilitiesOverrideJson = "reasoning_capabilities_override_json"
        case structuredOutput = "structured_output"
        case supportsTemperature = "supports_temperature"
        case customHeadersJson = "custom_headers_json"
        case customBodyJson = "custom_body_json"
        case source
        case createdAt = "created_at"
    }
}

