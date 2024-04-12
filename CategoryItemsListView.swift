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
    private var categoryName: String
    
    //initializing items by filtering out the items that do not match the chosen category
    init(chosenCategory: String) {
        categoryName = chosenCategory   //TODO: Possible point of error in the future
        
        _items = Query(filter: #Predicate<ItemDataModel> {item in
            item.category == chosenCategory //chosenCategory is provided, database is queried to match any item that has the matching category name
        })
    }
    var body: some View {
        NavigationStack {
            ZStack{
                //MARK: Background Image
                Image("appBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .ignoresSafeArea(.all)
                
                VStack{
                    if items.isEmpty {
                        ContentUnavailableView {
                            VStack{
                                Image("notFoundRooster")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 150)
                                Text("No Items Here...")
                            }
                        } description: {
                            Text("Add items under the '\(categoryName)' category to fill this page.")
                        }
                    } else {
                        List{
                            ForEach(items) { item in
                                    //if an item it tapped upon, a detail sheet will appear
                                Button {
                                    itemSelected = item
                                    item.lastViewDate = Date.now
                                } label: {
                                    ItemCell(item: item)
                                }
                                .listRowSeparatorTint(Color.white)
                                .buttonStyle(PlainButtonStyle())
                                .alignmentGuide(.listRowSeparatorLeading) { _ in
                                    100
                                }
                                .listRowBackground(Color.clear)
                                
                            }
                            .onDelete{ indexSet in
                                for index in indexSet{
                                    print("LOG Before deleting in categoryItemsList, Items has \(items.count) items")
                                    context.delete(items[index])
                                    try? context.save()
                                    print("LOG After deleting in categoryItemsList, Items has \(items.count) items")
                                }
                            }
                            
                        }//end list
                        .sheet(item: $itemSelected) { item in
                            ItemSheetView(item: item)
                        }
                        .scrollContentBackground(.hidden)
                    }//end else
                }//end vstack
            }//end zstack
            .navigationTitle(categoryName)
            .navigationBarTitleDisplayMode(.large)
        }//end navigation stack
    }// end body
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
    for cat in tempArray{
        let newCategory = CategoryDataModel(name: cat)
        container.mainContext.insert(newCategory)
    }
    
    
    return CategoryItemsListView(chosenCategory: "Desk")
        .modelContainer(container)
}
