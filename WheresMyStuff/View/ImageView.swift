import SwiftUI
import SwiftData

struct ImageView: View {
//    @Binding var imageData: Data?
    let item: ItemDataModel
    var isInEditMode: Bool
    @State private var currentZoom = 0.0
    @State private var totalZoom = 1.0
    
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
            .toolbar {
                if isInEditMode {
                    Button(action: deleteImage, label: {
                        Image(systemName: "trash")
                            .foregroundStyle(Color.white)
                    })
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black).edgesIgnoringSafeArea(.all)
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
    
    return ImageView(item: tempItem, isInEditMode: shouldEdit)
        .modelContainer(container)
}
