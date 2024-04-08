//
//  CategoryContainer.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 3/2/24.
//

import Foundation
import SwiftData
import SwiftUI

actor CustomContainer {
    
    @MainActor
    static func create() -> ModelContainer {
        @AppStorage("isFirstTimeLaunch") var shouldCreateDefaults: Bool = true
        let schema = Schema([
            ItemDataModel.self,
            CategoryDataModel.self
        ])
        let config = ModelConfiguration()
        let container = try! ModelContainer(for: schema, configurations: config)
        /*
         If a list of data needs to be pre-loaded, this statement could be used:
            InsertCustomModelHere.defaults.forEach {container.mainContext.insert($0) }
         The above example is pre-loading using an array
         */
        
        //the default values defined in the container file runs all the time upon startup. if the user were to delete the Miscellaneous category, it would continue to show up which would be annoying.
        if shouldCreateDefaults {
//            let tempStringArray = ["Miscellaneous"]
            let defaultCategory = "Miscellaneous"
//            container.mainContext.insert(CategoryDataModel(categoryList: tempStringArray))
            container.mainContext.insert(CategoryDataModel(name: defaultCategory))
            shouldCreateDefaults = false
        }
        return container
    }
}
