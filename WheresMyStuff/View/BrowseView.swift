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
    @Binding var selection: Int
    
    //@ObservedObject var pickerItems: Category //to use the observed object, uncomment this...
    
    @State private var showingAlert = false
    @State private var newCategoryName = ""
    
    var body: some View {
        
        NavigationStack {
            
            VStack {
                
                Text("Browse")
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
                
                //consider the ContentUnavailableView() here
                RecentsCards()
                    .frame(maxHeight: 200)
                
                Text("Categories")
                //add list here
                 List(categories[0].categoryList, id:\.self){ cat in
                     Text(cat)
                 }
            }
        }
    }
    
    func submit(){
        //add newCategoryName to categories array
        //pickerOptions.append(newCategoryName)
        //let newCategory = CategoryDataModel(name: newCategoryName)
        //modelContext.insert(newCategory)
        //pickerItems.categoryList.append(newCategoryName)
        //pickerItems.appendNewCategory(newCat: newCategoryName)    //..and this
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
    return BrowseView(selection: .constant(2))
            .modelContainer(container)
    
}
