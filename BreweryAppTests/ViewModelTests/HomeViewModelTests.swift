@testable import BreweryApp
import XCTest

class HomeViewModelTests: XCTestCase {
    
    var repository = BreweryRepositoryMock()
        
    var viewModel: HomeViewModelProtocol? = nil
    
    override func setUpWithError() throws {
        viewModel = HomeViewModel(breweryRepository: repository)
    }
    
    func testSearchBreweries_WhenGivenSuccessfulResponse_returnBreweriesByCity() {
        self.viewModel?.getBreweriesBy(city: "Miami") {
            XCTAssertTrue(self.repository.count == 1)
        }
    }
}
