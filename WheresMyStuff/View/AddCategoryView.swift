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
            Button("OK", action: submitCategory)
            Button("Cancel") {
                newCategoryName = ""
            }
        }

    }//end view
    
    private func submitCategory(){
        modelContext.insert(CategoryDataModel(name: newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)))
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
