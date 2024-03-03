//
//  ContentView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/2/24.
//

import SwiftUI

struct ContentView: View {
    //@StateObject var pickerOptions = Category()
    @StateObject var pickerOptions: Category = Category()
    
    var body: some View {
        //TabBarView().environmentObject(pickerOptions)
        TabBarView(pickerItems: pickerOptions)
    }
}

#Preview {
    ContentView()
}
