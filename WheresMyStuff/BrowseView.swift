//
//  ContentView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData

struct BrowseView: View {
    @Query var items: [ItemDataModel]
    
    var body: some View {
        NavigationStack {
            
            VStack {
                
                Text("Browse")
                Button("Show database contents"){
                    
                }
                //consider the ContenetUnavailableView() here
                RecentsCards()
                
                Text("Categories")
                //add scrollview here
                ItemsListView()
//                ScrollableGridView()
//                    .background(Color(.red))
//                    .cornerRadius(30.0)
//                    .padding()
                
            }
        }
    }
}

#Preview {
    BrowseView()
}
