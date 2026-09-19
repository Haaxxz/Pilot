import Foundation

public struct BuiltinProviders {
    public static let defaultSystemPrompt = "You are Eta, an AI assistant running on an iOS device."
    
    public static let providers: [ProviderSetting] = [
        OpenAiCompatibleProviderSetting(
            id: "builtin-openai",
            name: "OpenAI",
            baseUrl: "https://api.openai.com/v1",
            sourceType: ProviderSourceType.openai,
            isBuiltIn: true,
            sortOrder: 1,
            endpointMode: OpenAiEndpointMode.responses
        ),
        AnthropicProviderSetting(
            id: "builtin-anthropic",
            name: "Anthropic",
            baseUrl: "https://api.anthropic.com",
            sourceType: ProviderSourceType.anthropic,
            isBuiltIn: true,
            sortOrder: 2
        ),
        OpenAiCompatibleProviderSetting(
            id: "builtin-dashscope",
            name: "Alibaba Bailian",
            baseUrl: "https://dashscope.aliyuncs.com/compatible-mode/v1",
            sourceType: ProviderSourceType.bailian,
            isBuiltIn: true,
            sortOrder: 3,
            endpointMode: OpenAiEndpointMode.chatCompletions
        ),
        OpenAiCompatibleProviderSetting(
            id: "builtin-deepseek",
            name: "DeepSeek",
            baseUrl: "https://api.deepseek.com",
            sourceType: ProviderSourceType.deepseek,
            isBuiltIn: true,
            sortOrder: 4,
            endpointMode: OpenAiEndpointMode.chatCompletions
        ),
        OpenAiCompatibleProviderSetting(
            id: "builtin-kimi",
            name: "Kimi",
            baseUrl: "https://api.moonshot.cn/v1",
            sourceType: ProviderSourceType.moonshot,
            isBuiltIn: true,
            sortOrder: 5,
            endpointMode: OpenAiEndpointMode.chatCompletions
        ),
        OpenAiCompatibleProviderSetting(
            id: "builtin-mimo",
            name: "MiMo",
            baseUrl: "https://api.xiaomimimo.com/v1",
            sourceType: ProviderSourceType.mimo,
            isBuiltIn: true,
            sortOrder: 6,
            endpointMode: OpenAiEndpointMode.chatCompletions
        ),
        OpenAiCompatibleProviderSetting(
            id: "builtin-minimax",
            name: "MiniMax",
            baseUrl: "https://api.minimaxi.com/v1",
            sourceType: ProviderSourceType.minimax,
            isBuiltIn: true,
            sortOrder: 7,
            endpointMode: OpenAiEndpointMode.chatCompletions
        ),
        OpenAiCompatibleProviderSetting(
            id: "builtin-stepfun",
            name: "StepFun",
            baseUrl: "https://api.stepfun.com/v1",
            sourceType: ProviderSourceType.stepfun,
            isBuiltIn: true,
            sortOrder: 8,
            endpointMode: OpenAiEndpointMode.chatCompletions
        ),
        OpenAiCompatibleProviderSetting(
            id: "builtin-siliconflow",
            name: "SiliconFlow",
            baseUrl: "https://api.siliconflow.cn/v1",
            sourceType: ProviderSourceType.siliconflow,
            isBuiltIn: true,
            sortOrder: 9,
            endpointMode: OpenAiEndpointMode.chatCompletions
        ),
        OpenAiCompatibleProviderSetting(
            id: "builtin-openrouter",
            name: "OpenRouter",
            baseUrl: "https://openrouter.ai/api/v1",
            sourceType: ProviderSourceType.openrouter,
            isBuiltIn: true,
            sortOrder: 10,
            endpointMode: OpenAiEndpointMode.chatCompletions
        )
    ]
}

