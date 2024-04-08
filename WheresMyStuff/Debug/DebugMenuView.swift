//
//  DebugMenuView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 4/7/24.
//

import SwiftUI
import SwiftData

struct DebugMenuView: View {
    @Query var items: [ItemDataModel]
    @Query var categories: [CategoryDataModel]
    var body: some View {
        VStack{
            Button("List items"){
                for i in items{
                    print(i.name)
                }
                //            items.forEach() {
                //                print($0)
                //            }
            }
            .padding(.bottom, 30)
            Button("List Categories"){
                for cat in categories[0].categoryList {
                    print(cat)
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "testMiscellaneous", notes: "test notes")
    let secondItem = ItemDataModel(name: "second name", location: "second location", category: "testMiscellaneous", notes: "test notes")
    let thirdItem = ItemDataModel(name: "third name", location: "third location", category: "testMiscellaneous", notes: "test notes")
    
    newItem.image = data
    secondItem.image = data
    thirdItem.image = data
    
    container.mainContext.insert(newItem)
    container.mainContext.insert(secondItem)
    container.mainContext.insert(thirdItem)
    
    let tempArray = ["testMiscellaneous", "otherCategory"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return DebugMenuView()
        .modelContainer(container)
    }
