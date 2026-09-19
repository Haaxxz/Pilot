import SwiftUI

struct McpServersView: View {
    var body: some View {
        List {
            Text("No MCP servers configured.")
                .foregroundColor(.secondary)
        }
        .navigationTitle("MCP Servers")
        .toolbar {
            Button(action: {}) {
                Image(systemName: "plus")
            }
        }
    }
}

struct McpServerDetailView: View {
    let serverId: String
    
    @State private var name: String = ""
    @State private var url: String = ""
    @State private var protocolMode: String = "auto"
    
    var body: some View {
        Form {
            Section("Server Settings") {
                TextField("Name", text: $name)
                TextField("URL (SSE Endpoint)", text: $url)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                Picker("Protocol Mode", selection: $protocolMode) {
                    Text("Auto").tag("auto")
                    Text("Latest (2026)").tag("2026-07-28")
                    Text("Legacy (2025)").tag("2025-11-25")
                }
            }
            
            Section("Status") {
                HStack {
                    Text("Connection")
                    Spacer()
                    Text("Not Connected")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationTitle("Server Details")
    }
}

