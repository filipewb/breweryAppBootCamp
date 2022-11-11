import Foundation
import CoreData

protocol FavoriteBreweryRepositoryProtocol {
    func saveFavoriteBrewery(_ brewery: FavoriteBrewery, completion: @escaping (Error) -> Void)
    func getFavoriteBreweries(completion: @escaping (Result<FavoriteBreweriesManagedObject, ServiceError>) -> Void)
    func deleteFavoriteBrewery(atIndex: IndexPath, forData: FavoriteBreweriesManagedObject, completion: @escaping (Error) -> Void)
}

class FavoriteBreweryRepository: FavoriteBreweryRepositoryProtocol {
    private let favoriteBreweryCoreDataService: FavoriteBreweryCoreDataServiceProtocol
    
    init(favoriteBreweryCoreDataService: FavoriteBreweryCoreDataServiceProtocol = FavoriteBreweryCoreDataService()) {
        self.favoriteBreweryCoreDataService = favoriteBreweryCoreDataService
    }
    
    func saveFavoriteBrewery(_ brewery: FavoriteBrewery, completion: @escaping (Error) -> Void) {
        favoriteBreweryCoreDataService.saveFavoriteBrewery(brewery) { error in
            completion(error)
        }
    }
    
    func getFavoriteBreweries(completion: @escaping (Result<FavoriteBreweriesManagedObject, ServiceError>) -> Void) {
        favoriteBreweryCoreDataService.getFavoriteBreweries { result in
            completion(result)
        }
    }
    
    func deleteFavoriteBrewery(atIndex: IndexPath, forData: FavoriteBreweriesManagedObject, completion: @escaping (Error) -> Void) {
        favoriteBreweryCoreDataService.deleteFavoriteBrewery(atIndex: atIndex, forData: forData) { error in
            completion(error)
        }
    }
}
