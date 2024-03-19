//
//  WheresMyStuffApp.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData
import SwiftUI_NotificationBanner

@main
struct WheresMyStuffApp: App {
    @StateObject var notificationBanner = DYNotificationHandler()
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environmentObject(notificationBanner)
        }
        .modelContainer(CustomContainer.create())
    }
}
//for gaining direct access to the sqlite database that Swift Data uses
extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
