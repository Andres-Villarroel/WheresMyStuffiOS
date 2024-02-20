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
                HStack{
                    VStack {
                        Text("Recently Added")
                        Text("Your most recently added item will show up here")
                            .padding()
                            //.frame(maxHeight: .infinity)
                            .background(Rectangle().stroke())
                            .multilineTextAlignment(.center)
                            
                    }
                    .padding()
                    VStack {
                        Text("Recently Viewed")
                        Text("Your last viewed item will appear here")
                            .padding()
                            .background(Rectangle().stroke())
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
            }
            .padding()
        }
    }
}

#Preview {
    BrowseView()
}
