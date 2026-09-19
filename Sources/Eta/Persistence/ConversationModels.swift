import Foundation
import GRDB

public struct ConversationEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "conversations"
    
    public var id: String
    public var title: String
    public var thinkingEnabled: Bool
    public var reasoningEffort: String
    public var historyJson: String
    public var appliedRuntimeRunIdsJson: String
    public var roleplayJson: String
    public var revisionsJson: String
    public var createdAt: Int64
    public var updatedAt: Int64
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case thinkingEnabled = "thinking_enabled"
        case reasoningEffort = "reasoning_effort"
        case historyJson = "history_json"
        case appliedRuntimeRunIdsJson = "applied_runtime_run_ids_json"
        case roleplayJson = "roleplay_json"
        case revisionsJson = "revisions_json"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

public struct ConversationMessageEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "conversation_messages"
    
    public var id: String
    public var conversationId: String
    public var sortIndex: Int
    public var type: String
    public var content: String
    public var imagesJson: String
    public var isEdited: Bool
    public var renderMarkdown: Bool?
    public var contextTokens: Int?
    public var inputTokens: Int?
    public var outputTokens: Int?
    public var reasoningTokens: Int?
    public var cachedTokens: Int?
    public var elapsedSeconds: Int?
    public var toolName: String?
    public var toolStatus: String?
    public var argumentsSummary: String?
    public var resultSummary: String?
    public var imageCount: Int
    public var toolsJson: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case conversationId = "conversation_id"
        case sortIndex = "sort_index"
        case type
        case content
        case imagesJson = "images_json"
        case isEdited = "is_edited"
        case renderMarkdown = "render_markdown"
        case contextTokens = "context_tokens"
        case inputTokens = "input_tokens"
        case outputTokens = "output_tokens"
        case reasoningTokens = "reasoning_tokens"
        case cachedTokens = "cached_tokens"
        case elapsedSeconds = "elapsed_seconds"
        case toolName = "tool_name"
        case toolStatus = "tool_status"
        case argumentsSummary = "arguments_summary"
        case resultSummary = "result_summary"
        case imageCount = "image_count"
        case toolsJson = "tools_json"
    }
}

