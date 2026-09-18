import Foundation
import GRDB

public final class Database {
    public static let shared = Database()
    public var dbPool: DatabasePool!

    private init() {}

    public func setup(databaseURL: URL) throws {
        var configuration = Configuration()
        configuration.prepareDatabase { db in
            try db.execute(sql: "PRAGMA journal_mode = WAL")
            try db.execute(sql: "PRAGMA synchronous = NORMAL")
        }
        
        dbPool = try DatabasePool(path: databaseURL.path, configuration: configuration)
        try migrator.migrate(dbPool)
    }

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("v1") { db in
            // Agent Text Chunks
            try db.create(table: "agent_text_chunks") { t in
                t.column("owner_table", .text).notNull()
                t.column("owner_id", .text).notNull()
                t.column("field", .text).notNull()
                t.column("chunk_index", .integer).notNull()
                t.column("content", .text).notNull()
                t.primaryKey(["owner_table", "owner_id", "field", "chunk_index"])
            }

            // Conversations
            try db.create(table: "conversations") { t in
                t.column("id", .text).primaryKey()
                t.column("title", .text).notNull()
                t.column("thinking_enabled", .boolean).notNull()
                t.column("reasoning_effort", .text).notNull().defaults(to: "default")
                t.column("history_json", .text).notNull().defaults(to: "[]")
                t.column("applied_runtime_run_ids_json", .text).notNull().defaults(to: "[]")
                t.column("roleplay_json", .text).notNull().defaults(to: "")
                t.column("revisions_json", .text).notNull().defaults(to: "")
                t.column("created_at", .integer).notNull()
                t.column("updated_at", .integer).notNull()
            }

            // Conversation Context Checkpoints
            try db.create(table: "conversation_context_checkpoints") { t in
                t.column("conversation_id", .text).primaryKey().references("conversations", onDelete: .cascade)
                t.column("history_json", .text).notNull()
                t.column("journal_json", .text).notNull().defaults(to: "")
            }

            // Conversation Messages
            try db.create(table: "conversation_messages") { t in
                t.column("id", .text).primaryKey()
                t.column("conversation_id", .text).notNull().references("conversations", onDelete: .cascade)
                t.column("sort_index", .integer).notNull()
                t.column("type", .text).notNull()
                t.column("content", .text).notNull()
                t.column("images_json", .text).notNull().defaults(to: "[]")
                t.column("is_edited", .boolean).notNull().defaults(to: false)
                t.column("render_markdown", .boolean)
                t.column("context_tokens", .integer)
                t.column("input_tokens", .integer)
                t.column("output_tokens", .integer)
                t.column("reasoning_tokens", .integer)
                t.column("cached_tokens", .integer)
                t.column("elapsed_seconds", .integer)
                t.column("tool_name", .text)
                t.column("tool_status", .text)
                t.column("arguments_summary", .text)
                t.column("result_summary", .text)
                t.column("image_count", .integer).notNull().defaults(to: 0)
                t.column("tools_json", .text).notNull().defaults(to: "[]")
            }
            try db.create(index: "index_conversation_messages_conversation_id", on: "conversation_messages", columns: ["conversation_id"])
            try db.create(index: "index_conversation_messages_unique", on: "conversation_messages", columns: ["conversation_id", "sort_index"], unique: true)

            // Conversation State
            try db.create(table: "conversation_state") { t in
                t.column("id", .text).primaryKey()
                t.column("selected_conversation_id", .text)
            }

            // Model Providers
            try db.create(table: "model_providers") { t in
                t.column("id", .text).primaryKey()
                t.column("type", .text).notNull()
                t.column("name", .text).notNull()
                t.column("base_url", .text).notNull()
                t.column("api_key", .text).notNull()
                t.column("is_enabled", .boolean).notNull()
                t.column("is_built_in", .boolean).notNull()
                t.column("sort_order", .integer).notNull()
                t.column("system_prompt", .text)
                t.column("custom_headers_json", .text).notNull()
                t.column("custom_body_json", .text).notNull()
                t.column("created_at", .integer).notNull()
                t.column("endpoint_mode", .text).notNull()
                t.column("hosted_web_search_enabled", .boolean).notNull().defaults(to: false)
                t.column("anthropic_version", .text).notNull()
            }

            // Provider Models
            try db.create(table: "provider_models") { t in
                t.column("id", .text).primaryKey()
                t.column("provider_id", .text).notNull().references("model_providers", onDelete: .cascade)
                t.column("model_id", .text).notNull()
                t.column("display_name", .text).notNull()
                t.column("is_enabled", .boolean).notNull()
                t.column("is_built_in", .boolean).notNull()
                t.column("sort_order", .integer).notNull()
                t.column("owned_by", .text)
                t.column("context_window", .integer)
                t.column("context_window_override", .integer)
                t.column("input_modalities_json", .text).notNull()
                t.column("output_modalities_json", .text).notNull()
                t.column("attachment", .boolean)
                t.column("tool_call", .boolean)
                t.column("reasoning", .boolean)
                t.column("reasoning_capabilities_json", .text).notNull().defaults(to: "'null'")
                t.column("reasoning_override", .boolean)
                t.column("reasoning_capabilities_override_json", .text).notNull().defaults(to: "'null'")
                t.column("structured_output", .boolean)
                t.column("supports_temperature", .boolean)
                t.column("custom_headers_json", .text).notNull()
                t.column("custom_body_json", .text).notNull()
                t.column("source", .text).notNull()
                t.column("created_at", .integer).notNull()
            }
            try db.create(index: "index_provider_models_provider_id", on: "provider_models", columns: ["provider_id"])
            try db.create(index: "index_provider_models_sort", on: "provider_models", columns: ["provider_id", "sort_order"])

            // MCP Servers
            try db.create(table: "mcp_servers") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("url", .text).notNull()
                t.column("enabled", .boolean).notNull()
                t.column("protocol_mode", .text).notNull()
                t.column("authorization_type", .text).notNull()
                t.column("tools_json", .text).notNull()
                t.column("enabled_tool_names_json", .text).notNull()
                t.column("created_at", .integer).notNull()
                t.column("sort_order", .integer).notNull()
                t.column("last_refreshed_at", .integer)
                t.column("last_protocol_version", .text)
                t.column("tools_expire_at", .integer)
            }

            // Runtime Results
            try db.create(table: "runtime_results") { t in
                t.column("run_id", .text).primaryKey()
                t.column("handoff_id", .text).notNull()
                t.column("handoff_source", .text).notNull()
                t.column("handoff_payload", .text).notNull()
                t.column("dismiss_entry_surface", .boolean).notNull()
                t.column("ok", .boolean).notNull()
                t.column("content", .text).notNull()
                t.column("error", .text)
                t.column("reasoning_content", .text).notNull()
                t.column("transcript_json", .text).notNull()
                t.column("context_snapshot_json", .text).notNull().defaults(to: "")
                t.column("operation", .text).notNull().defaults(to: "chat")
                t.column("rewrite_target_message_id", .text)
                t.column("created_at", .integer).notNull()
            }

            // Runtime Archive Runs
            try db.create(table: "runtime_archive_runs") { t in
                t.column("archive_run_id", .text).primaryKey()
                t.column("run_id", .text).notNull()
                t.column("user_image_previews_json", .text).notNull().defaults(to: "[]")
                t.column("handoff_id", .text).notNull()
                t.column("handoff_source", .text).notNull()
                t.column("handoff_payload", .text).notNull()
                t.column("dismiss_entry_surface", .boolean).notNull()
                t.column("ok", .boolean).notNull()
                t.column("content", .text).notNull()
                t.column("error", .text)
                t.column("reasoning_content", .text).notNull()
                t.column("transcript_json", .text).notNull()
                t.column("context_snapshot_json", .text).notNull().defaults(to: "")
                t.column("operation", .text).notNull().defaults(to: "chat")
                t.column("rewrite_target_message_id", .text)
                t.column("created_at", .integer).notNull()
            }

            // Runtime Archive Events
            try db.create(table: "runtime_archive_events") { t in
                t.column("id", .integer).primaryKey(autoincrement: true)
                t.column("archive_run_id", .text).notNull().references("runtime_archive_runs", onDelete: .cascade)
                t.column("sort_index", .integer).notNull()
                t.column("event_json", .text).notNull()
            }
            try db.create(index: "index_runtime_archive_events_unique", on: "runtime_archive_events", columns: ["archive_run_id", "sort_index"], unique: true)

            // Runtime Inflight Runs
            try db.create(table: "runtime_inflight_runs") { t in
                t.column("run_id", .text).primaryKey()
                t.column("owner_instance_id", .text).notNull()
                t.column("handoff_id", .text).notNull()
                t.column("handoff_source", .text).notNull()
                t.column("handoff_payload", .text).notNull()
                t.column("dismiss_entry_surface", .boolean).notNull()
                t.column("transcript_json", .text).notNull().defaults(to: "[]")
                t.column("context_snapshot_json", .text).notNull().defaults(to: "")
                t.column("operation", .text).notNull().defaults(to: "chat")
                t.column("rewrite_target_message_id", .text)
                t.column("created_at", .integer).notNull()
                t.column("updated_at", .integer).notNull()
            }

            // Runtime Inflight Events
            try db.create(table: "runtime_inflight_events") { t in
                t.column("id", .integer).primaryKey(autoincrement: true)
                t.column("run_id", .text).notNull().references("runtime_inflight_runs", onDelete: .cascade)
                t.column("sort_index", .integer).notNull()
                t.column("event_json", .text).notNull()
            }
            try db.create(index: "index_runtime_inflight_events_unique", on: "runtime_inflight_events", columns: ["run_id", "sort_index"], unique: true)

            // Skill Registry
            try db.create(table: "skill_registry") { t in
                t.column("skill_id", .text).primaryKey()
                t.column("enabled", .boolean).notNull()
                t.column("source", .text).notNull()
                t.column("install_state", .text).notNull()
            }

            // Roleplay Characters
            try db.create(table: "roleplay_characters") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("card_json", .text).notNull()
                t.column("avatar_path", .text)
                t.column("archived", .boolean).notNull().defaults(to: false)
                t.column("created_at", .integer).notNull()
                t.column("updated_at", .integer).notNull()
            }

            // Roleplay User Persona
            try db.create(table: "roleplay_user_persona") { t in
                t.column("id", .text).primaryKey()
                t.column("name", .text).notNull()
                t.column("description", .text).notNull()
            }
            
            // Set up text chunk cleanup triggers
            let chunkTables = [
                ("runtime_results", "run_id"),
                ("runtime_archive_runs", "archive_run_id"),
                ("runtime_inflight_runs", "run_id"),
                ("conversation_context_checkpoints", "conversation_id"),
                ("conversation_messages", "id"),
                ("conversations", "id"),
                ("roleplay_characters", "id"),
                ("roleplay_user_persona", "id")
            ]
            
            for (table, key) in chunkTables {
                try db.execute(sql: """
                CREATE TRIGGER IF NOT EXISTS \(table)_text_cleanup AFTER DELETE ON \(table)
                BEGIN DELETE FROM agent_text_chunks WHERE owner_table = '\(table)' AND owner_id = OLD.\(key); END
                """)
            }
        }

        return migrator
    }
}

