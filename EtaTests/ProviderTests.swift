import XCTest
@testable import Eta

final class ProviderTests: XCTestCase {
    
    func testOpenAIRequestSerialization() throws {
        let request = OpenAIRequest(
            model: "gpt-4",
            messages: [OpenAIMessage(role: "user", content: "Hello")],
            temperature: 0.7,
            stream: true,
            maxTokens: nil
        )
        
        let encoder = JSONEncoder()
        let data = try encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        
        XCTAssertEqual(json["model"] as? String, "gpt-4")
        XCTAssertEqual(json["stream"] as? Bool, true)
        XCTAssertEqual(json["temperature"] as? Double, 0.7)
    }
    
    func testSSEReader() throws {
        let reader = ProviderSSEReader()
        let chunk1 = "data: {\"test\": 1}\n\n".data(using: .utf8)!
        let events = reader.processChunk(chunk1)
        
        XCTAssertEqual(events.count, 1)
        XCTAssertEqual(events[0].data, "{\"test\": 1}")
    }
    
    func testReasoningEffort() throws {
        let defaultEffort = ReasoningEffort.default
        XCTAssertEqual(defaultEffort.rank, 1)
        XCTAssertEqual(defaultEffort.enablesReasoning, true)
        
        let offEffort = ReasoningEffort.off
        XCTAssertEqual(offEffort.enablesReasoning, false)
    }
}

