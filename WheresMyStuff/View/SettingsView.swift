//
//  SettingsView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 4/18/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack{
            Image("appBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea(.all)
            VStack{
                PurchaseView()
            }
        }
    }
}

#Preview {
    SettingsView()
}
