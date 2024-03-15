//
//  CategoryItemsListView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/14/24.
//

import SwiftUI
import SwiftData

/*
 - creates a list of items based on a chosen cateogry.
 - the cateogry is passed as an argument to build the list
 */
struct CategoryItemsListView: View {
    
    //setting up swiftdata prerequisites
    @Query var items: [ItemDataModel]
    @Environment(\.modelContext) var context
    @State var itemSelected: ItemDataModel?     //used to help implement sheet mechanic
    
    //initializing items by filtering out the items that do not match the chosen category
    init(chosenCategory: String) {
        _items = Query(filter: #Predicate<ItemDataModel> {item in
            item.category == chosenCategory
        })
    }
    var body: some View {
        
        //creates the list
        List{
            ForEach(items) { item in
                //if an item it tapped upon, a detail sheet will appear
                    Button {
                        itemSelected = item
                        item.lastViewDate = Date.now
                    } label: {
                        ItemCell(item: item)
                    }
                    .buttonStyle(PlainButtonStyle())
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
        }//end list
        .sheet(item: $itemSelected) { item in
            ItemSheetView(item: item)
        }
        /*
         let array = []

             @State private var isPresentingUser: User? = nil

             var body: some View {
                 ForEach(array, id: \.id) { user in array
                     Button(user.name) {
                         isPresentingUser = user
                     }
                 }
                 .sheet(item: $isPresentingUser) { user in
                     SheetView(name: user.name)
                 }
             }
         */
        
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
    let secondItem = ItemDataModel(name: "PSP", location: "Closet middle", category: "Desk", notes: "Second added")
    secondItem.image = data
    let thirdItem = ItemDataModel(name: "Dehumidifier", location: "Chloe's Crate", category: "Desk", notes: "Third added")
    thirdItem.image = data
    
    container.mainContext.insert(newItem)
    container.mainContext.insert(firstItem)
    container.mainContext.insert(secondItem)
    container.mainContext.insert(thirdItem)
//    let itemsArray = [
//        firstItem,
//        secondItem,
//        thirdItem
//    ]
    
    let tempArray = ["testMiscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    
    container.mainContext.insert(newCategory)
    
    //
    return CategoryItemsListView(chosenCategory: "Desk")
        .modelContainer(container)
}
