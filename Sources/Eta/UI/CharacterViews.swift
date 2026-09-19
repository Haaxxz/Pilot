import SwiftUI

struct CharactersView: View {
    var body: some View {
        List {
            Text("Character Library")
        }
        .navigationTitle("Characters")
        .toolbar {
            Button("Add") { }
        }
    }
}

struct CharacterDetailView: View {
    let characterId: String
    
    var body: some View {
        Text("Character Details for \(characterId)")
            .navigationTitle("Detail")
    }
}

struct CharacterEditorView: View {
    let characterId: String?
    
    var body: some View {
        Form {
            Section("Basic Info") {
                TextField("Name", text: .constant(""))
            }
        }
        .navigationTitle(characterId == nil ? "New Character" : "Edit Character")
    }
}

struct CharacterPersonaView: View {
    var body: some View {
        Form {
            Section("User Persona") {
                TextEditor(text: .constant("Information about the user for the character to reference."))
                    .frame(height: 200)
            }
        }
        .navigationTitle("User Persona")
    }
}

struct CharacterMemoryView: View {
    let characterId: String
    
    var body: some View {
        List {
            Text("No memories extracted yet.")
        }
        .navigationTitle("Memory")
    }
}

