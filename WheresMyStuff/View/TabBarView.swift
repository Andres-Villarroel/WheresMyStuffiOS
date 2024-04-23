import SwiftUI
import SwiftData

struct TabBarView: View {
    @State var selection = 2
    
    var body: some View {
        TabView(selection:$selection){
            
            AddItemView(selection: $selection)
                .tabItem{
                    Label("Add", systemImage: "plus")
                }
                .tag(1)
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "list.dash")
                }
                .tag(2)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(3)
            
        }// end tabview
        .tint(.white)
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            
            UITabBar.appearance().standardAppearance = appearance
            
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

#Preview {
    
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous"]
    for cat in tempArray{
        let newCategory = CategoryDataModel(name: cat)
        container.mainContext.insert(newCategory)
    }
    return TabBarView()
        .modelContainer(container)
        .environmentObject(GlobalConstant())
}
