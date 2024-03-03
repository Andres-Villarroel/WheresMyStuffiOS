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
    //@Query var categories: [CategoryDataModel]
    //@ObservedObject var pickerItems = Category()    //to be used for the list
    @ObservedObject var pickerItems: Category
    
    
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
                
                //consider the ContenetUnavailableView() here
                RecentsCards()
                
                Text("Categories")
                //add list here
                 
                List (pickerItems.categoryList, id:\.self) { categories in
                    Text(categories)
                }
                 
                /*
                 Note: you cant use observable, stateobject, and environment to make the array of category strings into a list since they do not have an identifiable like UUID or adhere to the Identifiable protocol. You tried using a swift data model to make the category list as it automatically conforms to the identifiable protocol but you found it damn near impossible to convert it into an array as that is what the Picker() view needs to read from
                 */
//                The List {} below could not be completed due to above note.
//                List{
//                    ForEach(pickerItems.categoryList) { category in
//                        //REPLACE TEXT() BELOW WITH A NAVIGATION LINK
//                        Text(category)
//                    }
//                }
                //items wont show up here due to limitations of Xcode's Live Preview, just run to view them
                //ItemsListView()
                
            }
        }
    }
    
    func submit(){
        //add newCategoryName to categories array
        //pickerOptions.append(newCategoryName)
        //let newCategory = CategoryDataModel(name: newCategoryName)
        //modelContext.insert(newCategory)
        //pickerItems.categoryList.append(newCategoryName)
        pickerItems.appendNewCategory(newCat: newCategoryName)
        
        print("You entered \(newCategoryName)")
        newCategoryName = ""
        
        print("Printing swiftdata address:")
        //COMMENT THIS OUT WHEN DEBUGGING IS NOT NEEDED
        print(modelContext.sqliteCommand)
    }
    
}

#Preview {
    BrowseView(pickerItems: Category())
 
}
