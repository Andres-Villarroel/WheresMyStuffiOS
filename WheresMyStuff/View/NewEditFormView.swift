

import SwiftUI
import SwiftData
import PhotosUI
import SwiftUI_NotificationBanner

struct NewEditFormView: View {
    let item: ItemDataModel
    @Environment(\.dismiss) private var dismiss
    @State private var showImageView = false
    
    let rootViewController = UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive }
        .map {$0 as? UIWindowScene }
        .compactMap { $0 }
        .first?.windows
        .filter({ $0.isKeyWindow }).first?.rootViewController
    
    
    @Query var categories: [CategoryDataModel]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var notificationBanner: DYNotificationHandler
    
    //for the category addition mechanic
    @State private var showingAlert = false
    @State private var newCategoryName = ""
    
    //for the photo picker feature
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var shouldPresentPhotoPicker = false
    @State var avatarImage: UIImage?
    @State private var useCamera = false
    
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
            VStack {
                Menu {
                    
                    Button ("Choose from library") {
                        shouldPresentPhotoPicker.toggle()
                    }// end menu button 1
                    
                    Button ("Take Photo"){
                        useCamera.toggle()
                    }
                    
                    if imageData != nil {       //deletes the selected image
                        Button ("Delete Image", role: .destructive) {
                            imageData = nil
                            item.image = nil
                            avatarImage = nil
                        }
                    }
                    
                } label: {
                    if avatarImage != nil {
                        Image(uiImage: avatarImage!)
                            .resizable()
//                            .aspectRatio(contentMode: .fill)
                            .scaledToFit()
//                            .scaledToFill()
                            .frame(maxHeight: 300)
                    } else {
                        //if the item has no image, display this image as default
                        Image("tiltedParrot")
                            .resizable()
//                            .aspectRatio(contentMode: .fill)
                    }
                }
                // MARK: image selection section
                .photosPicker(isPresented: $shouldPresentPhotoPicker, selection: $photoPickerItem, matching: .images)
//                .sheet(isPresented: $useCamera) {
//                    ImagePicker(sourceType: .camera, selectedImage: $avatarImage)
//                }
                .fullScreenCover(isPresented: $useCamera, content: {
                    ImagePicker(sourceType: .camera, selectedImage: $avatarImage)
                        .ignoresSafeArea(.all)
                })
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
                            imageData = data
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .alignmentGuide(.listRowSeparatorLeading) { viewDimensions in
                    return 0
                }
                
                //MARK: form section
                Form {
                    //MARK: Required Section
                    Section (header: Text("Required")){
                        TextField("Name", text: $name)
                        TextField("Location", text: $location)
                    }
                    
                    //MARK: Optional Section
                    Section (header: Text("Optional")){
                        Picker("Choose Category", selection: $category){
                            ForEach(categories, id: \.self) { cat in
                                Text(cat.name)
                            }
                        }
                        
                        TextField("Notes", text: $notes, axis: .vertical)
                    }
                    
                    //save button
                    HStack{
                        Spacer()
                        
                        Button (action: saveItem) {
                            Text("Save Item")
                        }
                        //input validation to ensure name and location are filled out
                        .disabled(name.isEmpty || location.isEmpty)
                        Spacer()
                    }//end hstack
                }// end form
                .scrollDismissesKeyboard(.immediately)
            }// end vstack
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add Category"){
                        showingAlert.toggle()
                    }
                    .alert("Enter Category Name", isPresented: $showingAlert){
                        TextField("Enter Cateory Name", text: $newCategoryName)
                        Button("OK", action: submitCategory)
                        Button("Cancel") {
                            newCategoryName = ""
                        }
                    } message: {
                        Text("")
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    Button("Cancel"){
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func saveItem() {
        item.name = name
        item.location = location
        item.category = category
        item.image = imageData
        item.notes = notes
        
        //dismisses all sheets
        rootViewController?.dismiss(animated: true)
        notificationBanner.show(notification: infoNotification)
    }
    
    func submitCategory(){
        //add newCategoryName to categories array
//        categories[0].categoryList.append(newCategoryName)
        modelContext.insert(CategoryDataModel(name: newCategoryName))
        
        print("You entered \(newCategoryName)")
        newCategoryName = ""
    }
    
    var infoNotification: DYNotification {
        let message = "Saved"
        let type: DYNotificationType = .success
        let displayDuration: TimeInterval = 1.5
        let dismissOnTap = true
        let displayEdge: Edge = .top
        
        return DYNotification(message: message, type: type, displayDuration: displayDuration, dismissOnTap: dismissOnTap, displayEdge: displayEdge, hapticFeedbackType: .success)
    }

}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    
    let tempArray = ["Miscellaneous", "Desk"]
    for cat in tempArray{
        let newCategory = CategoryDataModel(name: cat)
        container.mainContext.insert(newCategory)
    }
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    
    return NewEditFormView(item: newItem)
        .modelContainer(container)
        .environmentObject(DYNotificationHandler())
        
}
