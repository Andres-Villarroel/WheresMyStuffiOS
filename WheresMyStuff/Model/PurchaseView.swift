import SwiftUI
import StoreKit
import os
struct PurchaseView: View {
    @EnvironmentObject var storekit: StoreKitManager
    let log = Logger(subsystem: "WheresMyStuff", category: "PurchaseView")
    
    var body: some View {
        VStack{
            if(!storekit.storeProducts.isEmpty){
                let product = storekit.storeProducts.first!
                
                VStack {
                    Text("Full Version")
                        .font(.title)
                        .bold()
                    Text("Unlocks the full version of the app")
                        .foregroundStyle(Color.gray)
                    Button(action: {
                        Task {
                            try await storekit.purchase(product)
                        }
                    }, label: {
                        if(!storekit.didPurchaseFullVersion()){
                            Text(product.displayPrice)
                                .padding(12)
                                .bold()
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                        } else {
                            Image(systemName: "checkmark")
                                .padding(5)
                        }
                    })
                    .tint(Color.blue)
                    .disabled(storekit.didPurchaseFullVersion())
                }
                .padding()
            
            Button(action: {
                Task{
                    try await storekit.restore()
                }
            }, label: {
                Text("Restore Purchase")
            })
            .tint(Color.blue)
            .font(.title3)
                
            }//end if-statement
        }//end vstack
    }
}

#Preview {
    return PurchaseView()
        .environmentObject(StoreKitManager())
        .environment(\.locale, .init(identifier: "es"))
}
/*
 import SwiftUI
 import StoreKit
 import os
 struct PurchaseView: View {
     @EnvironmentObject var storekit: StoreKitManager
     let log = Logger(subsystem: "WheresMyStuff", category: "PurchaseView")
     
     var body: some View {
         VStack{
             ForEach(storekit.storeProducts){ product in
                 VStack {
                     Text(product.displayName)
                         .font(.title)
                         .bold()
                     Text(product.description)
                         .foregroundStyle(Color.gray)
                     Button(action: {
                         Task {
                             try await storekit.purchase(product)
                         }
                     }, label: {
                         if(!storekit.didPurchaseFullVersion()){
                             Text(product.displayPrice)
                                 .padding(12)
                                 .bold()
                                 .background(.ultraThinMaterial)
                                 .clipShape(RoundedRectangle(cornerRadius: 50))
                         } else {
                             Image(systemName: "checkmark")
                                 .padding(5)
                         }
                     })
                     .tint(Color.blue)
                     .disabled(storekit.didPurchaseFullVersion())
                 }
                 .padding()
             }
             
             Button(action: {
                 Task{
                     try await storekit.restore()
                 }
             }, label: {
                 Text("Restore Purchase")
             })
             .tint(Color.blue)
             .font(.title3)
         }//end vstack
     }
 }

 #Preview {
     return PurchaseView()
         .environmentObject(StoreKitManager())
         .environment(\.locale, .init(identifier: "es"))
 }

 */
