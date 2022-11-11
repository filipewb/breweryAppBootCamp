import Foundation

typealias BreweriesTopTen = [BreweryTopTen]

struct BreweryTopTen: Codable {
    let id: String
    let name: String
    let breweryType: String
    let average: Double
    let photos: [String?]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case breweryType = "brewery_type"
        case average
        case photos
    }
}
