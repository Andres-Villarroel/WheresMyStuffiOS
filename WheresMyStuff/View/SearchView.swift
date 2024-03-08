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
    @State private var searchText = ""  //holds the user's search term
    
    //returns an array of ItemDataModel that gets filtered based on the user's search terms.
    var searchResults: [ItemDataModel] {
        if searchText.isEmpty{
            return items
        } else {
            let filteredItems = items.compactMap { item in
                
                //currently, the search feature compares the search terms with item.name and item.location
                let titleContainsSearch = item.name.range(of: searchText, options: .caseInsensitive) != nil
                let locationTitle = item.location.range(of: searchText, options: .caseInsensitive) != nil
                
                return (titleContainsSearch || locationTitle) ? item: nil
            }
            
            return filteredItems
        }
    }
    
    var body: some View {
        //ItemsListView()
        NavigationStack {
            ItemsListView(items: searchResults)
                .navigationTitle("Search Items")
        }
        .searchable(text: $searchText, prompt: "What do you want to find?")     //this provides the search function such as the built-in search bar
        .overlay {
            //should the search not find anything, this view will appear with a message notifying the user of search failure
            if searchResults.isEmpty {
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
