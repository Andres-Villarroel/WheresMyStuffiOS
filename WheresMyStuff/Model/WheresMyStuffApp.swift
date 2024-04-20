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
