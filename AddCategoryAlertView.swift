import SwiftUI
import SwiftData
import os
import Combine

struct AddCategoryAlertView: View {
    @Binding var showView: Bool
    let log = Logger(subsystem: "WheresMyStuff", category: "AddCategoryViewAlert")
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var constants: GlobalConstant
    @Query var categories: [CategoryDataModel]
    @State private var newCategoryName = ""
    @State private var inputValMessage = ""
    
    var body: some View {
            VStack(spacing: 0){
                //MARK: Texts and textfield
                VStack{
                    Spacer()
                    Text("Enter Category Name")
                    
                    if (!inputValMessage.isEmpty){
                        Text(inputValMessage)   //if input validation fails, the reason will be shown here.
                            .foregroundStyle(Color.red)
                            .padding([.top, .bottom], 2)
                    } else {
                        Spacer()
                    }
                    
                    TextField("Enter Cateory Name", text: $newCategoryName)
                    //                    .padding(5)
                        .background(Color.init(uiColor: .darkGray))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .foregroundStyle(Color.white)
                        .frame(width: 200)
                    Spacer()
                    Divider()
                }//end vstack
                
                //MARK: Buttons
                HStack (){
                    Spacer()
                    Button("Submit", action: submitCategory)
                        .disabled(newCategoryName.isEmpty || newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .tint(constants.buttonColor)
                    
                    Divider()
                        .padding([.leading, .trailing], 30)
                    
                    Button("Cancel", role: .destructive) {
                        newCategoryName = ""
                        showView = false
                    }
                    Spacer()
                }// end hstack
                .frame(height: 50)
                
            }//end vstack
            .frame(width: 250, height: 170)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    private func submitCategory(){
        //check that there is no duplicates in category database
        if (!doesExist(categoryName: newCategoryName)){
            modelContext.insert(CategoryDataModel(name: newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines)))
            showView = false
        } else {
            inputValMessage = "Category already exists"
        }
    }
    
    private func doesExist(categoryName: String) -> Bool {
        for cat in categories{
            if (cat.name == categoryName){
                return true
            }
        }
        return false
    }
}

#Preview {
    let container = try! ModelContainer(for: CategoryDataModel.self, ItemDataModel.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let image = UIImage(named: "tiltedParrot")!
    let data = image.pngData()
    
    let newItem = ItemDataModel(name: "test name", location: "test location", category: "testMiscellaneous", notes: "test notes")
    
    newItem.image = data
    
    container.mainContext.insert(newItem)
    
    let tempName = "testMiscellaneous"
    let newCategory = CategoryDataModel(name: tempName)
    container.mainContext.insert(newCategory)
    
    return AddCategoryAlertView(showView: .constant(true))
        .modelContainer(container)
        .environmentObject(GlobalConstant())
}
