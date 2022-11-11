import Foundation
@testable import BreweryApp

class FavoriteRepositoryMock: FavoriteBreweryRepositoryProtocol {

    var saveFavoriteBreweryCount: Int = 0
    var getFavoriteBreweriesCount: Int = 0
    var deleteFavoriteBreweryCount: Int = 0
    var favoriteBreweriesManagedObject: FavoriteBreweriesManagedObject = []
    
    func saveFavoriteBrewery(_ brewery: FavoriteBrewery, completion: @escaping (Error) -> Void) {
        saveFavoriteBreweryCount += 1
        completion(ServiceError.badRequest)
    }
    
    func getFavoriteBreweries(completion: @escaping (Result<FavoriteBreweriesManagedObject, ServiceError>) -> Void) {
        getFavoriteBreweriesCount += 1
        completion(.success(favoriteBreweriesManagedObject))
    }
    
    func deleteFavoriteBrewery(atIndex: IndexPath, forData: FavoriteBreweriesManagedObject, completion: @escaping (Error) -> Void) {        deleteFavoriteBreweryCount += 1
        completion(ServiceError.badRequest)
    }
}
