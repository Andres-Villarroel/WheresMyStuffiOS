//
//  CategoryList.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/2/24.
//

import Foundation

class Category: ObservableObject{
    @Published var categoryList = ["Miscellaneous"]
    //@Published var categoryList: [String] = []
    
//    init() {
//        self.categoryList = ["Miscellaneous"]
//    }
    
    func appendNewCategory(newCat: String){
        categoryList.append(newCat)
    }
    
    
}
