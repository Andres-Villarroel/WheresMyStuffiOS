//
//  ContentView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var pickerOptions = Category()
    
    var body: some View {
        TabBarView().environmentObject(pickerOptions)
    }
}

#Preview {
    ContentView()
}
