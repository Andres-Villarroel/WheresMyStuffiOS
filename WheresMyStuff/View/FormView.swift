import SwiftUI
import SwiftData
import PhotosUI
import SwiftUI_NotificationBanner
import AVFoundation
import os

struct FormView: View {
    let log = Logger(subsystem: "WheresMyStuff", category: "Adding an Item")
    @EnvironmentObject var notificationBanner: DYNotificationHandler
    var nextScreen: () -> Void  //for switching tabview
    let buttonColor = Color.lightPurple
    let noCategoryTag = "bvhqfpy9qfnprwio"
    @EnvironmentObject var storekit: StoreKitManager
    let itemLimit = 10
    @State private var showLimitReachedAlert = false
    
    @Query var categories: [CategoryDataModel]
    @Query var items: [ItemDataModel]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var constants: GlobalConstant
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
    
    @Binding var item: ItemDataModel
    
    
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
                .padding()
                .background(Color.form)
                .cornerRadius(15)
                .buttonStyle(PlainButtonStyle())
                .disabled(name.isEmpty || location.isEmpty)     //input validation to ensure name and location are filled out
                .alert(isPresented: $showLimitReachedAlert){
                    //show alert if the user has reached the limit for adding items while in the free version of the app.
                    Alert(title: Text("Item Limit Reached"), message: Text("Limit is \(itemLimit) items, please purchase the full version to remove this limit. The full version can be purchased in: \nSearch screen>Settings."), dismissButton: .default(Text("OK")))
                }
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
    
    private func saveItem(){
        log.info("saveItem() triggered. Item '\(name)' will attempt to save.")
        let emptyItem = ItemDataModel(name: "", location: "", category: "", notes: "")
        item.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        item.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        if(category != noCategoryTag){
            item.category = category.trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            item.category = ""
        }
        if imageData != nil {  //change this, it is not supposed to check item.image as that is what the image is saving to; it will always be nil
            item.image = imageData
            log.info("imageData is not nil")
        } else {
            log.info("imageData is nil")
        }
        item.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        
        modelContext.insert(item)
        log.info("model context insert() executed")
        try? modelContext.save()
        log.info("model context save() executed")
        log.info("Item '\(name)' successfully saved.")
        
        //clear the form
        clearForm()
        item = emptyItem
        
        notificationBanner.show(notification: infoNotification)
        nextScreen()
        log.info("saveItem() finished.")
    }
    
    private func clearForm(){
        log.info("clearForm() triggered.")
        //CLEAR FORM WHEN FINISHED
        name = ""
        category = ""
        location = ""
        notes = ""
        imageData = nil
        avatarImage = nil
    }
    
    var infoNotification: DYNotification {
        let message = String(localized: "Successfully Added")
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
    let tempItem = ItemDataModel(name: "", location: "", category: "Miscellaneous", notes: "")
    
    for cat in tempArray{
        let newCategory = CategoryDataModel(name: cat)
        container.mainContext.insert(newCategory)
    }
    //    container.mainContext.insert(newCategory)
    func nextScreenPreview() {}
    return FormView(nextScreen: nextScreenPreview, item: .constant(tempItem))
        .environmentObject(GlobalConstant())
        .modelContainer(container)
}
