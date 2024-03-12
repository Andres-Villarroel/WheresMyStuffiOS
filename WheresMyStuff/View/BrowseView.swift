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
    
    //used for adding a new category
    @State private var showingAlert = false
    @State private var newCategoryName = ""
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Text("Browse")
                //this section add the tool bar button to add a new category
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing){
                            Button("Add Category"){
                                showingAlert.toggle()
                                print(modelContext.sqliteCommand)
                            }
                            .alert("Enter Category Name", isPresented: $showingAlert){
                                TextField("Enter Cateory Name", text: $newCategoryName)
                                Button("OK", action: submit)
                                Button("Cancel") {
                                    newCategoryName = ""
                                }
                            } message: {
                                Text("")
                            }
                        }
                    }
                
                //These show the recently viewed and added items views
                RecentsCards()
                    .frame(maxHeight: 200)
                
                //lists the categories
                Text("Categories")  //Consider making this a tab selection view to choose to browse between items and categories
                 List(categories[0].categoryList, id:\.self){ cat in
                     Text(cat)
                 }
            }
        }
    }
    
    
    func submit(){
        //add newCategoryName to categories array
        categories[0].categoryList.append(newCategoryName)
        
        print("You entered \(newCategoryName)")
        newCategoryName = ""
        
        print("Printing swiftdata address:")
        //COMMENT THIS OUT WHEN DEBUGGING IS NOT NEEDED
        print(modelContext.sqliteCommand)
    }

}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    container.mainContext.insert(newItem)
    let tempArray = ["testMiscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return BrowseView()
            .modelContainer(container)
    
}
