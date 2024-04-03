import SwiftUI
import SwiftData

struct SearchView: View {
    
    //accessing swiftdata content
    @Query var items: [ItemDataModel]
    //    @State private var searchText = ""  //holds the user's search term
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { _ in   //necesary to get rid of that very annoying visual bug that pushed the list under the navigation bar whenever the keyboard appeared
                ZStack {
                    //MARK: Background Image
                    Image("appBackground")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .ignoresSafeArea(.all)
                    
                    ItemsListView(items: viewModel.calculateSearch())
                        .onAppear() {
                            viewModel.items = items
                        }
                        .preferredColorScheme(.dark)
                    
                    //                    .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "What do you want to find?")
                        .searchable(text: $viewModel.searchText, prompt: "What do you want to find?")//this provides the search function such as the built-in search bar
                }// end zstack
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .navigationTitle("Search Items")
            //            .toolbar(.hidden)
            
            //            .navigationBarTitleDisplayMode(.inline)
            //
            //            )
        }// end navigation stack
        
        //should the search not find anything, this view will appear with a message notifying the user of search failure
        .overlay {
            if viewModel.calculateSearch().isEmpty {
                ContentUnavailableView.search
            }
        }// end overlay
        //        .toolbarBackground(.visible, for: .navigationBar)
    }// end body
}

/*
 struct BlurView: UIViewRepresentable {
 var style: UIBlurEffect.Style
 
 func makeUIView(context: Context) -> UIVisualEffectView {
 return UIVisualEffectView(effect: UIBlurEffect(style: style))
 }
 
 func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
 }
 */
#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "test category", notes: "test notes")
    newItem.image = data
    let firstItem = ItemDataModel(name: "Pen", location: "Desk", category: "Desk", notes: "First added")
    firstItem.image = data
    let secondItem = ItemDataModel(name: "PSP", location: "Closet middle", category: "Closet", notes: "Second added")
    secondItem.image = data
    let thirdItem = ItemDataModel(name: "Dehumidifier", location: "Chloe's Crate", category: "My Bedroom", notes: "Third added")
    thirdItem.image = data
    let fourthItem = ItemDataModel(name: "test", location: "Test", category: "test", notes: "test")
    fourthItem.image = data
    let fifthItem = ItemDataModel(name: "test", location: "Test", category: "test", notes: "test")
    fifthItem.image = data
    let sixthItem = ItemDataModel(name: "test", location: "Test", category: "test", notes: "test")
    sixthItem.image = data
    let seventhItem = ItemDataModel(name: "test", location: "Test", category: "test", notes: "test")
    seventhItem.image = data
    
    container.mainContext.insert(newItem)
    container.mainContext.insert(firstItem)
    container.mainContext.insert(secondItem)
    container.mainContext.insert(thirdItem)
    container.mainContext.insert(newItem)
    container.mainContext.insert(fourthItem)
    container.mainContext.insert(fifthItem)
    container.mainContext.insert(sixthItem)
    container.mainContext.insert(seventhItem)
    let tempArray = ["testMiscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return SearchView()
        .modelContainer(container)
}
