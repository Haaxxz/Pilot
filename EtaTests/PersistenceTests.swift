import XCTest
import GRDB
@testable import Eta

final class PersistenceTests: XCTestCase {
    
    var dbQueue: DatabaseQueue!
    
    override func setUpWithError() throws {
        dbQueue = try DatabaseQueue()
        // Initialize schema using in-memory DB
        var configuration = Configuration()
        let migrator = Database.shared.migrator // Note: Need to expose migrator or extract it
        // For testing we will simulate table creation
        try dbQueue.write { db in
            try db.create(table: "conversations") { t in
                t.column("id", .text).primaryKey()
                t.column("title", .text).notNull()
                t.column("thinking_enabled", .boolean).notNull()
                t.column("reasoning_effort", .text).notNull()
                t.column("history_json", .text).notNull()
                t.column("applied_runtime_run_ids_json", .text).notNull()
                t.column("roleplay_json", .text).notNull()
                t.column("revisions_json", .text).notNull()
                t.column("created_at", .integer).notNull()
                t.column("updated_at", .integer).notNull()
            }
        }
    }
    
    func testConversationInsert() throws {
        try dbQueue.write { db in
            var conv = ConversationEntity(
                id: "test1",
                title: "Test Chat",
                thinkingEnabled: true,
                reasoningEffort: "default",
                historyJson: "[]",
                appliedRuntimeRunIdsJson: "[]",
                roleplayJson: "{}",
                revisionsJson: "{}",
                createdAt: 0,
                updatedAt: 0
            )
            try conv.insert(db)
            
            let fetched = try ConversationEntity.fetchOne(db, key: "test1")
            XCTAssertNotNil(fetched)
            XCTAssertEqual(fetched?.title, "Test Chat")
        }
    }
}

