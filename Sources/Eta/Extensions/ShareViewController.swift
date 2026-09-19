import UIKit
import Social
import MobileCoreServices
import UniformTypeIdentifiers

class ShareViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let label = UILabel()
        label.text = "Sending to Eta..."
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Extract content and pass to main app
        extractSharedContent()
    }
    
    private func extractSharedContent() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            completeRequest()
            return
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
            itemProvider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { (item, error) in
                if let url = item as? URL {
                    self.sendToMainApp(text: url.absoluteString)
                } else {
                    self.completeRequest()
                }
            }
        } else if itemProvider.hasItemConformingToTypeIdentifier(UTType.text.identifier) {
            itemProvider.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (item, error) in
                if let text = item as? String {
                    self.sendToMainApp(text: text)
                } else {
                    self.completeRequest()
                }
            }
        } else {
            completeRequest()
        }
    }
    
    private func sendToMainApp(text: String) {
        // Encode text to safe URL
        guard let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "eta://share?text=\(encodedText)") else {
            completeRequest()
            return
        }
        
        // Use selector to open URL from Share Extension
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(url, options: [:], completionHandler: nil)
                break
            }
            responder = responder?.next
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.completeRequest()
        }
    }
    
    private func completeRequest() {
        DispatchQueue.main.async {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
}

