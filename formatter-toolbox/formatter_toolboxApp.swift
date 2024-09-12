//
//  formatter_toolboxApp.swift
//  formatter-toolbox
//
//  Created by wzh on 2024/8/28.
//

import SwiftUI
import Combine

@main
struct formatter_toolboxApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        Window("Main", id: "Main") {
            ContentView()
                .frame(minWidth: 800, minHeight: 400)
                .onAppear{
                    if let window = NSApplication.shared.windows.first {
                        window.title = "Formatter Toolbox"
                        window.setContentSize(NSSize(width: 800, height: 500))
                        window.minSize = NSSize(width: 800, height: 500)
                        window.titlebarAppearsTransparent = true
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
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
