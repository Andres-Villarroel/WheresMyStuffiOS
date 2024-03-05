//
//  ItemCardPreview.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/5/24.
//

import SwiftUI
import SwiftData

struct ItemCardPreview: View {
    
    //sorted by date created in reverse order.
    //items[0] will now be the most recently created item.
    //@Query(sort: \ItemDataModel.date, order: .reverse) var items: [ItemDataModel]
    let imageData: Data?
    let itemName: String
    
    var body: some View {
        
//        let itemImage = UIImage(data: items[0].image!)  //this is an optional
//        let itemName = items[0].name
        let imageProcessed = UIImage(data: imageData!)
        VStack{
            Image(uiImage: imageProcessed!)
                .resizable()
                .scaledToFit()
                .padding(.top)
                //.frame()
            Text(itemName)
        }
        //.padding(/*@START_MENU_TOKEN@*/EdgeInsets()/*@END_MENU_TOKEN@*/)
        .padding(5)
        .background(Color.gray)
        .cornerRadius(10.0)
    }
}

#Preview {
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    
    return ItemCardPreview(imageData: data, itemName: "testName")
}
