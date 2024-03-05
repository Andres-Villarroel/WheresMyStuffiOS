//
//  MainView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData

struct TabBarView: View {
    @State private var selection = 2
    
    //To use pickerItems again, uncomment the line below...
    //@ObservedObject var pickerItems: Category
    
    var body: some View {
        TabView(selection:$selection){
            
            //AddItemView(pickerItems: pickerItems) //...and this
            AddItemView()
                .tabItem{
                    Label("Add", systemImage: "plus")
                }
                .tag(1)
            //BrowseView(pickerItems: pickerItems)  //..and this
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "list.dash")
                }
                .tag(2)
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(3)
        }
    }
}

#Preview {
    //@ObservedObject var pickerItems: Category
    //TabBarView(pickerItems: pickerItems)
    //TabBarView(pickerItems: Category())
    
    //return TabBarView()
    //preview kept crashing, reason was that the isolated container used in AddItemView and BrowseView() should also be used here as it calls those views in TabView()
    let container = try! ModelContainer(for: CategoryDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
        return TabBarView()
            .modelContainer(container)

    
}
