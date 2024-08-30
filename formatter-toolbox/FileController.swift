//
//  FileController.swift
//  formatter-toolbox
//
//  Created by wzh on 2024/8/30.
//
import SwiftUI
import UniformTypeIdentifiers

func selectFile(type: String) -> String{
    let openPanel = NSOpenPanel()
    openPanel.allowedContentTypes = getType(type: type)
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    
    if openPanel.runModal() == .OK {
        if let url = openPanel.url {
            do {
                let content = try String(contentsOf: url, encoding: .utf8)
                return content
            } catch {
                print("Failed to read file content: \(error)")
                return ""
            }
        }
    }
    return ""
}

func saveAsFile(type:String, data: String) {
    let savePanel = NSSavePanel()
    savePanel.allowedContentTypes = getType(type: type)
    savePanel.canCreateDirectories = true
    savePanel.nameFieldStringValue = "\(type)_\(getTime()).\(type)"
    savePanel.begin { response in
        if response == .OK, let url = savePanel.url {
            do {
                try data.write(to: url, atomically: true, encoding: .utf8)
                print("Data saved to: \(url)")
            } catch {
                print("Error saving file: \(error)")
            }
        }
    }
}

func getTime() -> String{
//    let today = Date()
//    print("today = \(today)")
//    let zone = NSTimeZone.system
//    print("zone = \(zone)")
//    let interval = zone.secondsFromGMT()
//    print("interval = \(interval)")
//    let now = today.addingTimeInterval(TimeInterval(interval))
//    print("now = \(now)")
    let now = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy_MM_dd_HH_mm_ss"
    return dateFormatter.string(from: now)
}

func getType(type: String) -> [UTType] {
    var result: [UTType] = []

    switch type {
    case "xml":
        result = [UTType.xml]
    case "html":
        result = [UTType.html]
    case "css":
        if let cssType = UTType(filenameExtension: "css") { result = [cssType] }
    case "javascript":
        if let jsType = UTType(filenameExtension: "js") { result = [jsType] }
    default:
        result = [UTType.json]
    }

    return result
}

extension String {
    func jsEscaped() -> String {
        return self.replacingOccurrences(of: "\"", with: "\\\"")
                   .replacingOccurrences(of: "\n", with: "\\n")
                   .replacingOccurrences(of: "\r", with: "\\r")
    }
}
