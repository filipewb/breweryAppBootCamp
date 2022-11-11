import Foundation
import UIKit
import CoreData

typealias FavoriteBreweriesManagedObject = [NSManagedObject]

protocol FavoriteBreweryCoreDataServiceProtocol {
    func saveFavoriteBrewery(_ brewery: FavoriteBrewery, completion: @escaping (Error) -> Void)
    func getFavoriteBreweries(completion: @escaping (Result<FavoriteBreweriesManagedObject, ServiceError>) -> Void)
    func deleteFavoriteBrewery(atIndex: IndexPath, forData: FavoriteBreweriesManagedObject, completion: @escaping (Error) -> Void)
}

class FavoriteBreweryCoreDataService: FavoriteBreweryCoreDataServiceProtocol {
    
    func saveFavoriteBrewery(_ brewery: FavoriteBrewery, completion: @escaping (Error) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "FavoriteBreweries", in: managedContext)!
        
        let favoriteBreweries = NSManagedObject(entity: entity, insertInto: managedContext)
        
        favoriteBreweries.setValue(brewery.id, forKeyPath: "id")
        favoriteBreweries.setValue(brewery.name, forKeyPath: "name")
        favoriteBreweries.setValue(brewery.breweryType, forKeyPath: "breweryType")
        favoriteBreweries.setValue(brewery.average, forKeyPath: "average")
        
        do {
            try managedContext.save()
        } catch {
            completion(ServiceError.badRequest)
        }
    }
    
    func getFavoriteBreweries(completion: @escaping (Result<FavoriteBreweriesManagedObject, ServiceError>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteBreweries")
        
        do {
            let breweries = try managedContext.fetch(fetchRequest)
            completion(.success(breweries))
        } catch {
            completion(.failure(ServiceError.badRequest))
        }
    }
    
    func deleteFavoriteBrewery(atIndex: IndexPath, forData: FavoriteBreweriesManagedObject, completion: @escaping (Error) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(forData[atIndex.row] as NSManagedObject)
        
        do {
            try managedContext.save()
        } catch {
            completion(ServiceError.badRequest)
        }
    }
}
