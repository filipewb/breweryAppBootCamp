import Foundation

class FavoritesListViewModel {
    
    var favoriteBreweriesManagedObject: FavoriteBreweriesManagedObject = []
    
    let favoriteBreweryRepository: FavoriteBreweryRepositoryProtocol
    
    var favoriteBreweryList: [FavoriteBrewery] = []
    
    init(favoriteBreweryRepository: FavoriteBreweryRepositoryProtocol) {
        self.favoriteBreweryRepository = favoriteBreweryRepository
    }
    
    func convertFavoriteBreweryList(favoriteBreweriesManagedObject: FavoriteBreweriesManagedObject) -> [FavoriteBrewery] {
        
        return favoriteBreweriesManagedObject.map { FavoriteBrewery(id: $0.value(forKey: "id") as? String ?? "", name: $0.value(forKey: "name") as? String ?? "", breweryType: $0.value(forKey: "breweryType") as? String ?? "", average: $0.value(forKey: "average") as? Double ?? 0.0) }
    }
    
    func sortFavoritBreweriesByName(favoriteBreweries: [FavoriteBrewery]) -> [FavoriteBrewery] {
         return favoriteBreweries.sorted{$0.name < $1.name}
    }
    
    func getFavoriteBreweries() {
        favoriteBreweryRepository.getFavoriteBreweries { [weak self] result in
            switch result {
                
            case .success(let favoriteBreweries):
                let favoriteUnsortedBreweries = self?.convertFavoriteBreweryList(favoriteBreweriesManagedObject: favoriteBreweries)
                self?.favoriteBreweryList = self?.sortFavoritBreweriesByName(favoriteBreweries: favoriteUnsortedBreweries ?? .init()) ?? .init()
                self?.favoriteBreweriesManagedObject = favoriteBreweries
            case .failure(_): break
            }
        }
    }
    
    func getCountFavoriteBreweriesManagedObject() -> Int {
        return favoriteBreweriesManagedObject.count
    }
    
    func getResultLabelText() -> String {
        let number = getCountFavoriteBreweriesManagedObject()
        
        if number == 1 {
            return "\(number) \(Texts.resultSearch)"
        } else {
            return "\(number) \(Texts.resultsSearch)"
        }
    }
    
    func getFavoriteBreweriesManagedObject() -> FavoriteBreweriesManagedObject {
        return favoriteBreweriesManagedObject
    }
    
    func getFavoriteBrewery(_ favoriteBreweries: [FavoriteBrewery], index: IndexPath) -> FavoriteBrewery {
        
        return favoriteBreweries[index.row]
    }
}
