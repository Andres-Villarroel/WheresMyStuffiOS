//
//  MainView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var selection = 2
    
    var body: some View {
        TabView(selection:$selection){
            AddItemView()
                .tabItem{
                    Label("Add", systemImage: "plus")
                }
                .tag(1)
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
    TabBarView()
    
}
