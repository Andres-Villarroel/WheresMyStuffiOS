//
//  ContentView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/2/24.
//

import SwiftUI
import SwiftData
import SwiftUI_NotificationBanner

struct ContentView: View {
    //prep work for the notification banner feature
    @EnvironmentObject var notificationHandler: DYNotificationHandler
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        TabBarView()
            .notificationView(handler: notificationHandler, notificationBanner: {notification in
                DYNotificationBanner(notification: notification, frameWidth: min(450, UIScreen.main.bounds.size.width))
                    .text(color: notification.type == .info || notification.type == .error ? .white : .primary)
                    .image(color: notification.type == .info || notification.type == .error ? .white : .primary)
                    .dropShadow(color: self.colorScheme == .light ? .gray.opacity(0.4) : .clear, radius: 5, x: 0, y: notification.displayEdge == .top ? 5 : -5)
                    .cornerRadius(self.cornerRadius)
            })
    }
    
    var cornerRadius: CGFloat {
        guard UIDevice.current.userInterfaceIdiom == .phone else {
            return 10
        }
        return UIScreen.main.bounds.width < UIScreen.main.bounds.height ? 0 : 5
    }
}

#Preview {
    
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return ContentView()
        .modelContainer(container)
}
