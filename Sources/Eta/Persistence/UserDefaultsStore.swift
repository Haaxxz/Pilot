import Foundation
import Combine

public final class UserDefaultsStore {
    public static let shared = UserDefaultsStore()
    private let defaults = UserDefaults.standard
    
    // Setting Keys
    public enum Keys {
        public static let selectedProviderId = "selected_provider_id"
        public static let selectedModelId = "selected_model_id"
        public static let memoryEnabled = "memory_enabled"
        public static let linuxDistribution = "linux_distribution"
        
        // Appearance
        public static let appearanceThemeMode = "appearance_theme_mode"
        public static let appearanceMonetEnabled = "appearance_monet_enabled"
        public static let appearancePaletteStyle = "appearance_palette_style"
        public static let appearanceAccentColor = "appearance_accent_color"
        public static let appearancePureBlackEnabled = "appearance_pure_black_enabled"
        public static let appearanceBlurEnabled = "appearance_blur_enabled"
        public static let appearanceTopBarBlurStyle = "appearance_top_bar_blur_style"
        public static let appearanceSwipeDismissEnabled = "appearance_swipe_dismiss_enabled"
        public static let appearancePredictiveBackEnabled = "appearance_predictive_back_enabled"
        public static let appearanceInterfaceScale = "appearance_interface_scale"
        
        // Agent switches (from Prefs.kt)
        public static let powerKeyAssistantTarget = "power_key_assistant_target"
        public static let gestureBarCircleToSearch = "gesture_bar_circle_to_search"
        public static let doubleFingerCircleToSearch = "double_finger_circle_to_search"
        public static let agentCustomModel = "agent_custom_model"
        public static let agentRequirePrefix = "agent_require_prefix"
        public static let agentTerminalTools = "agent_terminal_tools"
        public static let agentBrowserTools = "agent_browser_tools"
        public static let agentDeviceDirectTools = "agent_device_direct_tools"
        public static let agentDeviceSensitiveReadTools = "agent_device_sensitive_read_tools"
        public static let agentDeviceSensitiveActionTools = "agent_device_sensitive_action_tools"
        public static let agentThinkingEnabled = "agent_thinking_enabled"
        public static let agentRuntimeConfigJson = "agent_runtime_config_json"
    }
    
    private init() {
        // Register default values
        defaults.register(defaults: [
            Keys.memoryEnabled: true,
            Keys.appearanceMonetEnabled: false,
            Keys.appearancePureBlackEnabled: false,
            Keys.appearanceBlurEnabled: true,
            Keys.appearanceSwipeDismissEnabled: true,
            Keys.appearancePredictiveBackEnabled: true,
            Keys.appearanceInterfaceScale: 1.0,
            
            Keys.gestureBarCircleToSearch: true,
            Keys.doubleFingerCircleToSearch: false,
            Keys.agentCustomModel: true,
            Keys.agentRequirePrefix: false,
            Keys.agentTerminalTools: true,
            Keys.agentBrowserTools: true,
            Keys.agentDeviceDirectTools: true,
            Keys.agentDeviceSensitiveReadTools: true,
            Keys.agentDeviceSensitiveActionTools: true,
            Keys.agentThinkingEnabled: true
        ])
    }
    
    // Publishers for reactive UI updates
    public func publisher<T>(for key: String) -> AnyPublisher<T, Never> {
        return defaults.publisher(for: \.self).compactMap { _ in self.defaults.object(forKey: key) as? T }.eraseToAnyPublisher()
    }
    
    public var selectedProviderId: String? {
        get { defaults.string(forKey: Keys.selectedProviderId) }
        set { defaults.set(newValue, forKey: Keys.selectedProviderId) }
    }
    
    public var selectedModelId: String? {
        get { defaults.string(forKey: Keys.selectedModelId) }
        set { defaults.set(newValue, forKey: Keys.selectedModelId) }
    }
    
    public var agentTerminalTools: Bool {
        get { defaults.bool(forKey: Keys.agentTerminalTools) }
        set { defaults.set(newValue, forKey: Keys.agentTerminalTools) }
    }
    
    public var agentBrowserTools: Bool {
        get { defaults.bool(forKey: Keys.agentBrowserTools) }
        set { defaults.set(newValue, forKey: Keys.agentBrowserTools) }
    }
    
    public var agentThinkingEnabled: Bool {
        get { defaults.bool(forKey: Keys.agentThinkingEnabled) }
        set { defaults.set(newValue, forKey: Keys.agentThinkingEnabled) }
    }
}

