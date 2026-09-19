import SwiftUI

struct ModelProvidersView: View {
    @State private var providers: [ProviderSetting] = BuiltinProviders.providers
    
    var body: some View {
        List {
            Section("Built-in Providers") {
                ForEach(providers.filter { $0.isBuiltIn }, id: \.id) { provider in
                    NavigationLink(destination: ModelProviderDetailView(providerId: provider.id)) {
                        VStack(alignment: .leading) {
                            Text(provider.name).font(.headline)
                            Text(provider.baseUrl).font(.caption).foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            Section("Custom Providers") {
                ForEach(providers.filter { !$0.isBuiltIn }, id: \.id) { provider in
                    NavigationLink(destination: ModelProviderDetailView(providerId: provider.id)) {
                        Text(provider.name)
                    }
                }
                NavigationLink("Add Custom Provider", destination: NewModelProviderView())
                    .foregroundColor(.blue)
            }
        }
        .navigationTitle("Model Providers")
    }
}

struct ModelProviderDetailView: View {
    let providerId: String
    
    var body: some View {
        Form {
            Section("Provider Setup") {
                TextField("API Key", text: .constant(""))
                    .textContentType(.password)
                Text("Stored securely in iOS Keychain")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Provider Details")
    }
}

struct NewModelProviderView: View {
    var body: some View {
        Form {
            Section("Provider Type") {
                Button("OpenAI Compatible") {}
                Button("Anthropic Compatible") {}
                Button("Custom Type") {}
            }
        }
        .navigationTitle("New Provider")
    }
}

