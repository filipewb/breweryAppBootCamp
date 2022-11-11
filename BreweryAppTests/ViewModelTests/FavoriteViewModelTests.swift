import Foundation
@testable import BreweryApp
import XCTest

class FavoriteViewModelTests: XCTestCase {
    
    let favoriteBrewery = FavoriteBrewery(id: "1", name: "Brewery", breweryType: "Pub", average: 4.5)
    var repository = FavoriteRepositoryMock()
    let index = IndexPath(row: 0, section: 0)
    var favoriteBreweriesManagedObject: FavoriteBreweriesManagedObject = []
    var viewModel: FavoritesListViewModel? = nil
    var favoriteBreweryList: [FavoriteBrewery] = []
    var favoriteBreweryTwo = FavoriteBrewery(id: "2", name: "Brewery2", breweryType: "Pub2", average: 4.5)
    
    override func setUpWithError() throws {
        viewModel = FavoritesListViewModel(favoriteBreweryRepository: repository)
        favoriteBreweryList = [favoriteBrewery, favoriteBreweryTwo]
    }
    
    func testFavoritesBrewery_TestGetFavoriteBreweries() {
        viewModel?.getFavoriteBreweries()
        XCTAssertTrue(self.repository.getFavoriteBreweriesCount == 1)
    }
    
    func testFavoritesBrewery_ResponseFromGetFavoriteBreweries() {
        let get = viewModel?.getFavoriteBreweriesManagedObject()
        XCTAssertNotNil(get)
    }
    
    func testFavoritesBrewery_ResponseFromGetFavoriteBrewery() {
        let response = viewModel?.getFavoriteBrewery(favoriteBreweryList, index: index)
        XCTAssertTrue(response?.name == "Brewery")
    }
    
    func testFavoritesBrewery_RespondeFromGetResultLabelText() {
        let response = viewModel?.getResultLabelText()
        XCTAssertTrue(response == "0 \(Texts.resultsSearch)")
    }
    
    func testFavoritesBrewery_RespondeFromGetCountFavoriteBreweriesManagedObject() {
        let response = viewModel?.getCountFavoriteBreweriesManagedObject()
        XCTAssertTrue(response == 0)
    }
}
