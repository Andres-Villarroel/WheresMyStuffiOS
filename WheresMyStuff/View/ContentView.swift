//
//  ContentView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/2/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //to use below: uncomment it...
    //@StateObject var pickerOptions: Category = Category()
    
    var body: some View {
        //TabBarView().environmentObject(pickerOptions)
        //TabBarView(pickerItems: pickerOptions)    //...and this
        TabBarView()
    }
}

#Preview {
    
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
        return ContentView()
            .modelContainer(container)
}
