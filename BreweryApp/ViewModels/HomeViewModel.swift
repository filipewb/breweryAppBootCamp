import Foundation
import Combine

protocol HomeViewModelDelegate: AnyObject {
    func reloadView()
}

enum BreweryModelState {
    case initial
    case loading
    case success (_ topTenbreweries: BreweryTopTenModel)
    case failure
}

protocol HomeViewModelProtocol {
    func getTextFormattedFromSearchBar(_ textFromSearchBar: String) -> String
    func getStateNameBy(_ stateAbbreviation: String) -> String
    func getBreweriesBy(city: String, completion: @escaping () -> Void)
    func getBreweriesByCityFrom(_ stateName: String, _ breweries: [Brewery]) -> [Brewery]
    func getCountBreweries() -> Int
    func getBrewery(_ indexPath: IndexPath) -> Brewery
    func returnToTopTen(collectionView: () -> Void)
    func toggleViewOnScreen(emptySearch: (_ genericError: GenericSearchError) -> Void,
                            notFoundSearch: (_ genericError: GenericSearchError) -> Void,
                            tableView: () -> Void,
                            collectionView: () -> Void)
    func getTopTenBreweries()
}

class HomeViewModel: HomeViewModelProtocol {
    
    let breweryRepository: BreweryRepositoryProtocol
    
    var breweriesByCity: Breweries = []
    
    var apiError: ServiceError? = nil
    
    var city: String? = nil
    
    var filterLabel: String = Texts.name
    
    var stateName = ""
    
    weak var delegate: HomeViewModelDelegate?
    
    @Published private (set) var state: BreweryModelState = .initial
    
    init(breweryRepository: BreweryRepositoryProtocol) {
        self.breweryRepository = breweryRepository
    }
    
    func getTextFormattedFromSearchBar(_ textFromSearchBar: String) -> String {
        let textFromSearchBar = textFromSearchBar.uppercased()
        
        if textFromSearchBar == "" {
            self.apiError = ServiceError.emptySearch
            self.delegate?.reloadView()
            return ""
        }
        
        if textFromSearchBar.contains(", ") {
            let stateAbbreviation = textFromSearchBar.components(separatedBy: ", ")[1]
            
            if stateAbbreviation.count == 2 {
                stateName = getStateNameBy(stateAbbreviation)
                
                if stateName != "" {
                    let city = textFromSearchBar.components(separatedBy: ", ")[0]
                    
                    self.city = city.replacingOccurrences(of: " ", with: "%20")
                    
                    return city.replacingOccurrences(of: " ", with: "%20")
                }
            }
        } else {
            stateName = ""
            self.city = textFromSearchBar.replacingOccurrences(of: " ", with: "%20")
            return textFromSearchBar.replacingOccurrences(of: " ", with: "%20")
        }
        return ""
    }
    
    func getStateNameBy(_ stateAbbreviation: String) -> String {
        var stateFullName = ""
        
        switch stateAbbreviation {
            
        case "AL":
            stateFullName = "Alabama"
        case "AK":
            stateFullName = "Alaska"
        case "AZ":
            stateFullName = "Arizona"
        case "AR":
            stateFullName = "Arkansas"
        case "CA":
            stateFullName = "California"
        case "CO":
            stateFullName = "Colorado"
        case "CT":
            stateFullName = "Connecticut"
        case "DE":
            stateFullName = "Delaware"
        case "DC":
            stateFullName = "District of Columbia"
        case "FL":
            stateFullName = "Florida"
        case "GA":
            stateFullName = "Georgia"
        case "HI":
            stateFullName = "Hawaii"
        case "ID":
            stateFullName = "Idaho"
        case "IL":
            stateFullName = "Illinois"
        case "IN":
            stateFullName = "Indiana"
        case "IA":
            stateFullName = "Iowa"
        case "KS":
            stateFullName = "Kansas"
        case "KY":
            stateFullName = "Kentucky"
        case "LA":
            stateFullName = "Louisiana"
        case "ME":
            stateFullName = "Maine"
        case "MD":
            stateFullName = "Maryland"
        case "MA":
            stateFullName = "Massachusetts"
        case "MI":
            stateFullName = "Michigan"
        case "MN":
            stateFullName = "Minnesota"
        case "MS":
            stateFullName = "Mississippi"
        case "MO":
            stateFullName = "Missouri"
        case "MT":
            stateFullName = "Montana"
        case "NE":
            stateFullName = "Nebraska"
        case "NV":
            stateFullName = "Nevada"
        case "NH":
            stateFullName = "New Hampshire"
        case "NJ":
            stateFullName = "New Jersey"
        case "NM":
            stateFullName = "New Mexico"
        case "NY":
            stateFullName = "New York"
        case "NC":
            stateFullName = "North Carolina"
        case "ND":
            stateFullName = "North Dakota"
        case "OH":
            stateFullName = "Ohio"
        case "OK":
            stateFullName = "Oklahoma"
        case "OR":
            stateFullName = "Oregon"
        case "PA":
            stateFullName = "Pennsylvania"
        case "RI":
            stateFullName = "Rhode Island"
        case "SC":
            stateFullName = "South Carolina"
        case "SD":
            stateFullName = "South Dakota"
        case "TN":
            stateFullName = "Tennessee"
        case "TX":
            stateFullName = "Texas"
        case "UT":
            stateFullName = "Utah"
        case "VT":
            stateFullName = "Vermont"
        case "VA":
            stateFullName = "Virginia"
        case "WA":
            stateFullName = "Washington"
        case "WV":
            stateFullName = "West Virginia"
        case "WI":
            stateFullName = "Wisconsin"
        case "WY":
            stateFullName = "Wyoming"
        default:
            stateFullName = ""
        }
        
        if stateFullName == "District of Columbia" {
            return "District "+"of".lowercased()+" Columbia"
        } else {
            return stateFullName.capitalized
        }
    }
    
    func getBreweriesBy(city: String, completion: @escaping () -> Void) {
        if city == "" {
            return
        }
        
        breweryRepository.getBreweriesBy(city: city) { [weak self] result in
            switch result {
            case .success(let breweries):
                if self?.stateName == "" {
                    self?.breweriesByCity = breweries
                } else {
                    self?.breweriesByCity = self?.getBreweriesByCityFrom(self?.stateName ?? .init(), breweries) ?? .init()
                }
                completion()
            case .failure(_):
                self?.apiError = ServiceError.failedToGetCity
                self?.delegate?.reloadView()
            }
        }
    }
    
    func getBreweriesByCityFrom(_ stateName: String, _ breweries: [Brewery]) -> [Brewery] {
        breweries.filter { brewery in
            brewery.state == stateName
        }
    }
    
    func getCountBreweries() -> Int {
        return breweriesByCity.count
    }
    
    func getBrewery(_ indexPath: IndexPath) -> Brewery {
        breweriesByCity[indexPath.row]
    }
    
    func returnToTopTen(collectionView: () -> Void) {
        collectionView()
    }
    
    func toggleViewOnScreen(emptySearch: (_ genericError: GenericSearchError) -> Void,
                            notFoundSearch: (_ genericError: GenericSearchError) -> Void,
                            tableView: () -> Void,
                            collectionView: () -> Void) {
        
        if breweriesByCity.count > 0 {
            tableView()
        }
        
        if let apiError = apiError {
            if apiError == ServiceError.failedToGetCity {
                notFoundSearch(GenericSearchError())
            } else {
                emptySearch(GenericSearchError(error: "Nenhum termo digitado"))
            }
        } else {
            collectionView()
        }
    }
    
    func getTopTenBreweries() {
        breweryRepository.getTopTenBreweries { [weak self] result in
            switch result {
            case .success(let breweries):
                self?.state = .success(BreweryTopTenModel(breweries: breweries))
                
            case .failure(_): break
            }
        }
    }
}
