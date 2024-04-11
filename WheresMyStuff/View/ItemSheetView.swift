import SwiftUI
import SwiftData    //note that this is only used in the preview
import SwiftUI_NotificationBanner
import OSLog

struct ItemSheetView: View {
    let log = Logger(subsystem: "WheresMyStuff", category: "ItemSheetView")  //creating an instance of the Logger for the logging system
    
    let item: ItemDataModel
    @Environment(\.dismiss) private var dismiss
    @State private var showEditItem = false
    @State private var showImageView = false
    
    var body: some View {
            NavigationStack {
                ZStack{
                    //MARK: Background Image
                    Image("appBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .ignoresSafeArea(.all)
                VStack {
                    if item.image != nil{
                        Image(uiImage: UIImage(data: item.image!)!)   //add try or if statements to check for an image. or just add a default image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 300, alignment: .center)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                showImageView.toggle()
                            }
                            .clipped()
                    } else {
                        Image("tiltedParrot")
                            .resizable()
                            .scaledToFit()
                    }
                    
//                    Text("Name: \(item.name)")
//                    Divider()
//                    Text("Location: \(item.location)")
//                    Divider()
//                    Text("Category: \(item.category)")
//                    Divider()
//                    Text(item.creationDate!, format: .dateTime.day().month().year().hour().minute())
//                    if !item.notes.isEmpty {
//                        Divider()
//                        Text("Notes: \(item.notes)")
//                    }
//                    Spacer()
                    ItemTextDisplayView(item: item)
                        .frame(width: 350)
                        .scaledToFit()
//                        .background(Color.red)
                }
                .background(Color.clear)
                .toolbar{
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Edit"){
                            showEditItem.toggle()
                        }
                        .sheet (isPresented: $showEditItem) {
                            EditFormView(item: item)
                        }
                    }
                    ToolbarItem(placement: .topBarLeading){
                        Button("Dismiss"){
                            dismiss()
                        }
                    }
                }
                .sheet(isPresented: $showImageView){
                    ImageView(item: item, isInEditMode: false)
                }
            }// end zstack
        }// end navigation stack
        
    }//end body
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let catArray = ["Miscellaneous", "Desk"]
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "Lorem ipsum dolor sit ametLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    newItem.image = data
//    let newCategory = CategoryDataModel(categoryList: catArray)
    container.mainContext.insert(newItem)
    
    for cat in catArray{
        let newCategory = CategoryDataModel(name: cat)
        container.mainContext.insert(newCategory)
    }
//    container.mainContext.insert(newCategory)
    return ItemSheetView(item: newItem)
        .modelContainer(container)
        .environmentObject(DYNotificationHandler())
}
