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
                //consider the ContenetUnavailableView() here
                RecentsCards()
                
                Text("Categories")
                //add scrollview here
                ScrollableGridView()
                    .background(Color(.red))
                    .cornerRadius(30.0)
                    .padding()
                
            }
        }
    }
}

#Preview {
    BrowseView()
}
