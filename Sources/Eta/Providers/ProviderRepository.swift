import Foundation
import Combine
import GRDB

public final class ProviderRepository {
    public static let shared = ProviderRepository()
    
    private init() {}
    
    public func providers() throws -> [ProviderSetting] {
        try Database.shared.dbPool.read { db in
            let entities = try ProviderEntity.order(Column("sort_order")).fetchAll(db)
            return entities.map { entity in
                let models = try ProviderModelEntity.filter(Column("provider_id") == entity.id).order(Column("sort_order")).fetchAll(db)
                return self.mapToDomain(entity: entity, models: models)
            }
        }
    }
    
    public func provider(byId id: String) throws -> ProviderSetting? {
        try Database.shared.dbPool.read { db in
            if let entity = try ProviderEntity.fetchOne(db, key: id) {
                let models = try ProviderModelEntity.filter(Column("provider_id") == entity.id).order(Column("sort_order")).fetchAll(db)
                return self.mapToDomain(entity: entity, models: models)
            }
            return nil
        }
    }
    
    public func save(provider: ProviderSetting) throws {
        try Database.shared.dbPool.write { db in
            var entity = self.mapToEntity(domain: provider)
            try entity.save(db)
            
            // Delete existing models
            try ProviderModelEntity.filter(Column("provider_id") == provider.id).deleteAll(db)
            
            // Insert new models
            for (index, model) in provider.models.enumerated() {
                var modelEntity = self.mapToModelEntity(domain: model, providerId: provider.id, sortOrder: index)
                try modelEntity.insert(db)
            }
        }
    }
    
    private func mapToDomain(entity: ProviderEntity, models: [ProviderModelEntity]) -> ProviderSetting {
        let domainModels = models.map { m in
            Model(id: m.id, modelId: m.modelId, displayName: m.displayName)
            // In a full implementation, we'd map all fields carefully, including JSON parsing for headers/modalities
        }
        
        switch entity.type {
        case ProviderType.openaiCompatible:
            return OpenAiCompatibleProviderSetting(
                id: entity.id, name: entity.name, baseUrl: entity.baseUrl, apiKey: entity.apiKey,
                isEnabled: entity.isEnabled, isBuiltIn: entity.isBuiltIn, sortOrder: entity.sortOrder,
                systemPrompt: entity.systemPrompt, createdAt: entity.createdAt, endpointMode: entity.endpointMode,
                hostedWebSearchEnabled: entity.hostedWebSearchEnabled
            )
        case ProviderType.anthropic:
            return AnthropicProviderSetting(
                id: entity.id, name: entity.name, baseUrl: entity.baseUrl, apiKey: entity.apiKey,
                isEnabled: entity.isEnabled, isBuiltIn: entity.isBuiltIn, sortOrder: entity.sortOrder,
                systemPrompt: entity.systemPrompt, createdAt: entity.createdAt, anthropicVersion: entity.anthropicVersion,
                hostedWebSearchEnabled: entity.hostedWebSearchEnabled
            )
        default:
            return CustomProviderSetting(
                id: entity.id, name: entity.name, baseUrl: entity.baseUrl, apiKey: entity.apiKey,
                isEnabled: entity.isEnabled, isBuiltIn: entity.isBuiltIn, sortOrder: entity.sortOrder,
                systemPrompt: entity.systemPrompt, createdAt: entity.createdAt, endpointMode: entity.endpointMode,
                hostedWebSearchEnabled: entity.hostedWebSearchEnabled
            )
        }
    }
    
    private func mapToEntity(domain: ProviderSetting) -> ProviderEntity {
        return ProviderEntity(
            id: domain.id, type: domain.sourceType, name: domain.name, baseUrl: domain.baseUrl,
            apiKey: domain.apiKey, isEnabled: domain.isEnabled, isBuiltIn: domain.isBuiltIn,
            sortOrder: domain.sortOrder, systemPrompt: domain.systemPrompt,
            customHeadersJson: "[]", customBodyJson: "[]", createdAt: domain.createdAt,
            endpointMode: (domain as? OpenAiCompatibleProviderSetting)?.endpointMode ?? OpenAiEndpointMode.chatCompletions,
            hostedWebSearchEnabled: domain.hostedWebSearchEnabled,
            anthropicVersion: (domain as? AnthropicProviderSetting)?.anthropicVersion ?? AnthropicProviderSetting.defaultAnthropicVersion
        )
    }
    
    private func mapToModelEntity(domain: Model, providerId: String, sortOrder: Int) -> ProviderModelEntity {
        return ProviderModelEntity(
            id: domain.id, providerId: providerId, modelId: domain.modelId, displayName: domain.displayName,
            isEnabled: domain.isEnabled, isBuiltIn: domain.isBuiltIn, sortOrder: sortOrder,
            ownedBy: domain.ownedBy, contextWindow: domain.contextWindow, contextWindowOverride: domain.contextWindowOverride,
            inputModalitiesJson: "[\"text\"]", outputModalitiesJson: "[\"text\"]",
            attachment: domain.attachment, toolCall: domain.toolCall, reasoning: domain.reasoning,
            reasoningCapabilitiesJson: "null", reasoningOverride: domain.reasoningOverride,
            reasoningCapabilitiesOverrideJson: "null", structuredOutput: domain.structuredOutput,
            supportsTemperature: domain.supportsTemperature, customHeadersJson: "[]",
            customBodyJson: "[]", source: domain.source.rawValue, createdAt: domain.createdAt
        )
    }
}

