import SwiftUI

struct AppearanceSettingsView: View {
    @ObservedObject var defaults = UserDefaultsStore.shared
    
    var body: some View {
        Form {
            Section("Theme") {
                Toggle("Pure Black Dark Mode", isOn: Binding(
                    get: { defaults.defaults.bool(forKey: UserDefaultsStore.Keys.appearancePureBlackEnabled) },
                    set: { defaults.defaults.set($0, forKey: UserDefaultsStore.Keys.appearancePureBlackEnabled) }
                ))
                Toggle("Material You / Monet", isOn: Binding(
                    get: { defaults.defaults.bool(forKey: UserDefaultsStore.Keys.appearanceMonetEnabled) },
                    set: { defaults.defaults.set($0, forKey: UserDefaultsStore.Keys.appearanceMonetEnabled) }
                ))
            }
            Section("Interface") {
                Toggle("Blur Effects", isOn: Binding(
                    get: { defaults.defaults.bool(forKey: UserDefaultsStore.Keys.appearanceBlurEnabled) },
                    set: { defaults.defaults.set($0, forKey: UserDefaultsStore.Keys.appearanceBlurEnabled) }
                ))
                Toggle("Swipe to Dismiss", isOn: Binding(
                    get: { defaults.defaults.bool(forKey: UserDefaultsStore.Keys.appearanceSwipeDismissEnabled) },
                    set: { defaults.defaults.set($0, forKey: UserDefaultsStore.Keys.appearanceSwipeDismissEnabled) }
                ))
                Toggle("Predictive Back Gesture", isOn: Binding(
                    get: { defaults.defaults.bool(forKey: UserDefaultsStore.Keys.appearancePredictiveBackEnabled) },
                    set: { defaults.defaults.set($0, forKey: UserDefaultsStore.Keys.appearancePredictiveBackEnabled) }
                ))
            }
        }
        .navigationTitle("Appearance")
    }
}

struct DataBackupView: View {
    var body: some View {
        List {
            Button("Export Conversations") {}
            Button("Export Characters") {}
            Button("Export Settings") {}
            Button("Import Backup") {}
        }
        .navigationTitle("Backup & Restore")
    }
}

struct LinuxEnvironmentView: View {
    var body: some View {
        Form {
            Text("Linux Distribution: Ubuntu (Simulated)")
            Text("PRoot Environment: Unavailable on iOS Sandbox")
                .foregroundColor(.red)
        }
        .navigationTitle("Linux Environment")
    }
}

