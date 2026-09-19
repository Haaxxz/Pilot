import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            NavigationStack(path: $appState.navigationPath) {
                Group {
                    switch appState.currentRoute {
                    case .home: HomeView()
                    case .chat: ChatView()
                    case .browser: BrowserView()
                    case .terminal: TerminalSessionView()
                    case .tools: ToolsView()
                    case .skills: SkillsView()
                    case .characters: CharactersView()
                    case .characterDetail(let id): CharacterDetailView(characterId: id)
                    case .characterEditor(let id): CharacterEditorView(characterId: id)
                    case .characterPersona: CharacterPersonaView()
                    case .characterMemory(let id): CharacterMemoryView(characterId: id)
                    case .permissions: PermissionsView()
                    case .systemEnhance: SystemEnhancementsView()
                    case .settings: SettingsView()
                    case .appearanceSettings: AppearanceSettingsView()
                    case .dataBackup: DataBackupView()
                    case .memory: MemoryView()
                    case .linuxEnvironment: LinuxEnvironmentView()
                    case .sharedFolders: SharedFoldersView()
                    case .workspace: WorkspaceView()
                    case .linuxFiles: LinuxFilesView()
                    case .modelProviders: ModelProvidersView()
                    case .modelProviderDetail(let id): ModelProviderDetailView(providerId: id)
                    case .modelProviderNew: NewModelProviderView()
                    case .mcpServers: McpServersView()
                    case .mcpServerDetail(let id): McpServerDetailView(serverId: id)
                    }
                }
                .navigationTitle(appState.currentRoute.title)
                .navigationDestination(for: AppRoute.self) { route in
                    Text("Pushed: \(route.title)")
                }
            }
        }
        .preferredColorScheme(UserDefaults.standard.bool(forKey: UserDefaultsStore.Keys.appearancePureBlackEnabled) ? .dark : nil)
        .tint(UserDefaults.standard.bool(forKey: UserDefaultsStore.Keys.appearanceMonetEnabled) ? .green : .blue)
    }
}

struct SidebarView: View {
    @EnvironmentObject var appState: AppState
    
    let mainRoutes: [AppRoute] = [.home, .chat, .browser, .terminal, .tools, .skills, .characters, .memory]
    let systemRoutes: [AppRoute] = [.modelProviders, .mcpServers, .permissions, .systemEnhance, .settings]
    
    var body: some View {
        List {
            Section("Features") {
                ForEach(mainRoutes, id: \.self) { route in
                    SidebarRow(route: route)
                }
            }
            
            Section("System") {
                ForEach(systemRoutes, id: \.self) { route in
                    SidebarRow(route: route)
                }
            }
        }
        .navigationTitle("Eta")
    }
}

struct SidebarRow: View {
    let route: AppRoute
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Button(action: {
            appState.navigate(to: route)
        }) {
            HStack {
                Image(systemName: route.iconName)
                    .frame(width: 24)
                Text(route.title)
                Spacer()
            }
            .foregroundColor(appState.currentRoute == route ? .blue : .primary)
        }
    }
}

