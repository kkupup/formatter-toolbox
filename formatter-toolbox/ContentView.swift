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
    let parentWebView: WebView
    let viewContext: NSManagedObjectContext
    let openWindow: OpenWindowAction
    
    init(parentWebView: WebView, viewContext: NSManagedObjectContext, openWindow: OpenWindowAction) {
        self.parentWebView = parentWebView
        self.viewContext = viewContext
        self.openWindow = openWindow
    }
   
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("\(message.name) : \(message.body)")
        if message.name == "saveSettingHandler", let messageBody = message.body as? String {
            stjSaveSettingResolve(result: UserSettingMapper(viewContext: viewContext).saveUserSetting(data: messageBody), webView: message.webView)
        }
        else if message.name == "getSettingHandler" {
            stjGetSettingResolve(result: UserSettingMapper(viewContext: viewContext).getUserSettingIndent(), webView: message.webView)
        }    
        else if message.name == "copyTextHandler", let messageBody = message.body as? String {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.setString(messageBody, forType: .string)
        }
        else if message.name == "importFileHandler", let messageBody = message.body as? String {
            stjImportFileResolve(result: selectFile(type: messageBody), webView: message.webView)
        }
        else if message.name == "exportFileHandler", let messageBody = message.body as? String {
            saveAsFile(type: messageBody.prefix(10).replacingOccurrences(of: ":", with: ""), data: String(messageBody[messageBody.index(messageBody.startIndex, offsetBy: 10)...]))
        }
        else if message.name == "resizeWindowHandler", let messageBody = message.body as? String {
            if messageBody == "b" { resizeWindow(width: 1100, height: 700) } else { resizeWindow(width: 700, height: 400) }
        }
        else if message.name == "saveHistoryHandler", let messageBody = message.body as? String  {
            OperationHistoryMapper(viewContext: viewContext).saveOperationHistory(data: messageBody)
        }
        else if message.name == "getOperationHistoryHandler" {
            stjGetOperationHistoryHandlerResolve(result: OperationHistoryMapper(viewContext: viewContext).getOperationHistory(), webView: message.webView)
        }
        else if message.name == "deleteAllOperationHistoryHandler" {
            stjDeleteAllOperationHistoryHandlerResolve(result: OperationHistoryMapper(viewContext: viewContext).deleteAllOperationHistories(), webView: message.webView)
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
        print("stjImportFileResolve: \(strToBase64(str: result))")
        webView?.evaluateJavaScript("window.importFileResolve(`\(strToBase64(str: result))`);", completionHandler: nil)
    }
    private func stjGetOperationHistoryHandlerResolve(result: String, webView: WKWebView?){
        print("stjGetOperationHistoryHandlerResolve: \(result)")
        webView?.evaluateJavaScript("window.getOperationHistoryHandlerResolve(`\(result)`);", completionHandler: nil)
    }
    private func stjDeleteAllOperationHistoryHandlerResolve(result: Bool, webView: WKWebView?){
        print("stjDeleteAllOperationHistoryHandlerResolve: \(result)")
        webView?.evaluateJavaScript("window.deleteAllOperationHistoryHandlerResolve(`\(result)`);", completionHandler: nil)
    }
    
    private func strToBase64(str: String) -> String{
        let utf8EncodeData = str.data(using: String.Encoding.utf8, allowLossyConversion: true)
        let base64String = utf8EncodeData?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: UInt(0))) ?? ""
        return base64String
    }
    private func resizeWindow(width: CGFloat, height: CGFloat){
        if let window = NSApplication.shared.windows.first {
            var frame = window.frame
            frame.origin.y -= (height - frame.size.height)
            frame.size.width = width
            frame.size.height = height
            window.setFrame(frame, display: true, animate: true)
        }
    }
}

struct WebView: NSViewRepresentable {
    let fileName: String
    let fileExtension: String
    let viewContext: NSManagedObjectContext
    let openWindow: OpenWindowAction
    
    init(fileName: String, fileExtension: String, viewContext: NSManagedObjectContext, openWindow: OpenWindowAction) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.viewContext = viewContext
        self.openWindow = openWindow
    }

    func makeNSView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "saveSettingHandler")
        contentController.add(context.coordinator, name: "getSettingHandler")
        contentController.add(context.coordinator, name: "copyTextHandler")
        contentController.add(context.coordinator, name: "importFileHandler")
        contentController.add(context.coordinator, name: "exportFileHandler")
        contentController.add(context.coordinator, name: "resizeWindowHandler")
        contentController.add(context.coordinator, name: "saveHistoryHandler")
        contentController.add(context.coordinator, name: "getOperationHistoryHandler")
        contentController.add(context.coordinator, name: "deleteAllOperationHistoryHandler")
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
    
    func makeCoordinator() -> WebViewCoordinator { return WebViewCoordinator(parentWebView: self, viewContext: viewContext, openWindow: openWindow) }
}
		

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        WebView(fileName: "index", fileExtension: "html", viewContext: viewContext, openWindow: openWindow)
    }
}

#Preview {
    ContentView()
}
