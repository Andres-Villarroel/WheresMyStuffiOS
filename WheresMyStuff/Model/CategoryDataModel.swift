
import Foundation
import SwiftData

@Model
class CategoryDataModel {
    
    //var name: String
    var name = ""
    var id: String = UUID().uuidString
    
    init(name: String = "", id: String = UUID().uuidString) {
        self.name = name
    }
}
