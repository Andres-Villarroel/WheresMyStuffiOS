//
//  ItemCardPreview.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/5/24.
//

import SwiftUI
import SwiftData

struct ItemCardView: View {
    var providedItem: ItemDataModel
    
    var body: some View {
        if (providedItem.image != nil){
            ZStack(alignment: .bottom){
                //sets the image depending on the state of the image data
                if(providedItem.image != nil){
                    let image = UIImage(data: providedItem.image!)
                    Image(uiImage: image!)
                        .resizable()
                }
                //sets the text
                VStack{
                    Text(providedItem.name)
                        .bold()
                        .padding(.top, 10)
                    Text(providedItem.location)
                        .padding([.bottom, .leading, .trailing], 12)
                }
                .frame(maxWidth: 200, maxHeight: 50)
                .background(.ultraThinMaterial)
            }
            .frame(height: 250)
            //.frame(width: 200, height: 250)
//            .frame(maxWidth: 150, maxHeight: 200) //change this value to fit non-max iPhones
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
//            .padding()
        } else {
            ZStack(alignment: .bottom){
                Image(systemName: "photo")
                    .resizable()
//                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                //sets the text
                VStack{
                    Text(providedItem.name)
                        .bold()
                        .padding(.top, 10)
                    Text(providedItem.location)
                        .padding([.bottom, .leading, .trailing], 12)
                }
                .frame(maxWidth: 200, maxHeight: 50)
                .background(.ultraThinMaterial)
                .clipShape(
                    .rect(cornerRadii: RectangleCornerRadii(topLeading: 10, bottomLeading: 25, bottomTrailing: 25, topTrailing: 10 ))
                )
//                .mask {
//                    RoundedRectangle(cornerRadius: 25.0)
//                }
            }
            .frame(width: 200, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let image = UIImage(named: "tiltedParrot")!
    let item = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    item.image = image.jpegData(compressionQuality: 0.5)
    container.mainContext.insert(CategoryDataModel(name: item.category))
    container.mainContext.insert(item)
//    return ItemCardView(imageData: nil, itemName: "testName testName testName testName", itemLocation: "bottom closet bottom closet bottom closet bottom closet")
    return ItemCardView(providedItem: item)
        .modelContainer(container)
}
