//
//  ItemDataModel.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/27/24.
//

import Foundation
import SwiftData

@Model
class ItemDataModel {
    
    @Attribute(.unique) var id: String = UUID().uuidString
    let date: Date
    var name: String
    var location: String
    @Attribute(.externalStorage) var image : Data?
    var category: String
    var notes: String
    
    init(id: String = UUID().uuidString, date: Date = .now, name: String, location: String, category: String, notes: String) {
        self.id = id
        self.date = date
        self.name = name
        self.location = location
        self.category = category
        self.notes = notes
    }
}
