//
//  addPhotoFieldView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/22/24.
//

import SwiftUI

struct addPhotoFieldView: View {
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .padding(50)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [10,5]))
            )
            .overlay(
                PhotosPickerView()
                    .frame(width: 80, height: 80)
            )
            .padding()
    }
}

#Preview {
    addPhotoFieldView()
}
