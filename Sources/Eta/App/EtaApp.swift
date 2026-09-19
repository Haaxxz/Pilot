import SwiftUI

@main
struct EtaApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        setupDatabase()
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(appState)
        }
    }
    
    private func setupDatabase() {
        do {
            let appSupportURL = try FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let dbURL = appSupportURL.appendingPathComponent("eta.db")
            try Database.shared.setup(databaseURL: dbURL)
            print("Database setup complete at \(dbURL.path)")
        } catch {
            fatalError("Failed to set up database: \(error)")
        }
    }
}

class AppState: ObservableObject {
    @Published var currentRoute: AppRoute = .home
    @Published var navigationPath = NavigationPath()
    @Published var isSidebarPresented: Bool = false
    
    func navigate(to route: AppRoute) {
        // Clear path when navigating from sidebar
        navigationPath.removeLast(navigationPath.count)
        currentRoute = route
        isSidebarPresented = false
    }
}

