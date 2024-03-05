//
//  ItemScrollView.swift
//  WheresMyStuff
//
//  Created by Andres Villarroel on 2/29/24.
//

import SwiftUI
import SwiftData

struct ItemsListView: View {
    
    //access to swiftdata model context and swiftdata model
    @Environment(\.modelContext) var context
    @Query var items: [ItemDataModel]
    
    var body: some View {
        
        List{
            ForEach(items) { item in
                ItemCell(item: item)
            }
            .onDelete{ indexSet in
                for index in indexSet{
                    context.delete(items[index])
                }
            }
            //making the item cells look better
            .listRowSeparator(.hidden)
            .listRowBackground(
                RoundedRectangle(cornerRadius: 5)
                    .background(.clear)
                    //.foregroundColor(.white)
                    .padding(
                        EdgeInsets(
                            top: 2,
                            leading: 10,
                            bottom: 2, 
                            trailing: 10
                        )
                    )
            )
            
        }
        
    }
}

#Preview {
    ItemsListView()
}
