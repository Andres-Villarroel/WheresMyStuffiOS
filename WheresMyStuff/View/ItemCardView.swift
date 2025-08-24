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
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(.ultraThinMaterial)
            }
            .frame(width: 180, height: 180)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
        } else {
            ZStack(alignment: .bottom){
                Image(systemName: "photo")
                    .resizable()
//                Image("photo")
//                    .frame(maxWidth: .infinity)
                //sets the text
                VStack{
                    Text(providedItem.name)
                        .bold()
                        .padding(.top, 10)
                    Text(providedItem.location)
                        .padding([.bottom, .leading, .trailing], 12)
                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(.ultraThinMaterial)
            }
//            .fixedSize(horizontal: true, vertical: false)
            .frame(width: 180, height: 180)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let image = UIImage(named: "tiltedParrot")!
//    let image = UIImage(named: "debugImage")!
    let item = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
//    item.image = image.jpegData(compressionQuality: 0.5)
    container.mainContext.insert(CategoryDataModel(name: item.category))
    container.mainContext.insert(item)
//    return ItemCardView(imageData: nil, itemName: "testName testName testName testName", itemLocation: "bottom closet bottom closet bottom closet bottom closet")
    return ItemCardView(providedItem: item)
        .modelContainer(container)
}
