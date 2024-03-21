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
            
            VStack {
                
                Text("Browse")
                
                //These show the recently viewed and added items views
                RecentsCards()
                
                //lists the categories
                Text("Categories")  //Consider making this a tab selection view to choose to browse between items and categories
                    .padding(.top)
                
                //TODO: use navigation links to create a list of only the tapped category
                List(categories[0].categoryList, id:\.self){ cat in
                    //use cat to select the category
                    
                    NavigationLink {
                        //navigation link/destination using cat
                        CategoryItemsListView(chosenCategory: cat)
                            .navigationTitle(cat)
                    } label: {
                        Text(cat)
                    }
                }
            }//end vstack
        }// end navigation stack
    }//end body
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
    
    let tempArray = ["testMiscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return BrowseView()
            .modelContainer(container)
    
}
