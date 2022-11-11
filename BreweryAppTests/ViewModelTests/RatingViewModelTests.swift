import XCTest
import Foundation
@testable import BreweryApp

class RatingViewModelTests: XCTestCase {
    
    var viewModel = RatingViewModel(breweryRepository: BreweryRepositoryMock())
    
    let index = IndexPath(row: 0, section: 0)
    
    func testIsValidEmail_WhenGivenSuccessfulResponse_ReturnEmail() {
        let isEmail = viewModel.isValidEmail(email: "raul@gmail.com")
        XCTAssertEqual(isEmail, true)
    }
    
    func testIsValidEmail_WhenGivenSuccessfulResponse_ReturnNothing() {
        let isEmail = viewModel.isValidEmail(email: "xyzhltgmailcom")
        XCTAssertEqual(isEmail, false)
    }
    
    func testIsValidEmail_WhenGivenSuccessfulResponse_ReturnEmpty() {
        let isEmail = viewModel.isValidEmail(email: "")
        XCTAssertEqual(isEmail, false)
    }
    
    func testGetEmail_WhenGivenSuccessfulResponse_ReturnNothing() {
        let email = viewModel.getEmail()
        XCTAssertEqual(email, "")
    }
    
    func testGetEvaluationByEmail_WhenGivenSuccessfulResponse_ReturnBreweries() {
        viewModel.getEvaluationByEmail("raul@gmail.com.com")
        XCTAssertTrue(viewModel.getBreweryCount() == 2)
    }
    
    func testGetEvaluationByEmail_WhenGivenSuccessfulResponse_ReturnNothing() {
        viewModel.getEvaluationByEmail("")
        XCTAssertTrue(viewModel.getBreweryCount() == 0)
    }
    
    func testGetResultLabelText_WhenGivenSuccessfulResponse_ReturnText() {
        viewModel.getEvaluationByEmail("raul@gmail.com")
        var text = viewModel.getResultLabelText()
        XCTAssertTrue(text == "2 resultados")
        
        viewModel.getEvaluationByEmail("person@person.com")
        text = viewModel.getResultLabelText()
        XCTAssertTrue(text == "1 resultado")
    }
    
    func testGetCountBrewery_WhenGivenSuccessfulResponse_ReturnNothing() {
        viewModel.getEvaluationByEmail("raul@gmail.com.com")
        let count = viewModel.getBreweryCount()
        XCTAssertTrue(count == 2)
    }
    
    func testGetFirstLetterNameBrewery_WhenGivenSuccessfulResponse_ReturnFirstLetter() {
        viewModel.getEvaluationByEmail("raul@gmail.com.com")
        let firstLetter = viewModel.getBreweryNameFirstLetter(forIndex: index)
        XCTAssertEqual(firstLetter, "A")
    }
    
    func testGetFullNameBrewery_WhenGivenSuccessfulResponse_ReturnFullName() {
        viewModel.getEvaluationByEmail("raul@gmail.com.com")
        let fullName = viewModel.getFullNameBrewery(index: index)
        XCTAssertEqual(fullName, "Abbey Brewing Co")
    }
    
    func testFormatAverage_WhenGivenSuccessfulResponse_ReturnText() {
        viewModel.getEvaluationByEmail("raul@gmail.com.com")
        let averageForStar = viewModel.formatAverage(index: index)
        XCTAssertEqual(averageForStar, "3,3")
    }
    
    func testGetAverage_WhenGivenSuccessfulResponse_ReturnAverage() {
        viewModel.getEvaluationByEmail("raul@gmail.com.com")
        let averageForRating = viewModel.getAverage(index: index)
        XCTAssertEqual(averageForRating, "3.3")
    }
}
