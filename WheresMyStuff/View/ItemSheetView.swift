//
//  ItemSheetView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/11/24.
//

import SwiftUI
import SwiftData    //note that this is only used in the preview

struct ItemSheetView: View {
    
    let item: ItemDataModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEditItem = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if item.image != nil{
                    Image(uiImage: UIImage(data: item.image!)!)   //add try or if statements to check for an image. or just add a default image
                        .resizable()
                        .scaledToFit()
                } else {
                    Image("tiltedParrot")
                        .resizable()
                        .scaledToFit()
                }
                
                Text("Name: \(item.name)")
                
                Text("Location: \(item.location)")
                Text("Category: \(item.category)")
                Text(item.date, format: .dateTime.day().month().year().hour().minute())
                Text("Notes: \(item.notes)")
                
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Edit"){
                        showEditItem.toggle()
                    }
                    .sheet (isPresented: $showEditItem) {
                        //TODO: ADD EDIT VIEW HERE
                        EditItemView(item: item)
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    Button("Dismiss"){
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    return ItemSheetView(item: newItem)
        .modelContainer(container)
}
