import Foundation
import Combine

enum BreweryDetailsViewModelState {
    case initial
    case loading
    case retrieveDetails (_ brewery: BreweryDetailsModel)
    case retrievePhotos (_ photos: BreweryDetailsModel)
    case failure
}

protocol BreweryDetailsViewModelProtocol {
    func getBreweryDetailsBy(id: String)
    
    func uploadImage(data: Data, boundary: String, breweryId: String, completion: @escaping (Result<[String:Any], ServiceError>) -> Void)
    
    func fetchBreweryImages(breweryId: String)
}

class BreweryDetailsViewModel: BreweryDetailsViewModelProtocol {
    
    var favoriteBreweriesManagedObject: FavoriteBreweriesManagedObject = []
    
    let breweryRepository: BreweryRepositoryProtocol
    
    let favoriteBreweryRepository: FavoriteBreweryRepositoryProtocol
    
    @Published private (set) var state: BreweryDetailsViewModelState = .initial
    
    init(breweryRepository: BreweryRepositoryProtocol, favoriteBreweryRepository: FavoriteBreweryRepositoryProtocol) {
        self.breweryRepository = breweryRepository
        self.favoriteBreweryRepository = favoriteBreweryRepository
    }
    
    func getBreweryDetailsBy(id: String) {
        state = .loading
        breweryRepository.getBreweryDetailsBy(id: id) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let breweryDetails):
                if let email = RatingModalViewModel.email {
                    self.breweryRepository.getEvaluationByEmail(email: email) { [weak self] evaluations in
                        
                        switch evaluations {
                        case .success(let breweries):
                            let evaluation = breweries.contains { brewery in
                                breweryDetails.id == brewery.id
                            }
                            self?.state = .retrieveDetails(BreweryDetailsModel(breweryDetails, isEvaluation: evaluation))
                            
                        case .failure(_): break
                        }
                    }
                } else {
                    self.state = .retrieveDetails(BreweryDetailsModel(breweryDetails, isEvaluation: false))
                }
                
            case .failure(_):
                self.state = .failure
            }
        }
    }
    
    func uploadImage(data: Data, boundary: String, breweryId: String, completion: @escaping (Result<[String:Any], ServiceError>) -> Void) {
        breweryRepository.uploadImage(data: data, boundary: boundary, breweryId: breweryId) { result in
            completion(result)
        }
    }
    
    func fetchBreweryImages(breweryId: String) {
        state = .initial
        breweryRepository.fetchBreweryImages(breweryId: breweryId) { [weak self] response in
            switch response {
                
            case .success(let breweryPhotos):
                self?.getBreweryDetailsBy(id: breweryId)
                let photos = breweryPhotos.map { $0.url }
                self?.state = .retrievePhotos(BreweryDetailsModel(isEvaluation: false, photosList: photos))
                
            case .failure(_):
                self?.state = .failure
            }
        }
    }
    
    func getFavoriteBreweries() {
        favoriteBreweryRepository.getFavoriteBreweries { [weak self] result in
            switch result {
                
            case .success(let favoriteBreweries):
                self?.favoriteBreweriesManagedObject = favoriteBreweries
                
            case .failure(_): break
            }
        }
    }
    
    func isFavorited(brewery: Brewery) -> Bool {
        let favoriteBreweriesManagedObject = getFavoriteBreweriesManagedObject()
        
        if favoriteBreweriesManagedObject.contains(where: {$0.value(forKey: "id") as? String == brewery.id}) {
            return true
        }
        return false
    }
    
    func getFavoriteBreweriesManagedObject() -> FavoriteBreweriesManagedObject {
        return favoriteBreweriesManagedObject
    }
    
    func saveOrDeleteFavoriteAtCoreData(viewModel: BreweryDetailsViewModel, brewery: Brewery, isFavorited: Bool, isSelected: Bool) {
        if isSelected {
            if isFavorited == false {
                let favoriteBrewery = viewModel.getFavoriteBrewery(brewery: brewery)
                
                viewModel.saveFavoriteBrewery(favoriteBrewery)
            }
        } else {
            if isFavorited == true {
                let favoriteBreweriesManagedObject = viewModel.getFavoriteBreweriesManagedObject()
                
                let index = viewModel.getIndexPathFromCoreData(brewery: brewery)
                
                viewModel.deleteFavoriteBrewery(atIndex: index, forData: favoriteBreweriesManagedObject)
            }
        }
    }
    
    func getFavoriteBrewery(brewery: Brewery) -> FavoriteBrewery {
        let favoriteBrewery = FavoriteBrewery(
            id: brewery.id,
            name: brewery.name,
            breweryType: brewery.breweryType,
            average: brewery.average
        )
        return favoriteBrewery
    }
    
    func saveFavoriteBrewery(_ brewery: FavoriteBrewery) {
        favoriteBreweryRepository.saveFavoriteBrewery(brewery) { error in
        }
    }
    
    func getIndexPathFromCoreData(brewery: Brewery) -> IndexPath {
        let favoriteBreweriesManagedObject = getFavoriteBreweriesManagedObject()
        
        var index: IndexPath = [0,0]
        
        for favorite in favoriteBreweriesManagedObject {
            if favorite.value(forKey: "id") as? String == brewery.id {
                return index
            }
            index.row = index.row+1
        }
        return index
    }
        
    func deleteFavoriteBrewery(atIndex index: IndexPath, forData data: FavoriteBreweriesManagedObject) {
        favoriteBreweryRepository.deleteFavoriteBrewery(atIndex: index, forData: data) { error in
        }
    }
}
