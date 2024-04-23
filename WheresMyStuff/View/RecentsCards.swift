import SwiftUI
import SwiftData
import os
struct RecentsCards: View {
    
    @Query var items: [ItemDataModel]
    @State private var showRecAddSheet = false
    let log = Logger()
    init(){
        _items = Query(sort: \ItemDataModel.creationDate, order: .reverse)
    }
    
    var body: some View {
        HStack{
            Spacer()
            VStack {
                Text("Recently Added")
                    .foregroundStyle(Color.white)
                if items.isEmpty{
                    ContentUnavailableView {
                        Image(systemName: "questionmark")
                    } description: {
                        Text("No items found")
                    }
                        .frame(width: 170, height: 150)
                        
                } else{
                    
                    //making the item cards a button to trigger a sheet view
                    Button (action: {
                        showRecAddSheet.toggle()    //TODO: consider replacing this with a navigation link
                        log.info("Button pressed to show recently added item SHEET. RecentsCards.swift")
                        log.info("Current items count: \(items.count) as of \(Date.now) RecentsCards.swift")
                    },
                    label: {
                        ItemCardView(providedItem: items.first ?? ItemDataModel(name: "Error", location: "Error", category: "Error", notes: "Error"))
                    })
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showRecAddSheet) {
                        ItemSheetView(item: items.first ?? ItemDataModel(name: "Error", location: "Error", category: "Error", notes: "Error"), canEdit: true)
                    }
                    
                }
                
            }   //card 1
            
            Spacer()
            VStack {
                Text("Recently Viewed")
                    .foregroundStyle(Color.white)
                if(items.isEmpty){
                    ContentUnavailableView {
                        Image(systemName: "questionmark")
                    } description: {
                        Text("No items found")
                    }
                        .frame(width: 170, height: 150)
                        
                } else {
                    RecentlyViewedView()
                }
            }// card 2
        
            Spacer()
        }// end Hstack
        
    }// end body
}// end struct

#Preview {
    let container = try! ModelContainer(for: ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//        let image = UIImage(named: "tiltedParrot")!
    let image = UIImage(named: "debugImage")!
    let data = image.pngData()
//    let data = image!.pngData()
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    container.mainContext.insert(newItem)
    return RecentsCards()
        .modelContainer(container)
}
