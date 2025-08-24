import SwiftUI
import SwiftData

struct BrowseView: View {
    //loading swift data database contents and components
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var constants: GlobalConstant
    @Query var items: [ItemDataModel]
    @Query var categories: [CategoryDataModel]
    @State var showAddCategoryView = false
    @State private var keyboardHeight: CGFloat = 0
    @State var categoryCount: Int?
    
    var body: some View {
        NavigationStack {
                ZStack {
                    
                    VStack{
                        //These show the recently viewed and added items views
                        RecentsCards(categoryCount: $categoryCount)
                            .onAppear{
                                categoryCount = categories.count
                            }
                        
                        //quick statistics
//                        HStack{
//                            Spacer()
//                            Text("Total Items: \(items.count)")
//                            Spacer()
//                            Text("Total Categories: \(categories.count)")
//                            Spacer()
//                        }
                        
                        //category labels
                        ZStack {
                            Text("Categories")  //Consider making this a tab selection view to choose to browse between items and categories
                                .foregroundStyle(Color.white)
                                .bold()
                            
                            Button("+Category"){
                                showAddCategoryView.toggle()
                            }
                            .tint(constants.buttonColor)
                            .padding(.trailing, 15)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
//                        .padding([.top, .bottom])
                        
                        //MARK: category list
                        if(!categories.isEmpty){
                            List{
                                ForEach(categories, id: \.self){ cat in
                                    
                                    NavigationLink (cat.name){
                                        CategoryItemsListView(chosenCategory: cat.name)
                                    }
                                    .listRowSeparatorTint(Color.white)
                                    .listRowBackground(Color.clear)
                                }
                                .onDelete{ indexSet in
                                    for index in indexSet{
                                        modelContext.delete(categories[index])
                                    }
                                }
                                
                            }// end list
                            .listStyle(.plain)  //without this, the first row starts too low
                            .background(.ultraThinMaterial)
                            .background(Color.clear)
                            .cornerRadius(20)
                            .padding([.leading, .trailing, .bottom], 30)
                            .ignoresSafeArea(.keyboard)
                            
                        } else {
                            Spacer()
                            Text("No categories found. \nPress the '+Category' button \nto add a category.'")
                                .padding(15)
                                .multilineTextAlignment(.center)
                                .background(.ultraThinMaterial)
                                .cornerRadius(15)
                                .lineSpacing(5)
                            Spacer()
                        }
                    }//end vstack
                    .background(
                        Image("appBackground")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .ignoresSafeArea(.all)
                    )
                    
                    .navigationTitle("Browse")
                    .navigationBarTitleDisplayMode(.inline)
                    if(showAddCategoryView){
                        AddCategoryAlertView(showView: $showAddCategoryView)
                        
                    }
                }//end zstack
                .transition(.opacity)
        }//end navigation stack
        .tint(Color.lightPurple)
    }//end body
}


#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
//    let image = UIImage(named: "debugImage")
    let data = image.pngData()
    
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "testMiscellaneous", notes: "test notes")
    let secondItem = ItemDataModel(name: "second name", location: "second location", category: "testMiscellaneous", notes: "test notes")
    let thirdItem = ItemDataModel(name: "third name", location: "third location", category: "testMiscellaneous", notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    
    newItem.image = data
    secondItem.image = data
    thirdItem.image = data
    
    container.mainContext.insert(newItem)
    container.mainContext.insert(secondItem)
    container.mainContext.insert(thirdItem)
    
    let tempName = "testMiscellaneous"
    let otherName = "otherCategory"
    //    let newCategory = CategoryDataModel(categoryList: tempArray)
    let newCategory = CategoryDataModel(name: tempName)
    let otherCategory = CategoryDataModel(name: otherName)
    container.mainContext.insert(newCategory)
    //    container.mainContext.insert(otherCategory)
    return BrowseView()
        .modelContainer(container)
        .environmentObject(GlobalConstant())
    
}
