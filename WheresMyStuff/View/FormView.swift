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
    var nextScreen: () -> Void
    
    @Query var categories: [CategoryDataModel]
    @Environment(\.modelContext) var modelContext
    
    //for the photo picker feature
    @State private var photoPickerItem: PhotosPickerItem?
    @State var avatarImage: UIImage?
    
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
                TextField("Location", text: $location)
                
            }
            
            //this section is for the optional data fields
            Section(header: Text("Optional")){
                
                //--------this lets users choose an image they own---------------------
                // MARK: Photo Picker Section
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
                }                  //this is cleared
                //-------------END PHOTO PICKER SECTION-------------------------------
                
                // MARK: Category Picker
                Picker("Choose Category", selection: $category){
                    ForEach(categories[0].categoryList, id: \.self) { cat in
                        Text(cat)
                    }
                }
                
                
                TextField("Notes", text: $notes, axis: .vertical)
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
            //putting the screen change button here does NOT work
            
        }//end form
    }
}

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
