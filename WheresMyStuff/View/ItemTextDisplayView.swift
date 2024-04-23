import SwiftUI
import SwiftData

struct ItemTextDisplayView: View {
    let item: ItemDataModel
    private let cRadius = CGFloat(5)
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Name")
                    .bold()
                Text(item.name)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: cRadius))
            }
            .padding(.top)
            VStack{
                Text("Location")
                    .bold()
                Text(item.location)
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: cRadius))
            }
            
            if(!item.category.isEmpty){
                //            Spacer()
                VStack{
                    Text("Category")
                        .bold()
                    Text(item.category)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: cRadius))
                }
            }
            
            if(!item.notes.isEmpty){
                VStack{
                    Text("Notes")
                        .bold()
                    ScrollView {
                        Text(item.notes)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: cRadius))
                    }
                }
                .frame(maxHeight: 150)
            }
            
            VStack{
                Text("Created: \(item.creationDate!, format: .dateTime.day().month().year().hour().minute())")
                    .padding(5)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: cRadius))
                Text("Last Updated: \(item.lastUpdatedDate!, format: .dateTime.day().month().year().hour().minute())")
                    .padding(5)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: cRadius))
            }
        }//end vstack
        Spacer()
    }
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    
    let item  = ItemDataModel(name: "item name", location: "item location", category: "item category", notes: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.")
    return ItemTextDisplayView(item: item)
        .modelContainer(container)
}
