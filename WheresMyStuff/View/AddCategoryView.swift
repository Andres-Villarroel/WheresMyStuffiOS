//
//  AddCategoryView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 4/10/24.
//

import SwiftUI
import SwiftData
import os

struct AddCategoryView: View {
    let log = Logger(subsystem: "WheresMyStuff", category: "AddCategoryView")
    @Environment(\.modelContext) var modelContext
    @Query var categories: [CategoryDataModel]
    @State private var showAlert = false
    @State private var newCategoryName = ""
    
    var body: some View {
        
        Button("+ Add Category"){
            showAlert.toggle()
        }  //end button
        .alert("Enter Category Name", isPresented: $showAlert){
            TextField("Enter Cateory Name", text: $newCategoryName)
            Button("Submit", action: submitCategory)
                .disabled(newCategoryName.isEmpty || newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            Button("Cancel") {
                newCategoryName = ""
            }
        }

    }//end view
    
    private func submitCategory(){
        //check that there is no duplicates in category database
        if (!doesExist(categoryName: newCategoryName)){
            modelContext.insert(CategoryDataModel(name: newCategoryName))
        } else {
            //do not submit
        }
    }
    
    private func doesExist(categoryName: String) -> Bool {
        for cat in categories{
            if (cat.name == categoryName){
                return true
            }
        }
        return false
    }
    
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "testMiscellaneous", notes: "test notes")
    
    newItem.image = data
    
    container.mainContext.insert(newItem)
    
    let tempName = "testMiscellaneous"
    let newCategory = CategoryDataModel(name: tempName)
    container.mainContext.insert(newCategory)
    
    return AddCategoryView()
        .modelContainer(container)
}
