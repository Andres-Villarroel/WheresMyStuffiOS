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
                    
                    //calculateSearch returns an array of ItemDataModel
//                    ItemsListView(searchResultItems: viewModel.calculateSearch())
                    ItemsListView(filterString: viewModel.searchText)
                        .onAppear() {
                            viewModel.items = items
                        }
//                        .preferredColorScheme(.dark)
                        .searchable(text: $viewModel.searchText, prompt: "What do you want to find?")//this provides the search function such as the built-in search bar
                }// end zstack
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .navigationTitle("Search Items")
        }// end navigation stack
        
        //should the search not find anything or no items exist, this view will appear with a message notifying the user of search failure
        .overlay {
            if viewModel.calculateSearch().isEmpty {
//                ContentUnavailableView.search
                ContentUnavailableView {
                    VStack{
                        Image("notFoundRooster")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 150)
                        Text("No Results")
                    }
                } description: {
                    Text("Check the spelling or try a new search.")
                }
            }
        }// end overlay
    }// end body
}

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
//    container.mainContext.insert(newItem)
//    container.mainContext.insert(fourthItem)
//    container.mainContext.insert(fifthItem)
//    container.mainContext.insert(sixthItem)
//    container.mainContext.insert(seventhItem)
    let tempArray = ["testMiscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return SearchView()
        .modelContainer(container)
}
/*
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
                     
                     //calculateSearch returns an array of ItemDataModel
                     ItemsListView(searchResultItems: viewModel.calculateSearch())
                         .onAppear() {
                             viewModel.items = items
                         }
                         .preferredColorScheme(.dark)
                         .searchable(text: $viewModel.searchText, prompt: "What do you want to find?")//this provides the search function such as the built-in search bar
                 }// end zstack
                 .ignoresSafeArea(.keyboard, edges: .bottom)
             }
             .navigationTitle("Search Items")
         }// end navigation stack
         
         //should the search not find anything or no items exist, this view will appear with a message notifying the user of search failure
         .overlay {
             if viewModel.calculateSearch().isEmpty {
 //                ContentUnavailableView.search
                 ContentUnavailableView {
                     VStack{
                         Image("notFoundRooster")
                             .resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(maxWidth: 150)
                         Text("No Results")
                     }
                 } description: {
                     Text("Check the spelling or try a new search.")
                 }
             }
         }// end overlay
     }// end body
 }

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
 //    container.mainContext.insert(newItem)
 //    container.mainContext.insert(fourthItem)
 //    container.mainContext.insert(fifthItem)
 //    container.mainContext.insert(sixthItem)
 //    container.mainContext.insert(seventhItem)
     let tempArray = ["testMiscellaneous"]
     let newCategory = CategoryDataModel(categoryList: tempArray)
     container.mainContext.insert(newCategory)
     return SearchView()
         .modelContainer(container)
 }

 */
