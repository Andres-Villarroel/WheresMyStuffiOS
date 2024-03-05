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
            VStack {
                Text("Recently Added")
                if items.isEmpty{
                    Text("Your most recently added item will show up here")
                        .padding()
                        .background(Rectangle().stroke())
                        .multilineTextAlignment(.center)
                    
                } else{
                    ItemCardPreview(imageData: items[0].image, itemName: items[0].name)
                }
                
            }
            .padding()
            
            VStack {
                Text("Recently Viewed")
                if(items.isEmpty){
                    Text("Recently Viewed")
                    Text("Your last viewed item will appear here")
                        .padding()
                        .background(Rectangle().stroke())
                        .multilineTextAlignment(.center)
                } else {
                    RecentlyViewedView()
                }
            }
            .padding()
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
    container.mainContext.insert(newItem)
    return RecentsCards()
        .modelContainer(container)
}
