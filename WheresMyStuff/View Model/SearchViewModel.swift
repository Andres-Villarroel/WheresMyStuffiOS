

import Foundation

final class SearchViewModel: ObservableObject {
    @Published var items: [ItemDataModel] = []
    @Published var searchText = ""  //holds the user's search term
    
    func calculateSearch() -> [ItemDataModel] {
        if searchText.isEmpty {
            return items
        } else {
            let filteredItems = items.compactMap { item in
                let titleContainsSearch = item.name.range(of: searchText, options: .caseInsensitive) != nil
                let locationTitle = item.location.range(of: searchText, options: .caseInsensitive) != nil
                return (titleContainsSearch || locationTitle) ? item : nil
            }
            return filteredItems
        }
    }
}
