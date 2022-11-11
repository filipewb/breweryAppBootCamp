import Foundation
import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        defaultScope = .graph
        register { Service() as ServiceProtocol }
        register { FavoriteBreweryCoreDataService() as FavoriteBreweryCoreDataServiceProtocol }
        register { BreweryRepository(service: resolve()) as BreweryRepositoryProtocol }
        register { FavoriteBreweryRepository(favoriteBreweryCoreDataService: resolve()) as FavoriteBreweryRepositoryProtocol }
        register { BreweryDetailsViewModel(breweryRepository: resolve(), favoriteBreweryRepository: resolve()) }
        register { HomeViewModel(breweryRepository: resolve()) }.implements(HomeViewModelProtocol.self)
        register { RatingModalViewModel(breweryRepository: resolve()) }.implements(RatingModalViewModelProtocol.self)
        register { HomeTableViewCellViewModel(brewery: resolve()) }
        register { FavoritesListViewModel(favoriteBreweryRepository: resolve()) }
        register { FavoritesListTableViewCellViewModel(favoriteBrewery: resolve()) }
        register { RatingViewModel(breweryRepository: resolve()) }.implements(RatingViewModelProtocol.self)
        register { HomeTableViewCellViewModel(brewery: resolve())}
    }
}
