import Foundation

class FavoritesListTableViewCellViewModel {
    
    var favoriteBreweriesManagedObject: FavoriteBreweriesManagedObject = []
    
    let favoriteBreweryRepository: FavoriteBreweryRepositoryProtocol
    
    let favoriteBrewery: FavoriteBrewery
        
    init(favoriteBreweriesRepository: FavoriteBreweryRepositoryProtocol = FavoriteBreweryRepository(), favoriteBrewery: FavoriteBrewery) {
        self.favoriteBreweryRepository = favoriteBreweriesRepository
        self.favoriteBrewery = favoriteBrewery
    }
    
    func getFavoriteBreweries() {
        favoriteBreweryRepository.getFavoriteBreweries { [weak self] result in
            switch result {
                
            case .success(let favoritebreweries):
                self?.favoriteBreweriesManagedObject = favoritebreweries
                
            case .failure(_): break
            }
        }
    }
    
    func getFavoriteBrewery() -> FavoriteBrewery {
        return favoriteBrewery
    }
    
    func getFirstLetterNameBrewery() -> String {
        return String(favoriteBrewery.name.prefix(1))
    }
    
    func getFullNameBrewery() -> String {
        return favoriteBrewery.name
    }
    
    func getDescriptionLabel() -> String {
        return "\(getAverageBrewery()) • \(getBreweryType().capitalized)"
    }
    
    func getAverageBrewery() -> String {
        return String(favoriteBrewery.average).replacingOccurrences(of: ".", with: ",")
    }
    
    func getBreweryType() -> String {
        return favoriteBrewery.breweryType
    }
    
    func isFavorited(favoriteBrewery: FavoriteBrewery) -> Bool {
        let favoriteBreweriesManagedObject = getFavoriteBreweriesManagedObject()
        
        if favoriteBreweriesManagedObject.contains(where: {$0.value(forKey: "id") as? String == favoriteBrewery.id}) {
            return true
        }
        return false
    }
    
    func getFavoriteBreweriesManagedObject() -> FavoriteBreweriesManagedObject {
        return favoriteBreweriesManagedObject
    }
    
    func getIndexPathFromCoreData(favoriteBrewery: FavoriteBrewery) -> IndexPath {
        let favoriteBreweriesManagedObject = getFavoriteBreweriesManagedObject()
        
        var index: IndexPath = [0,0]
        
        for favorite in favoriteBreweriesManagedObject {
            if favorite.value(forKey: "id") as? String == favoriteBrewery.id {
                return index
            }
            index.row = index.row+1
        }
        return index
    }
        
    func deleteFavoriteBrewery(atIndex index: IndexPath, forData data: FavoriteBreweriesManagedObject) {
        favoriteBreweryRepository.deleteFavoriteBrewery(atIndex: index, forData: data) { error in
        }
    }
    
    func getCountFavoriteBreweriesManagedObject() -> Int {
        return favoriteBreweriesManagedObject.count
    }
}
