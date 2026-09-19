import Foundation

public enum ReasoningEffort: String, Codable, CaseIterable {
    case off = "off"
    case `default` = "default"
    case minimal = "minimal"
    case low = "low"
    case medium = "medium"
    case high = "high"
    case xhigh = "xhigh"
    case max = "max"
    
    public var rank: Int {
        switch self {
        case .off: return 0
        case .default: return 1
        case .minimal: return 2
        case .low: return 3
        case .medium: return 4
        case .high: return 5
        case .xhigh: return 6
        case .max: return 7
        }
    }
    
    public var displayName: String {
        switch self {
        case .off: return "Off"
        case .default: return "Default"
        case .minimal: return "Minimal"
        case .low: return "Low"
        case .medium: return "Medium"
        case .high: return "High"
        case .xhigh: return "XHigh"
        case .max: return "Max"
        }
    }
    
    public var enablesReasoning: Bool {
        return self != .off
    }
    
    public static func fromLegacy(thinkingEnabled: Bool) -> ReasoningEffort {
        return thinkingEnabled ? .default : .off
    }
}

public struct ModelReasoningCapabilities: Codable {
    public var supportedEfforts: [ReasoningEffort] = []
    public var defaultEffort: ReasoningEffort? = nil
    public var defaultEnabled: Bool? = nil
    public var mandatory: Bool = false
    public var canDisable: Bool = false
    public var supportsBudget: Bool = false
    public var maxBudgetTokens: Int? = nil
    public var supportsMaxTokens: Bool? = nil
    
    public var selectableEfforts: [ReasoningEffort] {
        var efforts: [ReasoningEffort] = []
        if canDisable && !mandatory {
            efforts.append(.off)
        }
        efforts.append(.default)
        
        let distinctSupported = Array(Set(supportedEfforts.filter { $0 != .off && $0 != .default }))
            .sorted { $0.rank < $1.rank }
        
        efforts.append(contentsOf: distinctSupported)
        return efforts
    }
}

