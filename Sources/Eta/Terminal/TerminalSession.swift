import Foundation

public class TerminalSession: ObservableObject {
    @Published public var outputBuffer: String = ""
    @Published public var isRunning: Bool = false
    
    private var currentDirectory: URL
    
    public init() {
        self.currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        outputBuffer += "Welcome to Eta iOS Sandbox Terminal\n"
        outputBuffer += "Warning: Native Linux execution (PRoot) is not available on iOS.\n"
        outputBuffer += "Only basic file management commands are simulated.\n\n"
        prompt()
    }
    
    public func execute(command: String) {
        outputBuffer += command + "\n"
        
        let parts = command.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ")
        guard let cmd = parts.first, !cmd.isEmpty else {
            prompt()
            return
        }
        
        switch cmd {
        case "ls":
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: currentDirectory.path)
                outputBuffer += contents.joined(separator: "  ") + "\n"
            } catch {
                outputBuffer += "ls: \(error.localizedDescription)\n"
            }
        case "pwd":
            outputBuffer += currentDirectory.path + "\n"
        case "cd":
            let target = parts.dropFirst().joined(separator: " ")
            if target.isEmpty {
                currentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            } else {
                let newUrl = currentDirectory.appendingPathComponent(target)
                var isDir: ObjCBool = false
                if FileManager.default.fileExists(atPath: newUrl.path, isDirectory: &isDir) && isDir.boolValue {
                    currentDirectory = newUrl.standardizedFileURL
                } else {
                    outputBuffer += "cd: \(target): No such directory\n"
                }
            }
        case "echo":
            outputBuffer += parts.dropFirst().joined(separator: " ") + "\n"
        case "clear":
            outputBuffer = ""
        case "help":
            outputBuffer += "Available simulated commands: ls, pwd, cd, echo, clear, help\n"
        default:
            outputBuffer += "sh: \(cmd): command not found (iOS Sandbox limit)\n"
        }
        
        prompt()
    }
    
    private func prompt() {
        let path = currentDirectory.lastPathComponent
        outputBuffer += "eta@ios ~/\(path) $ "
    }
}

