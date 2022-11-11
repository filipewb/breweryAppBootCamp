import Foundation

struct BreweryDetailsModel {
    var brewery: Brewery? = nil
    var photosList: [String] = []
    var isEvaluation: Bool
    
    init(_ brewery: Brewery? = nil, isEvaluation: Bool, photosList: [String] = []) {
        self.brewery = brewery
        self.photosList = photosList
        self.isEvaluation = isEvaluation
    }
    
    func getIsEvaluation() -> Bool {
        return isEvaluation
    }
    
    func getBrewery() -> Brewery? {
        guard let brewery = brewery else {
            return nil
        }
        return brewery
    }
    
    func getPhotosListCount() -> Int {
        return photosList.count
    }
    
    func getPhotosList() -> [String] {
        return photosList
    }
    
    func getUrlImage(url: String) -> URL {
        guard let urlImagem = URL(string: url) else { return URL(fileURLWithPath: "") }
        return urlImagem
    }
    
    func getFirstLetterNameBrewery() -> String {
        return String(brewery?.name.prefix(1) ?? "")
    }
    
    func getFullNameBrewery() -> String {
        return brewery?.name ?? ""
    }
    
    func formatAverage() -> String {
        return String(brewery?.average ?? 0.0).replacingOccurrences(of: ".", with: ",")
    }
    
    func getAverage() -> Double {
        return brewery?.average ?? 0.0
    }
    
    func getBreweryType() -> String {
        return brewery?.breweryType.capitalized ?? ""
    }
    
    func getSizeEvaluations() -> String {
        return SizeEvaluations.stringSize(for: brewery?.sizeEvaluations ?? 0)
    }
    
    func getBreweryWebSite() -> String {
        return brewery?.websiteURL ?? Texts.noWebSiteAvailable
    }
    
    func getBreweryAddress() -> String {
        return ("\(brewery?.street ?? Texts.noStreetName), \(brewery?.city ?? ""), \(convertStateToAbbreviation(brewery?.state ?? "")) \(brewery?.postalCode ?? ""), \(brewery?.country ?? "")")
    }
    
    func isLocationAvailable() -> Bool {
        return brewery?.latitude ?? nil != nil && brewery?.longitude ?? nil != nil
    }
    
    func getLatitude() -> Double? {
        guard let latitude = brewery?.latitude else { return nil }
        
        return latitude
    }
    
    func getLongitude() -> Double? {
        guard let longitude = brewery?.longitude else { return nil }
        
        return longitude
    }
    
    func getCountPhotos() -> Int {
        return brewery?.photos?.count ?? 0
    }
    
    func convertStateToAbbreviation(_ state: String) -> String {
        var stateAbbreviation = ""
        
        switch state {
            
        case "Alabama":
            stateAbbreviation = "AL"
        case "Alaska":
            stateAbbreviation = "AK"
        case "Arizona":
            stateAbbreviation = "AZ"
        case "Arkansas":
            stateAbbreviation = "AR"
        case "California":
            stateAbbreviation = "CA"
        case "Colorado":
            stateAbbreviation = "CO"
        case "Connecticut":
            stateAbbreviation = "CT"
        case "Delaware":
            stateAbbreviation = "DE"
        case "District of Columbia":
            stateAbbreviation = "DC"
        case "Florida":
            stateAbbreviation = "FL"
        case "Georgia":
            stateAbbreviation = "GA"
        case "Hawaii":
            stateAbbreviation = "HI"
        case "Idaho":
            stateAbbreviation = "ID"
        case "Illinois":
            stateAbbreviation = "IL"
        case "Indiana":
            stateAbbreviation = "IN"
        case "Iowa":
            stateAbbreviation = "IA"
        case "Kansas":
            stateAbbreviation = "KS"
        case "Kentucky":
            stateAbbreviation = "KY"
        case "Louisiana":
            stateAbbreviation = "LA"
        case "Maine":
            stateAbbreviation = "ME"
        case "Maryland":
            stateAbbreviation = "MD"
        case "Massachusetts":
            stateAbbreviation = "MA"
        case "Michigan":
            stateAbbreviation = "MI"
        case "Minnesota":
            stateAbbreviation = "MN"
        case "Mississippi":
            stateAbbreviation = "MS"
        case "Missouri":
            stateAbbreviation = "MO"
        case "Montana":
            stateAbbreviation = "MT"
        case "Nebraska":
            stateAbbreviation = "NE"
        case "Nevada":
            stateAbbreviation = "NV"
        case "New Hampshire":
            stateAbbreviation = "NH"
        case "New Jersey":
            stateAbbreviation = "NJ"
        case "New Mexico":
            stateAbbreviation = "NM"
        case "New York":
            stateAbbreviation = "NY"
        case "North Carolina":
            stateAbbreviation = "NC"
        case "North Dakota":
            stateAbbreviation = "ND"
        case "Ohio":
            stateAbbreviation = "OH"
        case "Oklahoma":
            stateAbbreviation = "OK"
        case "Oregon":
            stateAbbreviation = "OR"
        case "Pennsylvania":
            stateAbbreviation = "PA"
        case "Rhode Island":
            stateAbbreviation = "RI"
        case "South Carolina":
            stateAbbreviation = "SC"
        case "South Dakota":
            stateAbbreviation = "SD"
        case "Tennessee":
            stateAbbreviation = "TN"
        case "Texas":
            stateAbbreviation = "TX"
        case "Utah":
            stateAbbreviation = "UT"
        case "Vermont":
            stateAbbreviation = "VT"
        case "Virginia":
            stateAbbreviation = "VA"
        case "Washington":
            stateAbbreviation = "WA"
        case "West Virginia":
            stateAbbreviation = "WV"
        case "Wisconsin":
            stateAbbreviation = "WI"
        case "Wyoming":
            stateAbbreviation = "WY"
        default:
            stateAbbreviation = ""
        }
        return stateAbbreviation
    }
    
    func generateBoundary() -> String {
        let boundary = UUID().uuidString
        return boundary
    }
}
