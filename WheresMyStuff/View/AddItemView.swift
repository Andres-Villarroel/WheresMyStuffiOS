//
//  AddItemView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData


struct AddItemView: View {
    
    //SwiftData
    @Query var categories: [CategoryDataModel]
    @Environment(\.modelContext) var modelContext
    @Binding var selection: Int
    @State var item = ItemDataModel(name: "", location: "", category: "Miscellaneous", notes: "")
    
    //used for adding a new category
    @State private var showingAlert = false
    @State private var newCategoryName = ""
    
    var body: some View {
        
        VStack {
            NavigationStack {
                
                FormView(nextScreen: changeScreen, item: $item )
//                FormView(item: $item)
                    .navigationTitle("Add Item")
                //this section add the tool bar button to add a new category
                    .toolbar{
                        ToolbarItem(placement: .topBarTrailing){
                            Button("Add Category"){
                                showingAlert.toggle()
                                print(modelContext.sqliteCommand)
                            }
                            .alert("Enter Category Name", isPresented: $showingAlert){
                                TextField("Enter Cateory Name", text: $newCategoryName)
                                Button("OK", action: submitCategory)
                                Button("Cancel") {
                                    newCategoryName = ""
                                }
                            } message: {
                                Text("")
                            }
                        }
                    }
                
            } //end navigationStack
        }// end vstack
        
    }// end body
    
    func submitCategory(){
        //add newCategoryName to categories array
        categories[0].categoryList.append(newCategoryName)
        
        print("You entered \(newCategoryName)")
        newCategoryName = ""
        
        //COMMENT THIS OUT WHEN DEBUGGING IS NOT NEEDED
        //print("Printing swiftdata address:")
        //print(modelContext.sqliteCommand)
    }
    func changeScreen(){
        selection = 2
    }
}



#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return AddItemView(selection: .constant(2))
        .modelContainer(container)
    
}
