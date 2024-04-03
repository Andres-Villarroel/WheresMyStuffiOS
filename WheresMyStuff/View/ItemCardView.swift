//
//  ItemCardPreview.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/5/24.
//

import SwiftUI
import SwiftData

struct ItemCardView: View {
    let imageData: Data?
    let itemName: String
    let itemLocation: String
    
    var body: some View {
        
        VStack(spacing: 0){
            if(imageData != nil){
                let image = UIImage(data: imageData!)
                Image(uiImage: image!)
                    .resizable()
                    .frame(width: 200, height: 200)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .frame(width: 200, height: 200)
            }
            VStack{
                Text(itemName)
                    .bold()
                Text(itemLocation)
                    .padding(.bottom, 1.5)
            }
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .opacity(0.8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
}

#Preview {
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    
    return ItemCardView(imageData: data, itemName: "testName", itemLocation: "bottom closet")
}
