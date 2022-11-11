import Foundation

typealias Breweries = [Brewery]

class Brewery: FavoriteBrewery {
    var street: String? = ""
    var city: String
    var state: String
    var postalCode: String
    var country: String
    var longitude: Double? = nil
    var latitude: Double? = nil
    var websiteURL: String? = ""
    var sizeEvaluations: Int
    var photos: [String?]?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.street = try container.decode(String?.self, forKey: .street)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.postalCode = try container.decode(String.self, forKey: .postalCode)
        self.country = try container.decode(String.self, forKey: .country)
        self.longitude = try container.decode(Double?.self, forKey: .longitude)
        self.latitude = try container.decode(Double?.self, forKey: .latitude)
        self.websiteURL = try container.decode(String?.self, forKey: .websiteURL)
        self.sizeEvaluations = try container.decode(Int.self, forKey: .sizeEvaluations)
        self.photos = try container.decode([String?]?.self, forKey: .photos)
        
        try super.init(from: decoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case street
        case city
        case state
        case postalCode = "postal_code"
        case country
        case longitude
        case latitude
        case websiteURL = "website_url"
        case sizeEvaluations = "size_evaluations"
        case photos
    }
}

