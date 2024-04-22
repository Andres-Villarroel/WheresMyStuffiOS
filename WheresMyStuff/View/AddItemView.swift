//consider implementing a custom form to allow for the background image to show. it would probably look cooler anyways.

import SwiftUI
import SwiftData


struct AddItemView: View {
    
    //SwiftData
    @Query var categories: [CategoryDataModel]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var constants: GlobalConstant
    @State var showAddCategoryView = false
    @Binding var selection: Int
    @State var item = ItemDataModel(name: "", location: "", category: "Miscellaneous", notes: "")
    
    //used for adding a new category
    @State private var showingAlert = false
    @State private var newCategoryName = ""
    
    var body: some View {
        ZStack{
            NavigationStack {   //needed for the toolbar
                GeometryReader { _ in   //used in conjunction with .ignoreSafeAreas(.keyboard) to keep the keyboard from moving the view
                    ZStack{
                        //MARK: Background Image
                        Image("appBackground")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .ignoresSafeArea(.all)
                        
                        VStack {
                            FormView(nextScreen: changeScreen, item: $item )
                                .navigationTitle("Add Item")
                                .preferredColorScheme(.dark)
                                .scrollContentBackground(.hidden)
                            //this section add the tool bar button to add a new category
                                .toolbar{
                                    ToolbarItem(placement: .topBarTrailing){
                                        Button("Add Category"){
                                            withAnimation {
                                                showAddCategoryView.toggle()
                                            }
                                        }
                                        .foregroundStyle(constants.buttonColor)
                                    }// end toolbaritem
                                }// end tool bar
                            
                        }// end vstack
                    }//end zstack
                    .ignoresSafeArea(.keyboard)
                }//end geometry reader
            } //end navigationStack
            //TODO: insert alert view here!!!
            if(showAddCategoryView){
                AddCategoryAlertView(showView: $showAddCategoryView)
            }
        }//end zstack
    }// end body
    
    func submitCategory(){
        //add newCategoryName to categories array
//        categories[0].categoryList.append(newCategoryName)
        modelContext.insert(CategoryDataModel(name: newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)))
        
        print("You entered \(newCategoryName)")
        newCategoryName = ""
    }
    func changeScreen(){
        selection = 2
    }
}



#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//    let tempArray = ["Miscellaneous"]
    let tempName = "Miscellaneous"
//    let newCategory = CategoryDataModel(categoryList: tempArray)
    let newCategory = CategoryDataModel(name: tempName)
    container.mainContext.insert(newCategory)
    return AddItemView(selection: .constant(2))
        .modelContainer(container)
    
}
