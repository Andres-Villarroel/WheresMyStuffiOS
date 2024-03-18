
import SwiftUI
import SwiftData
import PhotosUI

struct EditItemView: View {
    //used to dismiss all active sheets
    let rootViewController = UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive }
        .map {$0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter({ $0.isKeyWindow }).first?.rootViewController
    
    
    @Query var categories: [CategoryDataModel]
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    //for the category addition mechanic
    @State private var showingAlert = false
    @State private var newCategoryName = ""
    
    //for the photo picker feature
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var shouldPresentPhotoPicker = false
    @State var avatarImage: UIImage?
    @State private var useCamera = false
    
    // existing item to be edited
    let item: ItemDataModel
    
    //these will be saved using Swift Data using ItemDataModel
    @State private var name: String
    @State private var category: String
    @State private var location: String
    @State private var notes: String
    @State private var imageData: Data?
    
    init(item: ItemDataModel?) {
        self.item = item!
        
        self._name = State(initialValue: item?.name ?? "")
        self._category = State(initialValue: item?.category ?? "")
        self._location = State(initialValue: item?.location ?? "")
        self._notes = State(initialValue: item?.notes ?? "")
        
        if item?.image != nil{
            self._imageData = State(initialValue: item?.image)
            self._avatarImage = State(initialValue: UIImage(data: item!.image!))
        }
    }
    
    var body: some View {
        
        NavigationStack {
            
            Form {
                //This section is for the required data fields
                Section(header: Text("Required")){
                    
                    TextField("Name", text: $name)
                    TextField("Location", text: $location)
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
                                //maybe change this to a simple if statement rather than waste resources creating the uiimage
                                imageData = data
                                
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                        return 0
                    }
                    
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
                        
                        item.name = name
                        item.location = location
                        item.category = category
                        item.image = imageData
                        item.notes = notes
                        
                        //dismisses all sheets
                        rootViewController?.dismiss(animated: true)
                    }
                    //input validation to ensure name and location are filled out
                    .disabled(name.isEmpty || location.isEmpty)
                    Spacer()
                }//end hstack
                
            }//end form
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add Category"){
                        showingAlert.toggle()
                    }
                    .alert("Enter Category Name", isPresented: $showingAlert){
                        TextField("Enter Cateory Name", text: $newCategoryName)
                        Button("OK", action: submit)
                        Button("Cancel") {
                            newCategoryName = ""
                        }
                    } message: {
                        Text("")
                    }
                }
            }
        } //end navigationStack
    }//end body
    func submit(){
        //add newCategoryName to categories array
        categories[0].categoryList.append(newCategoryName)
        
        print("You entered \(newCategoryName)")
        newCategoryName = ""
    }
    
}//end struct

#Preview {
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous", "Desk"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    let tempItem = ItemDataModel(name: "test name", location: "test location", category: "Miscellaneous", notes: "test notes")
    tempItem.image = data
    container.mainContext.insert(newCategory)
    
    return EditItemView(item: tempItem)
        .modelContainer(container)
}
