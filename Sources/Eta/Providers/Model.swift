import Foundation

public enum ModelSource: String, Codable {
    case manual = "manual"
    case remote = "remote"
    case catalog = "catalog"
}

public struct Model: Codable {
    public static let textModality = "text"
    
    public var id: String
    public var modelId: String
    public var displayName: String
    public var ownedBy: String?
    public var isEnabled: Bool = true
    public var isBuiltIn: Bool = false
    public var sortOrder: Int = 0
    public var contextWindow: Int?
    public var contextWindowOverride: Int?
    public var inputModalities: [String] = [textModality]
    public var outputModalities: [String] = [textModality]
    public var attachment: Bool?
    public var toolCall: Bool?
    public var reasoning: Bool?
    public var reasoningCapabilities: ModelReasoningCapabilities?
    public var reasoningOverride: Bool?
    public var reasoningCapabilitiesOverride: ModelReasoningCapabilities?
    public var structuredOutput: Bool?
    public var supportsTemperature: Bool?
    public var customHeaders: [CustomHeader] = []
    public var customBody: [CustomBody] = []
    public var source: ModelSource = .manual
    public var createdAt: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    
    public init(id: String, modelId: String, displayName: String) {
        self.id = id
        self.modelId = modelId
        self.displayName = displayName
    }
}

