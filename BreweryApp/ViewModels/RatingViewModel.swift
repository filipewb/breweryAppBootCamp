import Foundation

protocol RatingViewControllerDelegate: AnyObject {
    func showValidEmail()
    func showInvalidEmail()
    func showDefaultEmail()
    func reloadTableView()
    func showDefaultMessage()
}

protocol RatingViewModelProtocol {
    func isValidEmail(email: String) -> Bool
}

class RatingViewModel: RatingViewModelProtocol {
    
    var favoriteBreweries: [Brewery] = []
    
    var email: String = ""
    
    let breweryRepository: BreweryRepositoryProtocol
    
    init(breweryRepository: BreweryRepositoryProtocol) {
        self.breweryRepository = breweryRepository
    }
    
    weak var delegate: RatingViewControllerDelegate?
    
    func isValidEmail(email: String) -> Bool {
        if email.isEmail {
            self.email = email
            return true
        } else {
            self.email = email
            return false
        }
    }
    
    func setStateEmail(isEmail: Bool) {
        if isEmail {
            delegate?.showValidEmail()
        }
        
        if isEmail == false && !email.isEmail {
            delegate?.showInvalidEmail()
        }
        
        if isEmail == false && self.email == "" {
            delegate?.showDefaultEmail()
        }
    }
    
    func getEmail() -> String {
        return email
    }
    
    func getEvaluationByEmail(_ email: String) {
        breweryRepository.getEvaluationByEmail(email: email) { [weak self] evaluations in
            switch evaluations {
            case .success(let breweries):
                self?.favoriteBreweries = breweries
                
                if self?.favoriteBreweries.count != 0 {
                    self?.delegate?.reloadTableView()
                }
                else {
                    self?.delegate?.showDefaultMessage()
                }
                
            case .failure(_): break
            }
        }
    }
    
    func getResultLabelText() -> String {
        let number = getBreweryCount()
        
        if number == 1 {
            return "\(number) \(Texts.resultSearch)"
        }
        return "\(number) \(Texts.resultsSearch)"
        
    }
    
    func getBreweryCount() -> Int {
        return favoriteBreweries.count
    }
    
    func getBreweryNameFirstLetter(forIndex index: IndexPath) -> String {
        return String(favoriteBreweries[index.row].name.prefix(1))
    }
    
    func getFullNameBrewery(index: IndexPath) -> String {
        return favoriteBreweries[index.row].name
    }
    
    func getAverage(index: IndexPath) -> String {
        return String(favoriteBreweries[index.row].average )
    }
    
    func formatAverage(index: IndexPath) -> String {
        return String(favoriteBreweries[index.row].average ).replacingOccurrences(of: ".", with: ",")
    }
}
