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
    if type == "xml" {
        openPanel.allowedContentTypes = [.xml]
    }else if type == "html" {
        openPanel.allowedContentTypes = [.html]
    }else if type == "css" {
        openPanel.allowedContentTypes = [UTType(filenameExtension: "css")!]
    }else if type == "javascript" {
        openPanel.allowedContentTypes = [UTType(filenameExtension: "js")!]
    }else {
        openPanel.allowedContentTypes = [.json]
    }
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

extension String {
    func jsEscaped() -> String {
        return self.replacingOccurrences(of: "\"", with: "\\\"")
                   .replacingOccurrences(of: "\n", with: "\\n")
                   .replacingOccurrences(of: "\r", with: "\\r")
    }
}
