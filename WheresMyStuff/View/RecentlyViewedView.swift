//
//  RecentlyViewedView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/5/24.
//

import SwiftUI
import SwiftData
import os
struct RecentlyViewedView: View {
    
//    @Query(sort: \ItemDataModel.lastViewDate, order: .reverse) var items: [ItemDataModel]
    @Query var items: [ItemDataModel]
    @State private var showRecViewSheet = false
    init(){
        _items = Query(sort: \ItemDataModel.lastViewDate, order: .reverse)
    }
    
    var body: some View {
        Button (action: {
            showRecViewSheet.toggle()
        },
        label: {
//            ItemCardView(imageData: items[0].image, itemName: items[0].name, itemLocation: items[0].location)   //index out of range crash
            ItemCardView(providedItem: items.first ?? ItemDataModel(name: "error", location: "error", category: "error", notes: "error"))
        })
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showRecViewSheet) {
            ItemSheetView(item: items.first ?? ItemDataModel(name: "error", location: "error", category: "error", notes: "error"), canEdit: true)
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    container.mainContext.insert(newItem)
    return RecentlyViewedView()
        .modelContainer(container)
}

