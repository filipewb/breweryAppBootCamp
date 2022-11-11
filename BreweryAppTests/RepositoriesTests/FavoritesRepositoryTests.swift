import Foundation
@testable import BreweryApp
import XCTest

class FavoritesRepositoryTests: XCTestCase {
    
    let favoriteBrewery = FavoriteBrewery(id: "1", name: "Brewery", breweryType: "Pub", average: 4.5)
    let service = FavoritesBreweryServiceMock()
    var repository: FavoriteBreweryRepositoryProtocol? = nil
    let index = IndexPath(row: 0, section: 0)
    var favoriteBreweriesManagedObject: FavoriteBreweriesManagedObject = []
    
    override func setUpWithError() throws {
        repository = FavoriteBreweryRepository(favoriteBreweryCoreDataService: service)
    }
    
    func testFavoritesBrewery_VerifyIfSaveFavoriteBreweryWasCalled() {
        repository?.saveFavoriteBrewery(favoriteBrewery) { error in
            XCTAssertTrue(self.service.saveFavoriteBreweryCount == 1)
        }
    }
    
    func testFavoritesBrewery_ResponseFromGetFavoriteBrewery() {
        repository?.getFavoriteBreweries(completion: { response in
            switch response {
            case .success(_):
                XCTAssertTrue(self.service.getFavoriteBreweriesCount == 1)
            case .failure(_):
                break
            }
        })
    }
    
    func testFavoritesBrewery_VerifyIfDeleteFavoriteBreweryWasCalled() {
        repository?.deleteFavoriteBrewery(atIndex: index, forData: favoriteBreweriesManagedObject, completion: { error in
            XCTAssertTrue(self.service.deleteFavoriteBreweryCount == 1)
        })
    }
}
