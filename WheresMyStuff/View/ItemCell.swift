
import SwiftUI
import SwiftData //note that this is only used in the preview

struct ItemCell: View {
    var item: ItemDataModel
    
    var body: some View {
        
        HStack{
            if item.image != nil {
                Image(uiImage: UIImage(data: item.image!)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 100)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 100)
            }
            Spacer()
            VStack {
                
                Text(item.name)
                    .font(.title3)
                    .bold()
                
                Text(item.location)
                    .font(.subheadline)
                //Text(item.notes), add this when item is tapped. maybe notify that it has notes
                
            }
            Spacer()
        }// end hstack
        .frame(height: 60)
        .padding()
        .background(.ultraThinMaterial)
//        .background(Color.purple)
//        .blur(radius: 5)
//        .clipShape((RoundedRectangle(cornerRadius: 30)))
    }
}


//could not let me use an ItemDataModel test data due to the lack of a container
#Preview {
    //converting a test image to data
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    
    //setting up swiftdata container
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: ItemDataModel.self, configurations: config)
    
    //loading test data into the data model
    let item = ItemDataModel(name: "TestName", location: "TestLocation", category: "TestCategory", notes: "TestNotes")
    item.image = data
    
    //returning view with the testing container attached
    return ItemCell(item: item)
        .modelContainer(container)
}
