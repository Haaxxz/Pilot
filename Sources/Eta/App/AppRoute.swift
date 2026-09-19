import Foundation

public enum AppRoute: Hashable {
    case home
    case chat
    case browser
    case terminal
    case tools
    case skills
    case characters
    case characterDetail(characterId: String)
    case characterEditor(characterId: String?)
    case characterPersona
    case characterMemory(characterId: String)
    case permissions
    case systemEnhance
    case settings
    case appearanceSettings
    case dataBackup
    case memory
    case linuxEnvironment
    case sharedFolders
    case workspace
    case linuxFiles(distribution: String)
    case modelProviders
    case modelProviderDetail(providerId: String)
    case modelProviderNew(providerType: String)
    case mcpServers
    case mcpServerDetail(serverId: String)
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .chat: return "Chat"
        case .browser: return "Browser"
        case .terminal: return "Terminal"
        case .tools: return "Tools"
        case .skills: return "Skills"
        case .characters: return "Characters"
        case .characterDetail: return "Character Details"
        case .characterEditor: return "Edit Character"
        case .characterPersona: return "User Persona"
        case .characterMemory: return "Character Memory"
        case .permissions: return "Permissions"
        case .systemEnhance: return "System Enhancements"
        case .settings: return "Settings"
        case .appearanceSettings: return "Appearance"
        case .dataBackup: return "Data Backup"
        case .memory: return "Agent Memory"
        case .linuxEnvironment: return "Linux Environment"
        case .sharedFolders: return "Shared Folders"
        case .workspace: return "Workspace"
        case .linuxFiles: return "Linux Files"
        case .modelProviders: return "Model Providers"
        case .modelProviderDetail: return "Provider Details"
        case .modelProviderNew: return "New Provider"
        case .mcpServers: return "MCP Servers"
        case .mcpServerDetail: return "MCP Server"
        }
    }
    
    var iconName: String {
        switch self {
        case .home: return "house"
        case .chat: return "bubble.left.and.bubble.right"
        case .browser: return "safari"
        case .terminal: return "terminal"
        case .tools: return "wrench.and.screwdriver"
        case .skills: return "puzzlepiece.extension"
        case .characters: return "person.2"
        case .permissions: return "lock.shield"
        case .systemEnhance: return "bolt.fill"
        case .settings: return "gearshape"
        case .memory: return "brain.head.profile"
        case .modelProviders: return "server.rack"
        case .mcpServers: return "network"
        default: return "circle"
        }
    }
}

