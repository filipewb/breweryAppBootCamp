@testable import BreweryApp
import XCTest
import Foundation

class BreweryDetailsViewModelTests: XCTestCase {
    
    var repository = BreweryRepositoryMock()
    
    var viewModel: BreweryDetailsViewModelProtocol? = nil
    
    override func setUpWithError() throws {
        viewModel = BreweryDetailsViewModel(breweryRepository: repository, favoriteBreweryRepository: FavoriteRepositoryMock())
    }
        
    func testBreweryDetails_VerifyIfUploadPhotoBreweryWasCalled() {
        viewModel?.uploadImage(data: .init(), boundary: "1F1F5E3B-FBAB-481E-93DA-6F37B1B2F92F", breweryId: "birreria-eataly-new-york") { result in
            XCTAssertTrue(self.repository.count == 1)
        }
    }
}
