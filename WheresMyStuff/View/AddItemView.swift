//
//  AddItemView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData


struct AddItemView: View {
    
    //SwiftData
    @Query var categories: [CategoryDataModel]
    @Environment(\.modelContext) var modelContext
    @Binding var selection: Int
    @State var item = ItemDataModel(name: "", location: "", category: "Miscellaneous", notes: "")
    
    
    var body: some View {
        VStack {
            NavigationView {
                
                FormView(nextScreen: changeScreen, item: $item )
                
                .navigationTitle("Add Item")
                
            } //end navigationView
        }// end vstack
    }// end body
    
    func changeScreen(){
        selection = 2
    }
}



#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return AddItemView(selection: .constant(2))
        .modelContainer(container)
    
}

/*
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
     @Query var categories: [CategoryDataModel]
     @Environment(\.modelContext) var modelContext
     @Binding var selection: Int
     
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
         VStack {
             NavigationView {
                 
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
                             
                             let item = ItemDataModel(name: name, location: location, category: category, notes: notes)
                             item.image = imageData
 //                            modelContext.insert(item)
                             
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
                             //sends user to BrowseView
                             changeScreen()   //ever since this line was added, the modifying state error has appeared. UPDATE: SOURCE FOUND - it was the textfields in form{}. commenting them out revealed the source of the error.
                             //self.selection = 2
                         }
                         //input validation to ensure name and location are filled out
 //                        .disabled(name.isEmpty || location.isEmpty)
                         Spacer()
                     }//end hstack
                     //putting the screen change button here does NOT work
                     
                 }//end form
                 .navigationTitle("Add Item")
                 
             } //end navigationView
             
         }
         
     }// end body
     
     func changeScreen(){
         selection = 2
     }
 }



 #Preview {
     let container = try! ModelContainer(for: CategoryDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
     let tempArray = ["Miscellaneous"]
     let newCategory = CategoryDataModel(categoryList: tempArray)
     container.mainContext.insert(newCategory)
     return AddItemView(selection: .constant(2))
         .modelContainer(container)
     
 }

 */
