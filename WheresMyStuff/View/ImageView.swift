import SwiftUI
import SwiftData

struct ImageView: View {
    let item: ItemDataModel
    
    var body: some View {
        NavigationStack {
            VStack {
                
                if(item.image != nil){
                    let image = UIImage(data: item.image!)
                    ZoomableScrollView {
                        Image(uiImage: image!)
                            .resizable()
                            .scaledToFit()
                    }
                } else {
                    Image("defaultPhoto")
                        .resizable()
                        .scaledToFit()
                }
            }
        }
    }// end body
    
    private func deleteImage() {
        item.image = nil
    }
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let tempItem = ItemDataModel(name: "test name", location: "test location", category: "Miscellaneous", notes: "test notes")
    let shouldEdit = true
    
    let image = UIImage(named: "tiltedParrot")!
    @State var data = image.pngData()
    tempItem.image = data
    
    return ImageView(item: tempItem)
        .modelContainer(container)
}
