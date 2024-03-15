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
    
    
    var body: some View {
        VStack {
            NavigationView {
                
                FormView(nextScreen: changeScreen, item: $item )
                
                .navigationTitle("Add Item")
                
            } //end navigationView
        }// end vstack
    }// end body
    
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
