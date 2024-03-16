//
//  SearchView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    
    //accessing swiftdata content
    @Query var items: [ItemDataModel]
    //    @State private var searchText = ""  //holds the user's search term
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        //ItemsListView()
        NavigationStack {
            ItemsListView(items: viewModel.calculateSearch())
                .onAppear() {
                    viewModel.items = items
                    
                }
                .navigationTitle("Search Items")
        }
        .searchable(text: $viewModel.searchText, prompt: "What do you want to find?")     //this provides the search function such as the built-in search bar
        .overlay {
            //should the search not find anything, this view will appear with a message notifying the user of search failure
            if viewModel.calculateSearch().isEmpty {
                ContentUnavailableView.search
            }
        }
        
    }
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    let firstItem = ItemDataModel(name: "Pen", location: "Desk", category: "Desk", notes: "First added")
    firstItem.image = data
    let secondItem = ItemDataModel(name: "PSP", location: "Closet middle", category: "Closet", notes: "Second added")
    secondItem.image = data
    let thirdItem = ItemDataModel(name: "Dehumidifier", location: "Chloe's Crate", category: "My Bedroom", notes: "Third added")
    thirdItem.image = data
    
    container.mainContext.insert(newItem)
    container.mainContext.insert(firstItem)
    container.mainContext.insert(secondItem)
    container.mainContext.insert(thirdItem)
    container.mainContext.insert(newItem)
    let tempArray = ["testMiscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return SearchView()
        .modelContainer(container)
}
