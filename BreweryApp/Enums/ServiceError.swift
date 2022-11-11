enum ServiceError: String, Error {
    case invalidUrl
    case invalidResponse
    case invalidData
    case unableToParseJson
    case emptySearch
    case failedToGetCity
    case badRequest
}
