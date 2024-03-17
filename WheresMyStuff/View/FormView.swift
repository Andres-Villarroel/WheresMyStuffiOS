//
//  FormView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/12/24.
//

import SwiftUI
import SwiftData
import PhotosUI

struct FormView: View {
    var nextScreen: () -> Void  //for switching tabview
    
    @Query var categories: [CategoryDataModel]
    @Environment(\.modelContext) var modelContext
    @FocusState private var isFocused: Bool
    
    //for the photo picker feature
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var shouldPresentPhotoPicker = false
    @State var avatarImage: UIImage?
    @State private var cameraImage = UIImage()
    @State private var useCamera = false
    
    
    //these will be saved using Swift Data using ItemDataModel
    @State private var name = ""
    @State private var category = "Miscellaneous"
    @State private var location = ""
    @State private var notes = ""
    @State private var imageData: Data?
    
    @Binding var item: ItemDataModel
    
    
    var body: some View {
        
        
        Form {
            
            //This section is for the required data fields
            Section(header: Text("Required")){
                
                TextField("Name", text: $name)
                //                    .focused($isFocused)
                TextField("Location", text: $location)
                //                    .focused($isFocused)
            }
            
            //this section is for the optional data fields
            Section(header: Text("Optional")){
                
                //--------this lets users choose an image they own---------------------
                Menu {
                    
                    Button ("Choose from library") {
                        shouldPresentPhotoPicker.toggle()
                    }// end menu button 1
                    Button ("Take Photo"){
                        useCamera.toggle()
                    }
                    
                } label: {
                    
                    if avatarImage != nil {
                        Image(uiImage: avatarImage!)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: 80)
                    } else {
                        Text("Choose Image")
                    }
                }
                .photosPicker(isPresented: $shouldPresentPhotoPicker, selection: $photoPickerItem, matching: .images)
                .sheet(isPresented: $useCamera) {
                    ImagePicker(sourceType: .camera, selectedImage: $avatarImage)
                }
                
                // MARK: Photo Picker Section
                //                PhotosPicker(selection: $photoPickerItem, matching: .images){
                //
                //                    let chosenImage: UIImage? = avatarImage
                //                    if chosenImage != nil{
                //                        Image(uiImage: avatarImage!)
                //                            .resizable()
                //                            .aspectRatio(contentMode: .fill)
                //                            .frame(maxWidth: 80)
                //                    } else{
                //                        Text("Choose Image")
                //                    }
                //                }
                .onChange(of: photoPickerItem){ _, _ in
                    Task{
                        if let photoPickerItem, //if photoPickerItem is not nil
                           let data = try? await photoPickerItem.loadTransferable(type: Data.self){     //convert photopickeritem into Data type and store it in data
                            if let image = UIImage(data: data){     //if converting data into a UIImage results in a UIImage that is NOT nil....
                                avatarImage = image     //...set avatarImage equal to image since it has now been verified to not be empty or nil...
                                imageData = data        //...and then set imageData equal to image; imageData is what will be used to insert into swiftdata
                            }
                        }
                        photoPickerItem = nil
                    }
                }
                .onChange(of: avatarImage) { _, _ in
                    Task {
                        if let avatarImage,
                           let data = avatarImage.pngData(){
                            if let image = UIImage(data: data){ //maybe chnage this to a simple if statement rather than waste resources creating the uiimage
                                imageData = data
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    return 0
                }
                
                //-------------END PHOTO PICKER SECTION-------------------------------
                
                // MARK: Category Picker
                Picker("Choose Category", selection: $category){
                    ForEach(categories[0].categoryList, id: \.self) { cat in
                        Text(cat)
                    }
                }
                
                
                TextField("Notes", text: $notes, axis: .vertical)
                //                    .focused($isFocused)
                    .padding()
            }
            
            //save button
            HStack{
                Spacer()
                
                Button ("Save Item"){
                    
                    //let item = ItemDataModel(name: name, location: location, category: category, notes: notes)
                    //item.image = imageData
                    let emptyItem = ItemDataModel(name: "", location: "", category: "Miscellaneous", notes: "")
                    item.name = name
                    item.location = location
                    item.category = category
                    item.image = imageData
                    modelContext.insert(item)
                    
                    print("Printing swiftdata address:")
                    //COMMENT THIS OUT WHEN DEBUGGING IS NOT NEEDED
                    //TODO: Delete this line when publishing final product
                    print(modelContext.sqliteCommand)
                    
                    //CLEAR FORM WHEN FINISHED
                    name = ""
                    category = ""
                    location = ""
                    self.notes = ""
                    imageData = nil
                    avatarImage = nil
                    item = emptyItem
                    
                    nextScreen()
                    
                }
                //input validation to ensure name and location are filled out
                .disabled(name.isEmpty || location.isEmpty)
                Spacer()
            }//end hstack
           
            
        }//end form
        //        .onTapGesture {
        //            isFocused = false
        //        }
    }
}// end struct

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    let tempItem = ItemDataModel(name: "", location: "", category: "Miscellaneous", notes: "")
    container.mainContext.insert(newCategory)
    func nextScreenPreview() {
        
    }
    return FormView(nextScreen: nextScreenPreview, item: .constant(tempItem))
        .modelContainer(container)
}
