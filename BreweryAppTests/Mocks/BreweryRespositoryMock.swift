import Foundation
@testable import BreweryApp

class BreweryRepositoryMock: BreweryRepositoryProtocol {
    
    let service = ServiceMock()
    
    var count: Int = 0
    
    func getBreweriesBy(city: String, completion: @escaping (Result<[Brewery], ServiceError>) -> Void) {
        service.fetchBreweriesBy(city: "Miami") { [self] response in
            self.count += 1
            completion(response)
        }
    }
    
    func getBreweryDetailsBy(id: String, completion: @escaping (Result<Brewery, ServiceError>) -> Void) {  }
    
    func getTopTenBreweries(completion: @escaping (Result<BreweriesTopTen, ServiceError>) -> Void) { }
    
    func postRating(email: String, breweryId: String, evaluationGrade: Double, completion: @escaping (Result<[String : Any], ServiceError>) -> Void) { }
    
    func getEvaluationByEmail(email: String, completion: @escaping (Result<Breweries, ServiceError>) -> Void) {
        service.fetchEvaluationByEmail(email: email) { result in
            completion(result)
        }
    }
    
    func uploadImage(data: Data, boundary: String, breweryId: String, completion: @escaping (Result<[String : Any], ServiceError>) -> Void) {
        service.uploadImage(data: data, boundary: boundary, breweryId: breweryId) { result in
            self.count += 1
            completion(result)
        }
    }
    
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void) { }
}
