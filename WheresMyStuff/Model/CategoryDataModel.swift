//
//  CategoryDataModel.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/2/24.
//

//REMINDER: data models should only contain abstract code, nothing hardcoded such as the case for default values.
// Default values can be added through the model container context
import Foundation
import SwiftData

@Model
class CategoryDataModel {
    
    //var name: String
    var categoryList: [String] = []
    
    init(categoryList: [String]) {
        self.categoryList = categoryList
    }
}
