import Foundation

struct Constants {
    static let baseUrl = "https://bootcamp-mobile-01.eastus.cloudapp.azure.com/breweries"
    static let cityBaseUrl = "?by_city="
    static let topTen = "/breweries/topTen"
    static let evaluationBaseUrl = "/myEvaluations/"
    static let uploadPhoto = "/photos/upload"
    static let breweryPhotos = "/photos"
}

protocol ServiceProtocol {
    func fetchBreweriesBy(city: String, completion: @escaping (Result<[Brewery], ServiceError>) -> Void)
    func fetchBreweryDetailsBy(id: String, completion: @escaping (Result<Brewery, ServiceError>) -> Void)
    func fetchTopTenBreweries(completion: @escaping (Result<BreweriesTopTen, ServiceError>) -> Void)
    func postRating(email: String, breweryId: String, evaluationGrade: Double, completion: @escaping (Result<[String: Any], ServiceError>) -> Void)
    func readTopTenBreweriesFile() -> BreweriesTopTen
    func fetchEvaluationByEmail(email: String, completion: @escaping (Result<Breweries, ServiceError>) -> Void)
        
    func uploadImage(data: Data, boundary: String, breweryId: String, completion: @escaping (Result<[String:Any], ServiceError>) -> Void)
    
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void) 
}

class Service: ServiceProtocol {
    func fetchBreweriesBy(city: String, completion: @escaping (Result<[Brewery], ServiceError>) -> Void) {
        
        let urlBreweriesByCityFromStates = "\(Constants.baseUrl)?by_city=\(city)"
        
        guard let url = URL(string: urlBreweriesByCityFromStates) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let breweries = try decoder.decode([Brewery].self, from: data)
                completion(.success(breweries))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        task.resume()
    }
    
    func fetchBreweryDetailsBy(id: String, completion: @escaping (Result<Brewery, ServiceError>) -> Void) {
        
        let urlBreweryDetailsById = "\(Constants.baseUrl)/\(id)"
        
        guard let url = URL(string: urlBreweryDetailsById) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let breweryDetails = try decoder.decode(Brewery.self, from: data)
                completion(.success(breweryDetails))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        task.resume()
    }
    
    func fetchTopTenBreweries(completion: @escaping (Result<BreweriesTopTen, ServiceError>) -> Void) {
        
        let urlBreweryTopTen = "\(Constants.baseUrl)\(Constants.topTen)"
        
        guard let url = URL(string: urlBreweryTopTen) else {
            
            completion(.failure(.invalidUrl))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                
                let breweriesTopTen = self.readTopTenBreweriesFile()
                completion(.success(breweriesTopTen))
                return
            }
            
            guard let data = data else {
                
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let breweries = try decoder.decode(BreweriesTopTen.self, from: data)
                completion(.success(breweries))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        task.resume()
    }
    
    func postRating(email: String, breweryId: String, evaluationGrade: Double, completion: @escaping (Result<[String: Any], ServiceError>) -> Void) {
        
        let parameters = [
            "email": email,
            "brewery_id": breweryId,
            "evaluation_grade": evaluationGrade
        ] as [String : Any]
        
        guard let url = URL(string: "\(Constants.baseUrl)") else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            
        } catch {
            completion(.failure(.invalidResponse))
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            guard error == nil else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode != 400 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(json))
                
            } catch {
                completion(.failure(.invalidResponse))
            }
        })
        task.resume()
    }
    
    func readTopTenBreweriesFile() -> BreweriesTopTen {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: "TopTenBreweries", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let breweries = try? decoder.decode(BreweriesTopTen.self, from: data)
        else {
            fatalError("Failed getting file")
        }
        return breweries
    }
    
    func fetchEvaluationByEmail(email: String, completion: @escaping (Result<Breweries, ServiceError>) -> Void) {
        
        let urlBreweryEvaluationByEmail = "\(Constants.baseUrl)\(Constants.evaluationBaseUrl)\(email)"
        
        guard let url = URL(string: urlBreweryEvaluationByEmail) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let breweries = try decoder.decode(Breweries.self, from: data)
                completion(.success(breweries))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        task.resume()
    }
    
    func uploadImage(data: Data, boundary: String, breweryId: String, completion: @escaping (Result<[String:Any], ServiceError>) -> Void) {
        
        let stringURL = "\(Constants.baseUrl)\(Constants.uploadPhoto)?brewery_id=\(breweryId)"
        let url = URL(string: stringURL)
        let session = URLSession.shared
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    completion(.success(json))
                }
            }
        }).resume()
    }
    
    func fetchBreweryImages(breweryId: String, completion: @escaping (Result<[UploadModel], ServiceError>) -> Void) {
        
        let urlString = "\(Constants.baseUrl)\(Constants.breweryPhotos)/\(breweryId)"
        
        guard let url = URL(string: urlString) else {
            
            completion(.failure(.invalidUrl))
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else {
                
                completion(.failure(.invalidData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let images = try decoder.decode([UploadModel].self, from: data)
                completion(.success(images))
                
            } catch {
                completion(.failure(.unableToParseJson))
            }
        }
        task.resume()
    }
}
