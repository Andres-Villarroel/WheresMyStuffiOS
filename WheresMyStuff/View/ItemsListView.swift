
//TODO: REFACTOR THIS FILE ALONG WITH CATEGORYITEMSLISTVIEW() AS THY APPEAR THE SAME AND USE THE SAME LAYOUT FOR THE SHEETS FEATURE

import SwiftUI
import SwiftData

struct ItemsListView: View {
    
    //access to swiftdata model context and swiftdata model
    @Environment(\.modelContext) var context
    @State var itemSelected: ItemDataModel? //to be used to help implement sheet feature
    
    var items: [ItemDataModel]
    
    var body: some View {
        //        NavigationStack {
        
        List{
            //using ForEach due to its access to the .onDelete modifier
            ForEach(items) { item in
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
            .listRowInsets(.init(top: 10, leading: 0, bottom: 0, trailing: 0))
            //                making the item cells look better
            .listRowSeparator(.hidden)
            .listRowBackground(
                Color.clear
            )
        }//end list
        .scrollContentBackground(.hidden)
        .sheet(item: $itemSelected) { item in
            ItemSheetView(item: item)
        }
        //        } end navigation stack
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
