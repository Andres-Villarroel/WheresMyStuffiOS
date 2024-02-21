//
//  ContentView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI

struct BrowseView: View {
    var body: some View {
        NavigationStack {
            
            VStack {
                Text("Browse")
                RecentsCards()
                
                Text("Categories")
                //add scrollview here
                ScrollableGridView()
                    .background(Color(.red))
                    .padding()
            }
        }
        .navigationTitle("Browse")
    }
}

#Preview {
    BrowseView()
}
