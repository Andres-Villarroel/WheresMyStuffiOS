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
    
    var body: some View {
        HStack{
            Spacer()
            VStack {
                //.frame(width: 170, height: 150)
                Text("Recently Added")
                if items.isEmpty{
                    
                    ContentUnavailableView {
                        Image(systemName: "questionmark")
                    } description: {
                        Text("Your most recently added item will appear here")
                    }
                        .frame(width: 170, height: 150)
                } else{
                    ItemCardPreview(imageData: items[0].image, itemName: items[0].name, itemLocation: items[0].location)
                }
                
            }
            
            Spacer()
            VStack {
                Text("Recently Viewed")
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
            }
        
            Spacer()
        }
        
    }
}

#Preview {
    //RecentsCards()
    let container = try! ModelContainer(for: ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    //container.mainContext.insert(newItem)
    return RecentsCards()
        .modelContainer(container)
}
