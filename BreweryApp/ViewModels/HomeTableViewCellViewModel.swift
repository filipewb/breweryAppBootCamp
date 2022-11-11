import Foundation

class HomeTableViewCellViewModel {
    
    var favoriteBreweriesManagedObject: FavoriteBreweriesManagedObject = []
    
    let favoriteBreweryRepository: FavoriteBreweryRepositoryProtocol
    
    let brewery: Brewery
    
    init(favoriteBreweriesRepository: FavoriteBreweryRepositoryProtocol = FavoriteBreweryRepository(), brewery: Brewery) {
        self.favoriteBreweryRepository = favoriteBreweriesRepository
        self.brewery = brewery
    }
    
    func getFavoriteBreweries() {
        favoriteBreweryRepository.getFavoriteBreweries { [weak self] result in
            switch result {
                
            case .success(let favoriteBreweries):
                self?.favoriteBreweriesManagedObject = favoriteBreweries
                
            case .failure(_): break
            }
        }
    }
    
    func getBrewery() -> Brewery {
        return brewery
    }
    
    func getFirstLetterNameBrewery() -> String {
        return String(brewery.name.prefix(1))
    }
    
    func getFullNameBrewery() -> String {
        return brewery.name
    }
    
    func getDescriptionLabel() -> String {
        return "\(getAverageBrewery()) • \(getBreweryType().capitalized)"
    }
    
    func getAverageBrewery() -> String {
        return String(brewery.average).replacingOccurrences(of: ".", with: ",")
    }
    
    func getBreweryType() -> String {
        return brewery.breweryType
    }
    
    func isFavorited(brewery: Brewery) -> Bool {
        let favoriteBreweriesManagedObject = getFavoriteBreweriesManagedObject()
        
        if favoriteBreweriesManagedObject.contains(where: {$0.value(forKey: "id") as? String == brewery.id}) {
            return true
        }
        return false
    }
    
    func getFavoriteBreweriesManagedObject() -> FavoriteBreweriesManagedObject {
        return favoriteBreweriesManagedObject
    }
    
    func saveOrDeleteFavoriteAtCoreData(viewModel: HomeTableViewCellViewModel, brewery: Brewery, isFavorited: Bool, isSelected: Bool) {
        if isSelected {
            if isFavorited == false {
                let favoriteBrewery = viewModel.getFavoriteBrewery(brewery: brewery)
                
                viewModel.saveFavoriteBrewery(favoriteBrewery)
            }
        }
        else {
            if isFavorited == true {
                let favoriteBreweriesManagedObject = viewModel.getFavoriteBreweriesManagedObject()
                
                let index = viewModel.getIndexPathFromCoreData(brewery: brewery)
                
                viewModel.deleteFavoriteBrewery(atIndex: index, forData: favoriteBreweriesManagedObject)
            }
        }
    }
    
    func getFavoriteBrewery(brewery: Brewery) -> FavoriteBrewery {
        let favoriteBrewery = FavoriteBrewery(
            id: brewery.id,
            name: brewery.name,
            breweryType: brewery.breweryType,
            average: brewery.average
        )
        return favoriteBrewery
    }
    
    func saveFavoriteBrewery(_ brewery: FavoriteBrewery) {
        favoriteBreweryRepository.saveFavoriteBrewery(brewery) { error in
        }
    }
    
    func getIndexPathFromCoreData(brewery: Brewery) -> IndexPath {
        let favoriteBreweriesManagedObject = getFavoriteBreweriesManagedObject()
        
        var index: IndexPath = [0,0]
        
        for favorite in favoriteBreweriesManagedObject {
            if favorite.value(forKey: "id") as? String == brewery.id {
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
}
