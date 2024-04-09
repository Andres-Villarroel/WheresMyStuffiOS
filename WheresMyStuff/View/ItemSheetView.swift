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
                
                Text("Name: \(item.name)")
                Divider()
                Text("Location: \(item.location)")
                Divider()
                Text("Category: \(item.category)")
                Divider()
                Text(item.date!, format: .dateTime.day().month().year().hour().minute())
                if !item.notes.isEmpty {
                    Divider()
                    Text("Notes: \(item.notes)")
                }
                Spacer()
                
            }
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
        }
    }
    
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let catArray = ["Miscellaneous", "Desk"]
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
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
/*
 CUSTOM LOG:
 let customLog = Logger(subsystem: "com.your_company.your_subsystem",
           category: "your_category_name")
    customLog.error("An error occurred!")
 
 Debug  [not saved to disk]         Captures information during development that is useful only for debugging your code.
 Info   [only using a log tool]     Captures information that is helpful, but not essential, to troubleshoot problems
 Error  [Yes, storage limit]        Captures errors seen during the execution of your code. If an activity object exists, the system captures information for the related process chain.
 Notice [Yes, storage limit]        Captures information that is essential for troubleshooting problems. For example, capture information that might result in a failure.
 Fault  [Yes, storage limit]        Captures information about faults and bugs in your code. If an activity object exists, the system captures information for the related process chain.
 */
