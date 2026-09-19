import SwiftUI

struct TerminalSessionView: View {
    @StateObject private var session = TerminalSession()
    @State private var input: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    Text(session.outputBuffer)
                        .font(.system(.body, design: .monospaced))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .id("terminalOutput")
                }
                .background(Color.black)
                .foregroundColor(.green)
                .onChange(of: session.outputBuffer) { _ in
                    withAnimation {
                        proxy.scrollTo("terminalOutput", anchor: .bottom)
                    }
                }
            }
            
            HStack {
                Text("$")
                    .font(.system(.body, design: .monospaced))
                    .foregroundColor(.secondary)
                
                TextField("Command", text: $input)
                    .font(.system(.body, design: .monospaced))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !input.isEmpty {
                            session.execute(command: input)
                            input = ""
                        }
                    }
                
                Button(action: {
                    if !input.isEmpty {
                        session.execute(command: input)
                        input = ""
                    }
                }) {
                    Image(systemName: "return")
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
        }
        .navigationTitle("Sandbox Terminal")
    }
}

