//
//  MainView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData

struct TabBarView: View {
    @State var selection = 2
    
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
            BrowseView(selection: $selection)
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
    
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
        return TabBarView()
            .modelContainer(container)

    
}
