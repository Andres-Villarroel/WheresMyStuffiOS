//
//  RecentlyViewedView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/5/24.
//

import SwiftUI
import SwiftData

struct RecentlyViewedView: View {
    
    @Query(sort: \ItemDataModel.lastViewDate, order: .reverse) var items: [ItemDataModel]
    
    var body: some View {
        
        ItemCardPreview(imageData: items[0].image, itemName: items[0].name)
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

