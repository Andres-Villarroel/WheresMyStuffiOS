//
//  WheresMyStuffApp.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData

@main
struct WheresMyStuffApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
        }
        .modelContainer(for: [ItemDataModel.self])    //creates storage for the app
    }
}
extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
