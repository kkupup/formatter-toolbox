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
//        else if message.name == "changeTitleHandler", let messageBody = message.body as? String {
//            DispatchQueue.main.async { self.parentWebView.title = "Formatter Toolbox > " + messageBody }
//        }
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
        else if message.name == "deleteHistoryHandler", let messageBody = message.body as? String  {
            stjDeleteHistoryHandlerResolve(result: OperationHistoryMapper(viewContext: viewContext).deleteOperationHistories(idString: messageBody),  webView: message.webView)
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
    private func stjDeleteHistoryHandlerResolve(result: Bool, webView: WKWebView?){
        print("deleteHistoryHandlerResolve: \(result)")
        webView?.evaluateJavaScript("window.deleteHistoryHandlerResolve(`\(result)`);", completionHandler: nil)
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
    @Binding var title: String
    
    func makeNSView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "changeTitleHandler")
        contentController.add(context.coordinator, name: "saveSettingHandler")
        contentController.add(context.coordinator, name: "getSettingHandler")
        contentController.add(context.coordinator, name: "copyTextHandler")
        contentController.add(context.coordinator, name: "importFileHandler")
        contentController.add(context.coordinator, name: "exportFileHandler")
        contentController.add(context.coordinator, name: "saveHistoryHandler")
        contentController.add(context.coordinator, name: "getOperationHistoryHandler")
        contentController.add(context.coordinator, name: "deleteAllOperationHistoryHandler")
        contentController.add(context.coordinator, name: "deleteHistoryHandler")
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
    @State private var title: String = "FORMAT"
    
    var body: some View {
        WebView(fileName: "index", fileExtension: "html", viewContext: viewContext, openWindow: openWindow, title: $title)
            .onAppear{
                if let window = NSApplication.shared.windows.first {
                    window.title = "Formatter Toolbox"
                    window.setContentSize(NSSize(width: 1200, height: 700))
                    window.minSize = NSSize(width:1200, height: 700)
        
                    window.titleVisibility = .hidden
                    window.titlebarAppearsTransparent = true
                    window.isMovableByWindowBackground = true
                    window.standardWindowButton(.closeButton)?.superview?.addSubview(setTitleBar(window: window, title: title))
                    
                    window.backgroundColor = .white
                    DispatchQueue.main.async {
                        let screenSize = NSScreen.screens.first?.frame.size ?? NSSize(width: 0, height: 0)
                        let windowSize = window.frame.size
                        let xPosition = (screenSize.width - windowSize.width) / 8
                        let yPosition = (screenSize.height - windowSize.height) - screenSize.height / 8
                        window.setFrameOrigin(NSPoint(x: xPosition, y: yPosition))
                    }
                }
            }
//            .onChange(of: title) { newValue in
//                updateWindowTitleBar(title: newValue)
//            }
    }
}

func setTitleBar(window: NSWindow, title: String) -> NSView{
    let leftWidth: CGFloat = 70;
    let titleBar = NSHostingView(rootView: HStack(spacing: 0) {
        HStack {  Spacer() }
        .frame(width: leftWidth, height: 40)
        .background(Color(hex: "#eeeeee"))
        HStack {
            Text("Formatter Toolbox")
                .foregroundColor(Color(hex: "#323232"))
                .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                .font(.custom("Balthazar-Regular", size: 16))
//            Text(title)
//                .foregroundColor(Color(hex: "#323232"))
//                .padding(.top, 10)
//                .font(.custom("Balthazar-Regular", size: 14))
            Spacer()
        }
        .frame(width: (window.frame.width - leftWidth), height: 40)
        .background(Color.white)
    })
    
    titleBar.frame = NSRect(x: 0, y: 0, width: window.frame.width, height: 40)
    return titleBar
}

//func updateWindowTitleBar(title: String) {
//    let leftWidth: CGFloat = 70;
//    if let window = NSApplication.shared.windows.first {
//        window.standardWindowButton(.closeButton)?.superview?.subviews.compactMap { $0 as? NSHostingView }.forEach { hostingView in
//            hostingView.rootView = HStack(spacing: 0) {
//                HStack { Spacer() }
//                .frame(width: leftWidth, height: 40)
//                .background(Color(hex: "#eeeeee"))
//                HStack {
//                    Text("Formatter Toolbox  -")
//                        .foregroundColor(Color(hex: "#323232"))
//                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
//                        .font(.custom("Balthazar-Regular", size: 16))
//                    Text(title)
//                        .foregroundColor(Color(hex: "#323232"))
//                        .padding(.top, 10)
//                        .font(.custom("Balthazar-Regular", size: 14))
//                        .underline()
//                    Spacer()
//                }
//                .frame(width: (window.frame.width - leftWidth), height: 40)
//                .background(Color.white)
//            }
//        }
//    }
//}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    ContentView()
}
