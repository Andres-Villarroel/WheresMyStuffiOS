//
//  ItemListView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/5/24.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
    @Query var items: [ItemDataModel]
    @Binding var selection: Int
    
    var body: some View {
        NavigationStack{
            
            List (items){ item in
                Text(item.name)
            }
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView{
                        Label("Nothing here...", systemImage: "questionmark")
                    } description: {
                        Text("No items found, go to the add screen to begin tracking your items.")
                    } actions: {
                        Text("Add an Item")
                            .foregroundStyle(Color.blue)
                            .onTapGesture {
                                selection = 1
                            }
                    }
                }
            }
            
        }
        //Text(items[0].name)
    }
}

#Preview {
    let container = try! ModelContainer(for: ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let firstItem = ItemDataModel(name: "Pen", location: "Desk", category: "Desk", notes: "First added")
    let secondItem = ItemDataModel(name: "PSP", location: "Closet middle", category: "Closet", notes: "Second added")
    let thirdItem = ItemDataModel(name: "Dehumidifier", location: "Chloe's Crate", category: "My Bedroom", notes: "Third added")
    
    container.mainContext.insert(firstItem)
    container.mainContext.insert(secondItem)
    container.mainContext.insert(thirdItem)
    return ItemListView(selection: .constant(2))
        .modelContainer(container)
}
