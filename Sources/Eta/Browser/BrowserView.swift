import SwiftUI
import WebKit

struct BrowserView: View {
    @State private var urlString: String = "https://example.com"
    @StateObject private var browserSession = BrowserSession()
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("URL or Search", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.URL)
                    .autocapitalization(.none)
                    .onSubmit {
                        browserSession.load(urlString: urlString)
                    }
                
                Button("Go") {
                    browserSession.load(urlString: urlString)
                }
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            
            WebView(session: browserSession)
        }
        .navigationTitle("Browser")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: browserSession.reload) {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
}

class BrowserSession: ObservableObject {
    @Published var webView: WKWebView = WKWebView()
    
    func load(urlString: String) {
        var finalString = urlString
        if !finalString.lowercased().hasPrefix("http") {
            finalString = "https://" + finalString
        }
        if let url = URL(string: finalString) {
            webView.load(URLRequest(url: url))
        }
    }
    
    func reload() {
        webView.reload()
    }
}

struct WebView: UIViewRepresentable {
    @ObservedObject var session: BrowserSession
    
    func makeUIView(context: Context) -> WKWebView {
        return session.webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
}

