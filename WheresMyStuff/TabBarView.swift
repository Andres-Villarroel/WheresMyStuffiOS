//
//  MainView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var selection = 2
    @ObservedObject var pickerItems: Category
    
    var body: some View {
        TabView(selection:$selection){
            AddItemView(pickerItems: pickerItems)
                .tabItem{
                    Label("Add", systemImage: "plus")
                }
                .tag(1)
            BrowseView(pickerItems: pickerItems)
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
    TabBarView(pickerItems: Category())
    
}
