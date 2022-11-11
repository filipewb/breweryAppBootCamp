import Foundation

class HomeCollectionViewCellViewModel {
    
    let brewery: BreweryTopTen
    
    init(_ brewery: BreweryTopTen) {
        self.brewery = brewery
    }
    
    func getBrewery() -> BreweryTopTen {
        return brewery
    }
    
    func getFullNameBrewery() -> String {
        return brewery.name
    }
    
    func getAverageBrewery() -> String {
        return String(brewery.average).replacingOccurrences(of: ".", with: ",")
    }
    
    func getBreweryType() -> String {
        return brewery.breweryType.capitalized
    }
    
    func getUrlBreweryImage(_ brewery: BreweryTopTen) -> URL {
        let url = brewery.photos?[0] ?? ""
        guard let urlImage = URL(string: url) else { return URL(fileURLWithPath: "") }
        return urlImage
    }
}
