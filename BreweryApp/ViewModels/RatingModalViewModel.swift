import Foundation

protocol RatingModalDelegate: AnyObject {
    func showValidEmail()
    func showInvalidEmail()
    func showDefaultEmail()
    func showSuccessCard()
    func showErrorCard()
    func updateScreen()
}

protocol RatingModalViewModelProtocol {
    func validateEmail(email: String)
    func saveRating(breweryID: String, evaluationGrade: Double)
}

class RatingModalViewModel: RatingModalViewModelProtocol {
    
    let breweryRepository: BreweryRepositoryProtocol
    
    init(breweryRepository: BreweryRepositoryProtocol) {
        self.breweryRepository = breweryRepository
    }
    
    static var email: String? = nil
    
    weak var delegate: RatingModalDelegate?
    
    func validateEmail(email: String) {        
        if email.isEmail {
            RatingModalViewModel.email = email
            delegate?.showValidEmail()
        }
        
        if !email.isEmail {
            delegate?.showInvalidEmail()
        }
        
        if email == "" {
            delegate?.showDefaultEmail()
        }
    }
    
    func saveRating(breweryID: String, evaluationGrade: Double) {
        guard let email = RatingModalViewModel.email else { return }
        breweryRepository.postRating(email: email, breweryId: breweryID, evaluationGrade: evaluationGrade) { [weak self] result in
            
            switch result {
                
            case .success(_):
                self?.delegate?.showSuccessCard()
                self?.delegate?.updateScreen()
                
            case .failure(_):
                self?.delegate?.showErrorCard()
            }
        }
    }
}
