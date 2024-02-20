//
//  MainView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView{
            AddItemView()
                .tabItem{
                    Label("Add", systemImage: "plus")
                }
            BrowseView()
                .tabItem {
                    Label("Menu", systemImage: "list.dash")
                }
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    TabBarView()
    
}
