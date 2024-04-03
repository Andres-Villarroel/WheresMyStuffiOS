//
//  RecentsCards.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//


/*
 Try turning these default cards into views for a more seamless implmentation
 in the future when you have to add the default behavior functionality
 */
import SwiftUI
import SwiftData

struct RecentsCards: View {
    
    @Query(sort: \ItemDataModel.date, order: .reverse) var items: [ItemDataModel]
    @State private var showRecAddSheet = false
    
    var body: some View {
        HStack{
            Spacer()
            VStack {
                //.frame(width: 170, height: 150)
                Text("Recently Added")
                    .foregroundStyle(Color.white)
                if items.isEmpty{
                    
                    ContentUnavailableView {
                        Image(systemName: "questionmark")
                    } description: {
                        Text("Your most recently added item will appear here")
                    }
                        .frame(width: 170, height: 150)
                } else{
                    
                    //making the item cards a button to trigger a sheet view
                    Button (action: {
                        showRecAddSheet.toggle()
                    },
                    label: {
                        ItemCardView(imageData: items[0].image, itemName: items[0].name, itemLocation: items[0].location)
                    })
                    .buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showRecAddSheet) {
                        ItemSheetView(item: items[0])
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
                        Text("Your most recently seen item will appear here")
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
    //RecentsCards()
    let container = try! ModelContainer(for: ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    container.mainContext.insert(newItem)
    return RecentsCards()
        .modelContainer(container)
}
