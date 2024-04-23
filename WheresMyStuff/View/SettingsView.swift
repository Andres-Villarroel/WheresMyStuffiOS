import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack{
            Image("appBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea(.all)
            VStack{
                PurchaseView()
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(StoreKitManager())
}
