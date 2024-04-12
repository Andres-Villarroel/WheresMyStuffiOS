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
        
//        ZStack(alignment: .bottom){
//            //sets the image depending on the state of the image data
//            if(imageData != nil){
//                let image = UIImage(data: imageData!)
//                Image(uiImage: image!)
//                    .resizable()
//            } else {
//                Image(systemName: "photo")
//                    .resizable()
//                    .frame(width: 200, height: 200)
//            }
//            //sets the text
//            VStack{
//                Text(itemName)
//                    .bold()
//                    .padding(.top, 10)
//                Text(itemLocation)
//                    .padding([.bottom, .leading, .trailing], 12)
//            }
//            .frame(maxWidth: 200, maxHeight: 50)
//            .background(.ultraThinMaterial)
//        }
//        .frame(width: 200, height: 250)
//        .background(.ultraThinMaterial)
//        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        
        if (imageData != nil){
            ZStack(alignment: .bottom){
                //sets the image depending on the state of the image data
                if(imageData != nil){
                    let image = UIImage(data: imageData!)
                    Image(uiImage: image!)
                        .resizable()
                }
                //sets the text
                VStack{
                    Text(itemName)
                        .bold()
                        .padding(.top, 10)
                    Text(itemLocation)
                        .padding([.bottom, .leading, .trailing], 12)
                }
                .frame(maxWidth: 200, maxHeight: 50)
                .background(.ultraThinMaterial)
            }
            .frame(width: 200, height: 250)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
        } else {
            ZStack(alignment: .bottom){
                Image(systemName: "photo")
                    .resizable()
//                    .scaledToFit()
                    .frame(maxWidth: 200, maxHeight: 200)
                //sets the text
                VStack{
                    Text(itemName)
                        .bold()
                        .padding(.top, 10)
                    Text(itemLocation)
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
    let image = UIImage(named: "tiltedParrot")!
//    let data = image.pngData()
    
    return ItemCardView(imageData: nil, itemName: "testName testName testName testName", itemLocation: "bottom closet bottom closet bottom closet bottom closet")
}
/*
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
         
         ZStack(alignment: .bottom){
             if(imageData != nil){
                 let image = UIImage(data: imageData!)
                 Image(uiImage: image!)
                     .resizable()
             } else {
                 Image(systemName: "photo")
                     .resizable()
                     .frame(width: 200, height: 200)
             }
             VStack{
                 Text(itemName)
                     .bold()
                     .padding(.top, 10)
                 Text(itemLocation)
                     .padding([.bottom, .leading, .trailing], 12)
             }
 //            .frame(maxWidth: .infinity, maxHeight: 50)
             .frame(maxWidth: 200, maxHeight: 50)
             .background(.ultraThinMaterial)
 //            .opacity(0.95)
 //            .blur(radius: 20)
         }
         .frame(width: 200, height: 250)
         .background(.ultraThinMaterial)
         .clipShape(RoundedRectangle(cornerRadius: 25.0))
     }
 }

 #Preview {
     let image = UIImage(named: "tiltedParrot")!
     let data = image.pngData()
     
     return ItemCardView(imageData: data, itemName: "testName testName testName testName", itemLocation: "bottom closet bottom closet bottom closet bottom closet")
 }
 /*
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
  //                    .frame(maxHeight: 200)
                      .aspectRatio(contentMode: .fit)
  //                    .scaledToFit()
                      .frame(maxWidth: 140, maxHeight: 200)
                      .clipShape(RoundedRectangle(cornerRadius: 20))
                      .padding(.top, 10)
              } else {
                  Image(systemName: "photo")
                      .resizable()
                      .frame(width: 200, height: 200)
              }
              VStack{
                  Text(itemName)
                      .bold()
                      .padding(.top, 10)
                  Text(itemLocation)
                      .padding([.bottom/*, .leading, .trailing*/], 10)
              }
  //            .frame(maxWidth: .infinity, maxHeight: 50)
              .frame(maxWidth: 200, maxHeight: 50)
  //            .background(.ultraThinMaterial)
  //            .opacity(0.95)
  //            .blur(radius: 20)
          }
          .frame(width: 200, height: 250)
          .background(.ultraThinMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 25.0))
      }
  }

  #Preview {
      let image = UIImage(named: "testImage")!
      let data = image.pngData()
      
      return ItemCardView(imageData: data, itemName: "testName", itemLocation: "bottom closet")
  }

  */

 */
