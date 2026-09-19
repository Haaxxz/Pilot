import Foundation
import GRDB

public struct SkillRegistryEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "skill_registry"
    
    public var skillId: String
    public var enabled: Bool
    public var source: String
    public var installState: String
    
    enum CodingKeys: String, CodingKey {
        case skillId = "skill_id"
        case enabled
        case source
        case installState = "install_state"
    }
}

public struct McpServerEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "mcp_servers"
    
    public var id: String
    public var name: String
    public var url: String
    public var enabled: Bool
    public var protocolMode: String
    public var authorizationType: String
    public var toolsJson: String
    public var enabledToolNamesJson: String
    public var createdAt: Int64
    public var sortOrder: Int
    public var lastRefreshedAt: Int64?
    public var lastProtocolVersion: String?
    public var toolsExpireAt: Int64?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case url
        case enabled
        case protocolMode = "protocol_mode"
        case authorizationType = "authorization_type"
        case toolsJson = "tools_json"
        case enabledToolNamesJson = "enabled_tool_names_json"
        case createdAt = "created_at"
        case sortOrder = "sort_order"
        case lastRefreshedAt = "last_refreshed_at"
        case lastProtocolVersion = "last_protocol_version"
        case toolsExpireAt = "tools_expire_at"
    }
}

public struct CharacterEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "roleplay_characters"
    
    public var id: String
    public var name: String
    public var cardJson: String
    public var avatarPath: String?
    public var archived: Bool
    public var createdAt: Int64
    public var updatedAt: Int64
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case cardJson = "card_json"
        case avatarPath = "avatar_path"
        case archived
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

