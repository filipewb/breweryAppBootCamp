import Foundation

struct UploadModel: Decodable {

    let id: String
    let breweryId: String
    let url: String
  
    enum CodingKeys: String, CodingKey {
        case id
        case breweryId = "brewery_id"
        case url
    }
}
