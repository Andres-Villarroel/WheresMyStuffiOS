//
//  ItemSheetView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/11/24.
//

import SwiftUI
import SwiftData    //note that this is only used in the preview
import SwiftUI_NotificationBanner

struct ItemSheetView: View {
    
    let item: ItemDataModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEditItem = false
    @State private var showImageView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if item.image != nil{
                    Image(uiImage: UIImage(data: item.image!)!)   //add try or if statements to check for an image. or just add a default image
                        .resizable()
                        .scaledToFit()
                        .onTapGesture {
                            showImageView.toggle()
                        }
                    //TODO: make image tappable to view full image, then do the same for EditView but add a delete button for the image
                } else {
                    Image("tiltedParrot")
                        .resizable()
                        .scaledToFit()
                }
                
                Text("Name: \(item.name)")
                Divider()
                Text("Location: \(item.location)")
                Divider()
                Text("Category: \(item.category)")
                Divider()
                Text(item.date, format: .dateTime.day().month().year().hour().minute())
                if !item.notes.isEmpty {
                    Text("Notes: \(item.notes)")
                }
                
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Edit"){
                        showEditItem.toggle()
                    }
                    .sheet (isPresented: $showEditItem) {
//                        EditItemView(item: item)
                        NewEditFormView(item: item)
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    Button("Dismiss"){
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showImageView){
                ImageView(item: item, isInEditMode: false)
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let catArray = ["Miscellaneous", "Desk"]
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    let newCategory = CategoryDataModel(categoryList: catArray)
    container.mainContext.insert(newItem)
    container.mainContext.insert(newCategory)
    return ItemSheetView(item: newItem)
        .modelContainer(container)
        .environmentObject(DYNotificationHandler())
}
