import XCTest
import Foundation
@testable import BreweryApp


class BreweryRepositoryTests: XCTestCase {
    
    var repository = BreweryRepository(service: ServiceMock())
    
    func testSearchBreweries_WhenGivenSuccessfulResponse_returnBreweriesByCity() {
        repository.getBreweriesBy(city: "Miami") { response in
            switch response {
            case .success(let breweries):
                XCTAssertNotNil(breweries, "Should have returned breweries list, but instead returned nil")
                XCTAssertTrue(breweries[0].name == "Abbey Brewing Co")
            case .failure(_):
                break
            }
        }
    }
}
