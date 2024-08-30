//
//  ContentView.swift
//  formatter-toolbox
//
//  Created by wzh on 2024/8/28.
//

import SwiftUI
import WebKit
import UniformTypeIdentifiers

class WebViewCoordinator: NSObject, WKScriptMessageHandler {
    var viewContext: NSManagedObjectContext
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("\(message.name) : \(message.body)")
        if message.name == "saveSettingHandler", let messageBody = message.body as? String {
            stjSaveSettingResolve(result: UserSettingMapper(viewContext: viewContext).saveUserSetting(data: messageBody), webView: message.webView)
        }
        else if message.name == "getSettingHandler" {
            stjGetSettingResolve(result: UserSettingMapper(viewContext: viewContext).getUserSettingIndent(), webView: message.webView)
        }
        else if message.name == "importFileHandler", let messageBody = message.body as? String {
            stjImportFileResolve(result: selectFile(type: messageBody), webView: message.webView)
        }
        else if message.name == "exportFileHandler", let messageBody = message.body as? String {
            saveAsFile(type: messageBody.prefix(10).replacingOccurrences(of: ":", with: ""), data: String(messageBody[messageBody.index(messageBody.startIndex, offsetBy: 10)...]))
        }
    }
    
    private func stjSaveSettingResolve(result: Bool, webView: WKWebView?){
        print("stjSaveSettingResolve: \(result)")
        webView?.evaluateJavaScript("window.saveSettingResolve(\(result));", completionHandler: nil)
    }
    
    private func stjGetSettingResolve(result: Int16, webView: WKWebView?){
        print("stjGetSettingResolve: \(result)")
        webView?.evaluateJavaScript("window.getSettingResolve(\(result));", completionHandler: nil)
    }
    
    private func stjImportFileResolve(result: String, webView: WKWebView?){
        print("stjImportFileResolve: \(result)")
        webView?.evaluateJavaScript("window.importFileResolve(`\(result)`);", completionHandler: nil)
    }
    
    
}

struct WebView: NSViewRepresentable {
    let fileName: String
    let fileExtension: String
    let viewContext: NSManagedObjectContext
    
    init(fileName: String, fileExtension: String, viewContext: NSManagedObjectContext) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.viewContext = viewContext
    }
    
    func makeNSView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "saveSettingHandler")
        contentController.add(context.coordinator, name: "getSettingHandler")
        contentController.add(context.coordinator, name: "importFileHandler")
        contentController.add(context.coordinator, name: "exportFileHandler")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.isInspectable = true
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            let request = URLRequest(url: url)
            nsView.load(request)
        }
    }
    
    func makeCoordinator() -> WebViewCoordinator { return WebViewCoordinator(viewContext: viewContext) }
}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        WebView(fileName: "index", fileExtension: "html", viewContext: viewContext)
    }
}

#Preview {
    ContentView()
}
