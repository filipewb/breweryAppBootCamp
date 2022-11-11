import Foundation

class FavoriteBrewery: Decodable {
    var id: String
    var name: String
    var breweryType: String
    var average: Double
    
    init(id: String, name: String, breweryType: String, average: Double) {
        self.id = id
        self.name = name
        self.breweryType = breweryType
        self.average = average
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case breweryType = "brewery_type"
        case average
    }
}
