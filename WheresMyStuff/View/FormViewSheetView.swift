
 import SwiftUI
 import SwiftData
 import PhotosUI
 import SwiftUI_NotificationBanner
 import AVFoundation
 import os
 struct FormViewSheetView: View {
     let log = Logger(subsystem: "WheresMyStuff", category: "Adding an Item")
     @EnvironmentObject var notificationBanner: DYNotificationHandler
     @EnvironmentObject var constants: GlobalConstant
     let noCategoryTag = "bvhqfpy9qfnprwio"
     let chosenCategory: String
     @Binding var shouldShowSheet: Bool
     @EnvironmentObject var storekit: StoreKitManager
     @State private var showLimitReachedAlert = false
     
     @Query var categories: [CategoryDataModel]
     @Query var items: [ItemDataModel]
     @Environment(\.modelContext) var modelContext
     private let formBackgroundColor = Color(.gray)
     
     //for the photo picker feature
     @State private var photoPickerItem: PhotosPickerItem?
     @State private var shouldPresentPhotoPicker = false
     @State var avatarImage: UIImage?
     @State private var useCamera = false
     @StateObject var cManager = CameraManager()
     @State var showCameraPermissionAlert = false
     
     
     //these will be saved using Swift Data using ItemDataModel
     @State private var name = ""
     @State private var category = ""
     @State private var location = ""
     @State private var notes = ""
     @State private var imageData: Data?
     
     init(chosenCategory: String, shouldDismiss: Binding<Bool>){
         self._shouldShowSheet = shouldDismiss    //@binding is a property wrapper meaning that its data must sync, '_' flags it for syncing
         self.chosenCategory = chosenCategory
         self._category = State(initialValue: chosenCategory)
     }
     
     var body: some View {
         Form {
             
             //This section is for the required data fields
             //MARK: required textfield/inputs
             Section(header: Text("Required")){
                 
                 TextField("Name", text: $name)
                 TextField("Location", text: $location)
             }
             .listRowBackground(Color.form)
             
             //this section is for the optional data fields
             Section(header: Text("Optional")){
                 //MARK: Image Picker section
                 Menu {
                     Button ("Choose from library") {
                         shouldPresentPhotoPicker.toggle()
                     }// end menu button 1
                     Button ("Take Photo"){
                         Task{
                             await cManager.getPermission()
                             
                             if cManager.authStatus{
                                 useCamera.toggle()
                                 print("PERMISSION HAS OR HAS ALREADY BEEN GRANTED")
                             } else {
                                 showCameraPermissionAlert.toggle()
                                 print("PERMISSION HAS BEEN DENIED")
                             }
                         }
                     }
                 } label: {
                     
                     if avatarImage != nil {
                         Image(uiImage: avatarImage!)
                             .resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(maxWidth: 80)
                     } else {
                         Text("Choose Image")
                             .foregroundStyle(constants.buttonColor)
                     }
                 }
                 //MARK: PhotoPicker section
                 .photosPicker(isPresented: $shouldPresentPhotoPicker, selection: $photoPickerItem, matching: .images)
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
 //                           let data = avatarImage.pngData(){
                            let data = avatarImage.jpegData(compressionQuality: 0.5){    //switching to jpeg for better file compression
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
                     Text("None").tag(noCategoryTag)
                     ForEach(categories, id: \.self) { cat in
                         Text(cat.name).tag(cat.name)
                     }
                 }
                 .tint(constants.buttonColor)
                 
                 TextField("Notes", text: $notes, axis: .vertical)
                     .padding()
             }//end section
             .listRowBackground(Color.form)
             .alert("Please enable camera access", isPresented: $showCameraPermissionAlert){
                 Button("OK", role: .cancel){}
             } message: {
                 Text("Settings > WheresMyStuff > toggle camera")
                     .frame(maxWidth: .infinity, alignment: .leading)
             }
             
             //MARK: save button section
             HStack{
                 Spacer()
                 Button ( action: attemptSaveItem){
                     Text("Save Item")
                         .foregroundStyle(constants.buttonColor)
                 }
                 .alert(isPresented: $showLimitReachedAlert){
                     Alert(title: Text("Item Limit Reached"), message: Text("Limit is \(constants.itemLimit) items, please purchase the full version to remove this limit. The full version can be purchased in: \nSearch screen>Settings."), dismissButton: .default(Text("OK")))
                 }
                 .padding()
                 .background(Color.form)
                 .cornerRadius(15)
                 .buttonStyle(PlainButtonStyle())   //allows the .disabled modifier to function
                 .disabled(name.isEmpty || location.isEmpty)     //input validation to ensure name and location are filled out
                 Spacer()
             }
             .listRowBackground(Color.clear)
             
         }//end form
         .scrollDismissesKeyboard(.immediately)
     }//end body
     
     //MARK: helper functions
     private func debugButton() {
         log.info("Button pressed")
     }
     
     private func attemptSaveItem() {
         
         log.info("attemptSaveItem button pressed.")
         log.info("User purchased full version: \(storekit.didPurchaseFullVersion())")
         //TODO: implement full version purchase verification
         if(storekit.didPurchaseFullVersion()){
             log.info("Full version purchase detected. Item '\(name)' will continue forward through the saving process.")
             saveItem()
         } else {
             log.info("Full version not purchased. Comparing current items array count with item limit...")
             //set an alert if the item limit has been reached
             if(items.count < constants.itemLimit){
                 log.info("Limit not yet reached, continuing with the saving process")
                 saveItem()
             } else {
                 log.info("Item limit has been reached.\nRejecting item save attempt.")
                 showLimitReachedAlert.toggle()
             }
         }
         
         
     }//end saveItem()
     
     private func saveItem() {
         log.info("save button pressed")
         
         if(category != noCategoryTag){         //cannot perform input verification inside item's instantiation, so it must be done here.
             category = category.trimmingCharacters(in: .whitespacesAndNewlines)
         }
         
         let item = ItemDataModel(              //instantiation is done for an ItemDataModel instance while initializing using user input data
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            location: location.trimmingCharacters(in: .whitespacesAndNewlines),
            category: category,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
         )
         
         if imageData != nil {  //checking if an image has been provided and then saving it to 'item' if confirmed to exist
             item.image = imageData
             log.info("imageData is not nil")
         } else {
             log.info("imageData is nil")
         }
        
         modelContext.insert(item)      //saving item to database
         log.info("'\(item.name)' successfully saved")
         clearForm()
         
         notificationBanner.show(notification: infoNotification)
         shouldShowSheet = false
     }
     
     private func clearForm(){
         name = ""
         category = ""
         location = ""
         notes = ""
         imageData = nil
         avatarImage = nil
     }
     
     var infoNotification: DYNotification {
         let message = "Successfully Added"
         let type: DYNotificationType = .success
         let displayDuration: TimeInterval = 1.5
         let dismissOnTap = true
         let displayEdge: Edge = .top
         
         return DYNotification(message: message, type: type, displayDuration: displayDuration, dismissOnTap: dismissOnTap, displayEdge: displayEdge, hapticFeedbackType: .success)
     }
 }// end struct



 #Preview {
     let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
     let tempArray = ["Miscellaneous", "Desk", "Kitchen"]
     //    let newCategory = CategoryDataModel(categoryList: tempArray)
     let tempItem = ItemDataModel(name: "", location: "", category: "Miscellaneous", notes: "")
     
     for cat in tempArray{
         let newCategory = CategoryDataModel(name: cat)
         container.mainContext.insert(newCategory)
     }
     //    container.mainContext.insert(newCategory)
     @State var shouldDismiss = false
     return FormViewSheetView(chosenCategory: "Kitchen", shouldDismiss: $shouldDismiss)
         .modelContainer(container)
         .environmentObject(GlobalConstant())
 }
