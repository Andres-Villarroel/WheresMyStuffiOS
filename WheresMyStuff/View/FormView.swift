//
//  FormView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/12/24.
//

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
    @State private var category = "Miscellaneous"
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
            //                .listRowBackground(formBackgroundColor)
            
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
                            .foregroundStyle(buttonColor)
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
                           let data = avatarImage.pngData(){
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
                    ForEach(categories, id: \.self) { cat in
                        Text(cat.name).tag(cat.name)
                    }
                }
                
                TextField("Notes", text: $notes, axis: .vertical)
                    .padding()
            }//end section
            //                .listRowBackground(formBackgroundColor)
            .alert("Please enable camera access", isPresented: $showCameraPermissionAlert){
                Button("OK", role: .cancel){}
            } message: {
                Text("Settings > WheresMyStuff > toggle camera")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            //MARK: save button section
            HStack{
                Spacer()
                Button ( action: debugButton/*saveItem*/){
                    Text("Save Item")
                        .foregroundStyle(buttonColor)
                }
                .padding()
                .background(Color.form)
                .cornerRadius(15)
                .buttonStyle(PlainButtonStyle())
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
    private func saveItem() {
        log.info("save button pressed")
        //let item = ItemDataModel(name: name, location: location, category: category, notes: notes)
        //item.image = imageData
        let emptyItem = ItemDataModel(name: "", location: "", category: "", notes: "")
        item.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        item.location = location.trimmingCharacters(in: .whitespacesAndNewlines)
        item.category = category.trimmingCharacters(in: .whitespacesAndNewlines)
        if imageData != nil {  //change this, it is not supposed to check item.image as that is what the image is saving to; it will always be nil
            item.image = imageData
            log.info("imageData is not nil")
        } else {
            log.info("imageData is nil")
        }
        item.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        log.info("Before ADDING, Items has \(items.count) items")
        modelContext.insert(item)
        try? modelContext.save()
        //CLEAR FORM WHEN FINISHED
        name = ""
        category = ""
        location = ""
        notes = ""
        imageData = nil
        avatarImage = nil
        item = emptyItem
        
        log.info("After ADDING, Items has \(items.count) items")
        notificationBanner.show(notification: infoNotification)
        nextScreen()
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
    func nextScreenPreview() {}
    return FormView(nextScreen: nextScreenPreview, item: .constant(tempItem))
        .modelContainer(container)
}
