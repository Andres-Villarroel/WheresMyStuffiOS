//
//  AddItemView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData
import PhotosUI


struct AddItemView: View {
    
    //SwiftData
    @Query var items: [ItemDataModel]
    @Query var categories: [CategoryDataModel]
    @Environment(\.modelContext) var modelContext
    @ObservedObject var pickerItems: Category   //to be used for the Picker()
    
    //for the photo picker feature
    @State private var photoPickerItem: PhotosPickerItem?
    @State var avatarImage: UIImage?
    
    //these will be saved using Swift Data using ItemDataModel
    @State private var name = ""
    @State private var category = ""
    @State private var location = ""
    @State private var notes = ""
    @State private var imageData: Data?
    
    
    
    var body: some View {
        
        NavigationView{
            Form{
                //This section is for the required data fields
                Section(header: Text("Required")){
                    
                    TextField("Name", text: $name)
                    TextField("Location", text: $location)
                }
                
                //this section is for the optional data fields
                Section(header: Text("Optional")){
                    
                    //--------this lets users choose an image they own---------------------
                    // MARK: Photo Picker
                    PhotosPicker(selection: $photoPickerItem, matching: .images){

                        let chosenImage: UIImage? = avatarImage
                        if chosenImage != nil{
                            Image(uiImage: avatarImage!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: 80)
                        } else{
                            Text("Choose Image")
                        }
                     }
                     .onChange(of: photoPickerItem){ _, _ in
                         Task{
                             if let photoPickerItem,
                                let data = try? await photoPickerItem.loadTransferable(type: Data.self){
                                 if let image = UIImage(data: data){
                                     avatarImage = image
                                     imageData = data
                                 }
                             }
                             photoPickerItem = nil
                         }
                     }
                     .frame(maxWidth: .infinity)
                     .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                     return 0
                     }
                    //-------------END PHOTO PICKER SECTION-------------------------------
                    
                    // MARK: Category Picker
                    Picker("Choose Category", selection: $category, content: {
                        ForEach(pickerItems.categoryList, id: \.self) { categoryQuery in
                            Text(categoryQuery).tag(categoryQuery)
                        }
                        
                    })
                    
                    TextField("Notes", text: $notes, axis: .vertical)
                        .padding()
                }
                
                //save button
                HStack{
                    Spacer()
                    
                    Button ("Save Item"){
                        
                        if(category == "category"){
                            category = ""
                        }
                        //category = (category == "category") ? "" : category
                        let item = ItemDataModel(name: name, location: location, category: category, notes: notes)
                        item.image = imageData
                        modelContext.insert(item)
                        
                        print("Printing swiftdata address:")
                        //COMMENT THIS OUT WHEN DEBUGGING IS NOT NEEDED
                        print(modelContext.sqliteCommand)
                        
                        //CLEAR FORM WHEN FINISHED
                        name = ""
                        category = ""
                        location = ""
                        self.notes = ""
                        imageData = nil
                        avatarImage = nil
                        //sends user to BrowseView
                    }
                    //input validation to ensure name and location are filled out
                    .disabled(name.isEmpty || location.isEmpty)
                    Spacer()
                }
            }
            .navigationTitle("Add Item")
        }
        
    }
}

#Preview {
    AddItemView(pickerItems: Category())
}
/*
 PhotosPickerView()
 .frame(maxWidth: .infinity)
 //this modifier fixes the row divider bug
 .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
 return 0
 }
 
 */
