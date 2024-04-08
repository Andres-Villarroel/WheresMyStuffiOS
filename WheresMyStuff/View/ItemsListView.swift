//TODO: REFACTOR THIS FILE ALONG WITH CATEGORYITEMSLISTVIEW() AS THY APPEAR THE SAME AND USE THE SAME LAYOUT FOR THE SHEETS FEATURE

import SwiftUI
import SwiftData

struct ItemsListView: View {
    
    //access to swiftdata model context and swiftdata model
    @Environment(\.modelContext) var context
    @State var itemSelected: ItemDataModel? //to be used to help implement sheet feature
    @Query var items: [ItemDataModel]
    
    init (filterString: String) {
        let predicate  = #Predicate<ItemDataModel>{ item in
            item.name.localizedStandardContains(filterString) ||
            item.location.localizedStandardContains(filterString) ||
            filterString.isEmpty
        }
        
        _items = Query(filter: predicate)   //reinitializes reinitializes the queried items array to now include the predicate (search filter)
    }
    
    var body: some View {
        if !items.isEmpty {
            List{
                //using ForEach due to its access to the .onDelete modifier
                ForEach(items) { item in
                    Section{
                        Button {
                            itemSelected = item
                            item.lastViewDate = Date.now
                        } label: {
                            ItemCell(item: item)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .listSectionSpacing(10)
                }
                .onDelete{ indexSet in
                    for index in indexSet{
                        print("LOG Before deleting in ItemsListView, Items has \(items.count) items")
                        context.delete(items[index])
                        print("LOG After deleting in ItemsListView, Items has \(items.count) items")
                    }
                }
                //making the item cells look better
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(
                    Color.clear
                )
                .tint(Color.red)
                
            }//end list
            .scrollContentBackground(.hidden)
            .sheet(item: $itemSelected) { item in
                ItemSheetView(item: item)
            }
        }//end if
        else {
            ContentUnavailableView {
                VStack{
                    Image("notFoundRooster")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 150)
                    Text("No Results")
                }
            } description: {
                Text("Check the spelling or try a new search.")
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
    
    let tempArray = ["testMiscellaneous"]
    for cat in tempArray{
        let newCategory = CategoryDataModel(name: cat)
        container.mainContext.insert(newCategory)
    }
    
    container.mainContext.insert(newItem)
    container.mainContext.insert(firstItem)
    container.mainContext.insert(secondItem)
    container.mainContext.insert(thirdItem)
    return ItemsListView(filterString: "")
        .modelContainer(container)
}
