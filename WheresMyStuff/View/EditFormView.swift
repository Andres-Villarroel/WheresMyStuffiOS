import SwiftUI
import SwiftData
import PhotosUI
import SwiftUI_NotificationBanner
import os
struct EditFormView: View {
    let log = Logger(subsystem: "WheresMyStuff", category: "Edit Item")
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
    @Query var items: [ItemDataModel]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var notificationBanner: DYNotificationHandler
    @EnvironmentObject var constants: GlobalConstant
    
    //for the category addition mechanic
    @State private var showingAlert = false
    @State private var newCategoryName = ""
    let noCategoryTag = "bvhqfpy9qfnprwio"
    
    //for the photo picker feature
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var shouldPresentPhotoPicker = false
    @State var avatarImage: UIImage?
    @State private var useCamera = false
    @State private var tempImageHolder: UIImage?
    
    //these will be saved using Swift Data using ItemDataModel
    @State private var name: String
    @State private var category: String
    @State private var location: String
    @State private var notes: String
    @State private var imageData: Data?
    
    init(item: ItemDataModel?) {
        self.item = item!
        
        self._name = State(initialValue: item?.name ?? "")
        self._category = State<String>(initialValue: item?.category ?? "")
        self._location = State(initialValue: item?.location ?? "")
        self._notes = State(initialValue: item?.notes ?? "")
        print("Current item category: \(category)")
        
        //if the item has an image
        if item?.image != nil{
            self._tempImageHolder = State(initialValue: UIImage(data: item!.image!)) //incase the user changes their mind on changing the image, this will be used to undo change
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
                            //                            imageData = nil
                            //                            item.image = nil
                            //                            avatarImage = nil
                            log.info("Delete button triggered for image menu")
                            tempImageHolder = nil   //triggers the .onChange(tempImageHolder) modifier which will also set imageData to nil which will then be used to set item.image to nil when the user presses the save button.
                        }
                    }
                    
                } label: {  //displays the image of the item
                    //                    if avatarImage != nil {
                    if tempImageHolder != nil {
                        //                        Image(uiImage: avatarImage!)
                        Image(uiImage: tempImageHolder!) 
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 300)
                    } else {
                        //if the item has no image, display this image as default
                        Image("tiltedParrot")
                            .resizable()
                    }
                }
                // MARK: photo picker section
                .photosPicker(isPresented: $shouldPresentPhotoPicker, selection: $photoPickerItem, matching: .images)
                
                // MARK: camera launch section
                .fullScreenCover(isPresented: $useCamera, content: {
                    //                    ImagePicker(sourceType: .camera, selectedImage: $avatarImage)
                    ImagePicker(sourceType: .camera, selectedImage: $tempImageHolder)
                        .ignoresSafeArea(.all)
                })
                .onChange(of: photoPickerItem){ _, _ in
                    Task{
                        if let photoPickerItem, //if photoPickerItem is not nil
                           let data = try? await photoPickerItem.loadTransferable(type: Data.self){     //convert photopickeritem into Data type and store it in data
                            if let image = UIImage(data: data){     //if converting data into a UIImage results in a UIImage that is NOT nil....
                                //                                avatarImage = image     //...set avatarImage equal to image since it has now been verified to not be empty or nil...
                                tempImageHolder = image     //...set tempImageHolder equal to image since it has now been verified to not be empty or nil...
                                imageData = data        //...and then set imageData equal to image; imageData is what will be used to insert into swiftdata
                            }
                        }
                        photoPickerItem = nil
                    }
                }
                //                .onChange(of: avatarImage) { _, _ in
                .onChange(of: tempImageHolder) { _, _ in
                    log.info("onChange triggered for tempImageHolder.")
                    if(tempImageHolder == nil){
                        log.info("tempImageHolder is currently nil in onChange of tempImageHolder closure")
                    } else {
                        log.info("tempImageHolder is currently not nil before Task{} in onChangeClosure")
                    }
                    Task {
                        //if let avatarImage,
                        if let tempImageHolder,
                           //                           let data = avatarImage.pngData(){
//                           let data = tempImageHolder.pngData(){
                            let data = tempImageHolder.jpegData(compressionQuality: 0.5){    //switching to jpeg for better file compression
                            log.info("Inside Task{} for onChange of tempImageHolder, tempImageHolder has been converted to jpegData")
                            imageData = data
                        } else {
                            log.info("else condition met for if let tempImageHolder, imageData will now be set to nil")
                            imageData = nil
                        }
                    }
                    log.info("Now exiting onChange of tempImageHolder")
                    
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
                            Text("None").tag(noCategoryTag)
                            ForEach(categories, id: \.self) { cat in
                                Text(cat.name).tag(cat.name)
                            }
                        }
                        .tint(constants.buttonColor)
                        
                        TextField("Notes", text: $notes, axis: .vertical)
                    }
                    
                    //save button
                    HStack{
                        Spacer()
                        
                        Button (action: saveItem) {
                            Text("Save Changes")
                        }
                        .tint(constants.buttonColor)
                        //input validation to ensure name and location are filled out
                        .disabled(name.isEmpty || location.isEmpty)
                        Spacer()
                    }//end hstack
                    
                    //MARK: Delete item button
                    Section {
                        HStack{
                            Spacer()
                            Button(role: .destructive, action: deleteItem, label: {
                                Text("Delete Item")
                            })
                            Spacer()
                        }
                    }
                }// end form
                .scrollDismissesKeyboard(.immediately)
                
            }// end vstack
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button("Add Category"){
                        showingAlert.toggle()
                    }
                    .tint(constants.buttonColor)
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
                    .tint(.red)
                }
            }
        }
    }
    
    private func saveItem() {
        item.name = name
        item.location = location
        item.image = imageData
        item.notes = notes
        if(category != noCategoryTag){
            item.category = category.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            item.category = ""
        }
        if imageData == nil{
            log.info("setting item.image to nil")
        } else {
            log.info("setting item.image to a non-nil image")
        }
        //dismisses all sheets
        rootViewController?.dismiss(animated: true)
        notificationBanner.show(notification: infoNotification)
    }
    
    private func submitCategory(){
        //add newCategoryName to categories array
        //        categories[0].categoryList.append(newCategoryName)
        modelContext.insert(CategoryDataModel(name: newCategoryName))
        
        print("You entered \(newCategoryName)")
        newCategoryName = ""
    }
    
    private func deleteItem() {
        log.info("delete button pressed")
        log.info("Items in database BEFORE deletion: \(items.count) as of \(Date.now)")
        for i in items {
            if i.id == self.item.id{
                modelContext.delete(i)
                log.info("Item deleted")
                do{
                    try modelContext.save() //helps prevent views from loading the previous database state before the deletion
                } catch {
                    log.error("Error saving: \(error.localizedDescription)")
                }
            }
        }
        log.info("Items in database AFTER deletion: \(items.count) as of \(Date.now)")
        rootViewController?.dismiss(animated: true)
    }
    
    var infoNotification: DYNotification {
        let message = "Saved"
        let type: DYNotificationType = .success
        let displayDuration: TimeInterval = 0.9
        let dismissOnTap = true
        let displayEdge: Edge = .top
        
        return DYNotification(message: message, type: type, displayDuration: displayDuration, dismissOnTap: dismissOnTap, displayEdge: displayEdge, hapticFeedbackType: .success)
    }
    
}
    
    #Preview {
        let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        
        let image = UIImage(named: "tiltedParrot")!
        let data = image.pngData()
        
        let tempArray = ["Miscellaneous", "Desk", "test category"]
        for cat in tempArray{
            let newCategory = CategoryDataModel(name: cat)
            container.mainContext.insert(newCategory)
        }
        let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
        newItem.image = data
        
        return EditFormView(item: newItem)
            .modelContainer(container)
            .environmentObject(DYNotificationHandler())
            .environmentObject(GlobalConstant())
        
    }
