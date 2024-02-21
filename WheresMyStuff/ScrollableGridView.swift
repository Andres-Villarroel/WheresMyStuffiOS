//
//  ScrollableGridView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI

struct ScrollableGridView: View {
    var body: some View {
        
        let placeholderLayout = [
            GridItem(.fixed(80)),
            GridItem(.fixed(80)),
            GridItem(.fixed(80))
        ]
        
        ScrollView{
            LazyVGrid(columns: placeholderLayout){
                ForEach(0..<100){
                    Text("Item \($0)")
                }
            }
        }
    }
}

#Preview {
    ScrollableGridView()
}
