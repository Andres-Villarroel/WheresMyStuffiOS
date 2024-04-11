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
    
    var id: String = UUID().uuidString
    @Attribute(.externalStorage) var image : Data?
    var lastUpdatedDate: Date?
    let creationDate: Date?
    var name: String = ""
    var location: String = ""
    var category: String = ""
    var notes: String = ""
    var lastViewDate: Date?
    
    init(id: String = UUID().uuidString, date: Date = .now, lastUpdatedDate: Date = .now, name: String, location: String, category: String, notes: String, lastViewDate: Date = .now) {
        self.id = id
        self.creationDate = date
        self.lastUpdatedDate = lastUpdatedDate
        self.name = name
        self.location = location
        self.category = category
        self.notes = notes
        self.lastViewDate = lastViewDate
    }
}
