//consider implementing a custom form to allow for the background image to show. it would probably look cooler anyways.

import SwiftUI
import SwiftData


struct AddItemView: View {
    
    //SwiftData
    @Query var categories: [CategoryDataModel]
    @Environment(\.modelContext) var modelContext
    @Binding var selection: Int
    @State var item = ItemDataModel(name: "", location: "", category: "Miscellaneous", notes: "")
    
    //used for adding a new category
    @State private var showingAlert = false
    @State private var newCategoryName = ""
    
    var body: some View {
        
        NavigationStack {   //needed for the toolbar
            ZStack{
                //MARK: Background Image
                Image("modern app background")
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
                                    showingAlert.toggle()
                                    print(modelContext.sqliteCommand)
                                }
                                .alert("Enter Category Name", isPresented: $showingAlert){
                                    TextField("Enter Cateory Name", text: $newCategoryName)
                                    Button("OK", action: submitCategory)
                                    Button("Cancel") {
                                        newCategoryName = ""
                                    }
                                } message: {
                                    Text("")
                                }
                            }// end toolbaritem
                        }// end tool bar
                    
                }// end vstack
            }//end zstack
        } //end navigationStack
        
    }// end body
    
    func submitCategory(){
        //add newCategoryName to categories array
        categories[0].categoryList.append(newCategoryName)
        
        print("You entered \(newCategoryName)")
        newCategoryName = ""
        
        //COMMENT THIS OUT WHEN DEBUGGING IS NOT NEEDED
        //print("Printing swiftdata address:")
        //print(modelContext.sqliteCommand)
    }
    func changeScreen(){
        selection = 2
    }
}



#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let tempArray = ["Miscellaneous"]
    let newCategory = CategoryDataModel(categoryList: tempArray)
    container.mainContext.insert(newCategory)
    return AddItemView(selection: .constant(2))
        .modelContainer(container)
    
}
