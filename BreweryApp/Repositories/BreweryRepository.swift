import Foundation

protocol BreweryRepositoryProtocol {
    func getBreweriesBy(city: String, completion: @escaping (Result<[Brewery], ServiceError>) -> Void)
    func getBreweryDetailsBy(id: String, completion: @escaping (Result<Brewery, ServiceError>) -> Void)
    func getTopTenBreweries(completion: @escaping (Result<BreweriesTopTen, ServiceError>) -> Void)
    func postRating(email: String, breweryId: String, evaluationGrade: Double, completion: @escaping (Result<[String: Any], ServiceError>) -> Void)
    func getEvaluationByEmail(email: String, completion: @escaping (Result<Breweries, ServiceError>) -> Void)
    
    func uploadImage(data: Data, boundary: String, breweryId: String, completion: @escaping (Result<[String:Any], ServiceError>) -> Void)
    
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void)
}

class BreweryRepository: BreweryRepositoryProtocol {
    private let service: ServiceProtocol
    
    init(service: ServiceProtocol) {
        self.service = service
    }
    
    func getBreweriesBy(city: String, completion: @escaping (Result<[Brewery], ServiceError>) -> Void) {
        service.fetchBreweriesBy(city: city) { breweries in
            completion(breweries)
        }
    }
    
    func getBreweryDetailsBy(id: String, completion: @escaping (Result<Brewery, ServiceError>) -> Void) {
        service.fetchBreweryDetailsBy(id: id) { breweryDetails in
            completion(breweryDetails)
        }
    }
    
    func getTopTenBreweries(completion: @escaping (Result<BreweriesTopTen, ServiceError>) -> Void) {
        service.fetchTopTenBreweries() { breweries in
            completion(breweries)
        }
    }
    
    func postRating(email: String, breweryId: String, evaluationGrade: Double, completion: @escaping (Result<[String: Any], ServiceError>) -> Void) {
        service.postRating(email: email, breweryId: breweryId, evaluationGrade: evaluationGrade) { result in
            completion(result)
        }
    }
    
    func getEvaluationByEmail(email: String, completion: @escaping (Result<Breweries, ServiceError>) -> Void) {
        service.fetchEvaluationByEmail(email: email) { result in
            completion(result)
        }
    }
    
    func uploadImage(data: Data, boundary: String, breweryId: String, completion: @escaping (Result<[String:Any], ServiceError>) -> Void){
        service.uploadImage(data: data, boundary: boundary, breweryId: breweryId, completion: { result in
            completion(result)
        })
    }
    
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void) {
        service.fetchBreweryImages(breweryId: breweryId) { response in
            completion(response)
        }
    }
}
