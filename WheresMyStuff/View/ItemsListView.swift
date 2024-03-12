//
//  ItemScrollView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/29/24.
//

import SwiftUI
import SwiftData

struct ItemsListView: View {
    //TODO: Add item sheet code here
    
    //access to swiftdata model context and swiftdata model
    @Environment(\.modelContext) var context
    @State var shouldPresentSheet = false
    
    var items: [ItemDataModel]
    
    var body: some View {
        NavigationStack {
            
            List{
                ForEach(items) { item in
                    ItemCell(item: item)
                        .onTapGesture {
                            shouldPresentSheet.toggle()
                            item.lastViewDate = Date.now
                        }
                        .sheet(isPresented: $shouldPresentSheet, content: {
                            ItemSheetView(item: item)
                        })
                }
                .onDelete{ indexSet in
                    for index in indexSet{
                        context.delete(items[index])
                    }
                }
                //making the item cells look better
                .listRowSeparator(.hidden)
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 5)
                        .background(.clear)
                    //.foregroundColor(.white)
                        .padding(
                            EdgeInsets(
                                top: 2,
                                leading: 10,
                                bottom: 2,
                                trailing: 10
                            )
                        )
                )
                
                
            }
            
        }
    }
}
#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    let firstItem = ItemDataModel(name: "Pen", location: "Desk", category: "Desk", notes: "First added")
    firstItem.image = data
    let secondItem = ItemDataModel(name: "PSP", location: "Closet middle", category: "Closet", notes: "Second added")
    secondItem.image = data
    let thirdItem = ItemDataModel(name: "Dehumidifier", location: "Chloe's Crate", category: "My Bedroom", notes: "Third added")
    thirdItem.image = data
    
    //container.mainContext.insert(newItem)
//    container.mainContext.insert(firstItem)
//    container.mainContext.insert(secondItem)
//    container.mainContext.insert(thirdItem)
    let itemsArray = [
        firstItem,
        secondItem,
        thirdItem
    ]
    
    let tempArray = ["testMiscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    
    container.mainContext.insert(newCategory)
    return ItemsListView(items: itemsArray)
        .modelContainer(container)
}
