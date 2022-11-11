import Foundation

protocol FilterModalViewDelegate: AnyObject {
    func updateFilterLabel(filterLabel: String)
}

class FilterModalViewModel {
    
    weak var delegate: FilterModalViewDelegate?
    
    var favoriteBreweries: [FavoriteBrewery]? = nil
    var breweries: Breweries? = nil
    
    init(breweries: Breweries? = nil, favoriteBreweries: [FavoriteBrewery]? = nil) {
        self.breweries = breweries
        self.favoriteBreweries = favoriteBreweries
    }
    
    func sortFavoriteBreweriesByRating() -> [FavoriteBrewery] {
        let sortBreweriesByRating = favoriteBreweries?.sorted{$0.average > $1.average} ?? []
        return sortBreweriesByRating
    }
    
    func sortFavoriteBreweriesByLetter() -> [FavoriteBrewery] {
        let sortBreweriesByLetter = favoriteBreweries?.sorted{$0.name < $1.name} ?? []
        return sortBreweriesByLetter
    }
    
    
    func sortBreweriesByRating() -> Breweries {
        let sortBreweriesByRating = breweries?.sorted{$0.average > $1.average}
        return sortBreweriesByRating ?? []
    }
    
    func sortBreweriesByLetter() -> Breweries {
        let sortBreweriesByLetter = breweries?.sorted{$0.name < $1.name}
        return sortBreweriesByLetter ?? []
    }
    
    func setFilterLabel() {
        if  UserDefaults.standard.bool(forKey: "isAlphabeticFilter") == true {
            self.delegate?.updateFilterLabel(filterLabel: Texts.name)
        } else {
            self.delegate?.updateFilterLabel(filterLabel: Texts.nota)
        }
    }
}
