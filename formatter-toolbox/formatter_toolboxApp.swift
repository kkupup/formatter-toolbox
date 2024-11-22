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
    
    init(){
        loadCustomFont()
    }
    
    var body: some Scene {
        Window("Main", id: "Main") {
            ContentView()
                .frame(minWidth: 1200, minHeight: 700)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .windowStyle(.hiddenTitleBar)
    }
}


func loadCustomFont() {
    guard let fontURL = Bundle.main.url(forResource: "Balthazar-Regular", withExtension: "ttf") else {
        print("Failed to find font file.")
        return
    }

    var error: Unmanaged<CFError>?
    CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)

    if let error = error?.takeUnretainedValue() {
        print("Failed to load font: \(error)")
    }
}
