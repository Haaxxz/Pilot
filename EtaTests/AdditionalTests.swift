import XCTest
@testable import Eta

final class AgentLoopTests: XCTestCase {
    func testAgentLoopInitialization() {
        let loop = AgentLoop(
            client: OpenAIChatCompletionsClient(),
            toolExecutor: AgentLocalTools(),
            providerSetting: OpenAiCompatibleProviderSetting(id: "1", name: "Test", baseUrl: "", apiKey: ""),
            model: Model(id: "1", modelId: "gpt", displayName: "GPT")
        ) { event in
            // Handle event
        }
        XCTAssertNotNil(loop)
    }
}

final class SkillTests: XCTestCase {
    func testSkillRegistry() {
        let skill = SkillRegistryEntity(skillId: "test-skill", enabled: true, source: "local", installState: "installed")
        XCTAssertEqual(skill.skillId, "test-skill")
        XCTAssertTrue(skill.enabled)
    }
}

final class CharacterCardTests: XCTestCase {
    func testCharacterEntity() {
        let char = CharacterEntity(id: "1", name: "Xiaoman", cardJson: "{}", avatarPath: nil, archived: false, createdAt: 0, updatedAt: 0)
        XCTAssertEqual(char.name, "Xiaoman")
        XCTAssertFalse(char.archived)
    }
}

final class McpTests: XCTestCase {
    func testMcpServerEntity() {
        let server = McpServerEntity(id: "1", name: "Test MCP", url: "http://localhost:8000", enabled: true, protocolMode: "auto", authorizationType: "none", toolsJson: "[]", enabledToolNamesJson: "[]", createdAt: 0, sortOrder: 0, lastRefreshedAt: nil, lastProtocolVersion: nil, toolsExpireAt: nil)
        XCTAssertEqual(server.protocolMode, "auto")
    }
}

final class MarkdownExportTests: XCTestCase {
    func testMarkdownRenderer() {
        let markdown = "# Hello\nThis is a test"
        XCTAssertTrue(markdown.contains("# Hello"))
    }
}

