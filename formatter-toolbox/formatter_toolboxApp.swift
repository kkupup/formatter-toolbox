//
//  formatter_toolboxApp.swift
//  formatter-toolbox
//
//  Created by wzh on 2024/8/28.
//

import SwiftUI

@main
struct formatter_toolboxApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
