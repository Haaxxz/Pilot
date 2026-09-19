import Foundation
import GRDB

public struct RuntimeResultEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "runtime_results"
    
    public var runId: String
    public var handoffId: String
    public var handoffSource: String
    public var handoffPayload: String
    public var dismissEntrySurface: Bool
    public var ok: Bool
    public var content: String
    public var error: String?
    public var reasoningContent: String
    public var transcriptJson: String
    public var contextSnapshotJson: String
    public var operation: String
    public var rewriteTargetMessageId: String?
    public var createdAt: Int64
    
    enum CodingKeys: String, CodingKey {
        case runId = "run_id"
        case handoffId = "handoff_id"
        case handoffSource = "handoff_source"
        case handoffPayload = "handoff_payload"
        case dismissEntrySurface = "dismiss_entry_surface"
        case ok
        case content
        case error
        case reasoningContent = "reasoning_content"
        case transcriptJson = "transcript_json"
        case contextSnapshotJson = "context_snapshot_json"
        case operation
        case rewriteTargetMessageId = "rewrite_target_message_id"
        case createdAt = "created_at"
    }
}

public struct RuntimeArchiveRunEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "runtime_archive_runs"
    
    public var archiveRunId: String
    public var runId: String
    public var userImagePreviewsJson: String
    public var handoffId: String
    public var handoffSource: String
    public var handoffPayload: String
    public var dismissEntrySurface: Bool
    public var ok: Bool
    public var content: String
    public var error: String?
    public var reasoningContent: String
    public var transcriptJson: String
    public var contextSnapshotJson: String
    public var operation: String
    public var rewriteTargetMessageId: String?
    public var createdAt: Int64
    
    enum CodingKeys: String, CodingKey {
        case archiveRunId = "archive_run_id"
        case runId = "run_id"
        case userImagePreviewsJson = "user_image_previews_json"
        case handoffId = "handoff_id"
        case handoffSource = "handoff_source"
        case handoffPayload = "handoff_payload"
        case dismissEntrySurface = "dismiss_entry_surface"
        case ok
        case content
        case error
        case reasoningContent = "reasoning_content"
        case transcriptJson = "transcript_json"
        case contextSnapshotJson = "context_snapshot_json"
        case operation
        case rewriteTargetMessageId = "rewrite_target_message_id"
        case createdAt = "created_at"
    }
}

public struct RuntimeInFlightRunEntity: Codable, FetchableRecord, PersistableRecord {
    public static let databaseTableName = "runtime_inflight_runs"
    
    public var runId: String
    public var ownerInstanceId: String
    public var handoffId: String
    public var handoffSource: String
    public var handoffPayload: String
    public var dismissEntrySurface: Bool
    public var transcriptJson: String
    public var contextSnapshotJson: String
    public var operation: String
    public var rewriteTargetMessageId: String?
    public var createdAt: Int64
    public var updatedAt: Int64
    
    enum CodingKeys: String, CodingKey {
        case runId = "run_id"
        case ownerInstanceId = "owner_instance_id"
        case handoffId = "handoff_id"
        case handoffSource = "handoff_source"
        case handoffPayload = "handoff_payload"
        case dismissEntrySurface = "dismiss_entry_surface"
        case transcriptJson = "transcript_json"
        case contextSnapshotJson = "context_snapshot_json"
        case operation
        case rewriteTargetMessageId = "rewrite_target_message_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

