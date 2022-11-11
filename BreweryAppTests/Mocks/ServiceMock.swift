@testable import BreweryApp
import Foundation

class ServiceMock: ServiceProtocol {
    let decoder = JSONDecoder()
    
    let topTenBreweries = [BreweryTopTen(id: "bay-brewing-company-miami", name: "Bay Brewing Company", breweryType: "planning", average: 3.4, photos: [
        "https://bootcampmobile010ut.blob.core.windows.net/bootcamp-mobile-photos/bay-brewing-company-miamidced8379-d3ee-4891-9498-72a35ac3fa48sala-maria-keil.jpg",
        "https://bootcampmobile010ut.blob.core.windows.net/bootcamp-mobile-photos/bay-brewing-company-miami1ec456b6-61a1-4aba-aca5-657ac022bd051655489032140.jpg"
    ])]
    
    func loadJsonData(file: String) -> Data? {
        if let jsonFilePath = Bundle(for: type(of: self)).path(forResource: file, ofType: "json") {
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            
            if let jsonData = try? Data(contentsOf: jsonFileURL) {
                return jsonData
            }
        }
        return nil
    }
    
    func fetchBreweriesBy(city: String, completion: @escaping (Result<[Brewery], ServiceError>) -> Void) {
        guard
            let data = loadJsonData(file: "BreweriesMock"),
            let response = try? decoder.decode([Brewery].self, from: data)
        else {
            fatalError("Failed getting file")
        }
        completion(.success(response))
    }
    
    func fetchBreweryDetailsBy(id: String, completion: @escaping (Result<Brewery, ServiceError>) -> Void) {
        guard
            let data = loadJsonData(file: "BreweryMock"),
            let response = try? decoder.decode(Brewery.self, from: data)
        else {
            fatalError("Failed getting file")
        }
        completion(.success(response))
    }
    
    func fetchTopTenBreweries(completion: @escaping (Result<BreweriesTopTen, ServiceError>) -> Void) {
        completion(.success(topTenBreweries))
    }
    
    func postRating(email: String, breweryId: String, evaluationGrade: Double, completion: @escaping (Result<[String : Any], ServiceError>) -> Void) { }
    
    func readTopTenBreweriesFile() -> BreweriesTopTen {
        return topTenBreweries
    }
    
    func fetchEvaluationByEmail(email: String, completion: @escaping (Result<Breweries, ServiceError>) -> Void) {
        
        let file = "BreweriesMock"
        
        if email == "" {
            completion(.success([]))
            return
        }
        
        guard
            let data = loadJsonData(file: file),
            let response = try? decoder.decode([Brewery].self, from: data)
        else {
            fatalError("Failed getting file")
        }
        
        if email == "person@person.com" {
            let brewery = [response[0]]
            completion(.success(brewery))
            return
        }
        
        completion(.success(response))
    }
    
    func uploadImage(data: Data, boundary: String, breweryId: String, completion: @escaping (Result<[String : Any], ServiceError>) -> Void) {
        completion(.success(.init()))
    }
    
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void) {  }
}
