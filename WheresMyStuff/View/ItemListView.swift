//
//  ItemListView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/5/24.
//

import SwiftUI
import SwiftData

struct ItemListView: View {
    @Query (sort: \ItemDataModel.date, order: .reverse) var items: [ItemDataModel]
    
    var body: some View {
//        List (items){ item in
//            Text(item.name)
//        }
        Text(items[0].name)
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
    return ItemListView()
        .modelContainer(container)
}
