//
//  WheresMyStuffApp.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/20/24.
//

import SwiftUI
import SwiftData

@main
struct WheresMyStuffApp: App {
    
    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                //.environmentObject(pickerOptions)
        }
        
        .modelContainer(CustomContainer.create())
        /*
         .modelContainer(for: [
             ItemDataModel.self,
             CategoryDataModel.self
         
         ])    //creates storage for the app and adds data models to it
         */
    }
}
//for gaining direct access to the sqlite database that Swift Data uses
extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
