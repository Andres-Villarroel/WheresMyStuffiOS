//
//  ContentView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData

struct BrowseView: View {
    //loading swift data database contents and components
    @Environment(\.modelContext) var modelContext
    @Query var items: [ItemDataModel]
    @Query var categories: [CategoryDataModel]
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                //MARK: Background Image
                Image("appBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea(.all)
                
                VStack {
                    //These show the recently viewed and added items views
                    RecentsCards()
                    
                    //lists the categories
                    Text("Categories")  //Consider making this a tab selection view to choose to browse between items and categories
                        .padding([.top, .bottom])
                        .foregroundStyle(Color.white)
                    
                    //MARK: category list
                    if(!categories.isEmpty){
                        List{
                            ForEach(categories, id: \.self){ cat in
                                
                                NavigationLink (cat.name){
                                    CategoryItemsListView(chosenCategory: cat.name)
                                }
                                .listRowSeparatorTint(Color.white)
                                .listRowBackground(Color.clear)
//                                .listRowBackground(border(Color.red))
                            }
                            .onDelete{ indexSet in
                                for index in indexSet{
                                    modelContext.delete(categories[index])
                                }
                            }
                            
                        }// end list
                        .listStyle(.plain)  //without this, the first row starts too low
//                        .scrollContentBackground(.hidden)
                        .background(.ultraThinMaterial)
                        .background(Color.clear)
                        .cornerRadius(20)
                        .padding([.leading, .trailing, .bottom], 38)
                    } else {
                        //MARK: Add category button
                        AddCategoryView()
                            .padding(100)
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        Spacer()
                    }
                }//end vstack
                .navigationTitle("Browse")
                .navigationBarTitleDisplayMode(.inline)
            }//end zstack
        }//end navigation stack
    }//end body
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
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
    container.mainContext.insert(otherCategory)
    return BrowseView()
        .modelContainer(container)
    
}
