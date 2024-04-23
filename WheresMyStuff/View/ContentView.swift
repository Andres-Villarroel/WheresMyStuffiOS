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
    let tempName = "Miscellaneous"
    let newCategory = CategoryDataModel(name: tempName)
    container.mainContext.insert(newCategory)
    return ContentView()
        .modelContainer(container)
        .environmentObject(DYNotificationHandler())
//        .environment(\.locale, .init(identifier: "es"))
        .environmentObject(GlobalConstant())
        .environmentObject(StoreKitManager())
}
