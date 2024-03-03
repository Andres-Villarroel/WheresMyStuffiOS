//
//  CategoryDataModel.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/2/24.
//

import Foundation
import SwiftData

@Model
class CategoryDataModel {
    
    @Attribute(.unique) var id: String = UUID().uuidString
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
