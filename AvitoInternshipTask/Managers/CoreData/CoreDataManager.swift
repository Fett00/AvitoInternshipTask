import Foundation
import CoreData

protocol CoreDataManagerProtocol {
    func create(createObject: (NSManagedObjectContext)->(), completion: @escaping (Bool) -> Void)
    func read<Entity: NSManagedObject>(_ model: Entity.Type) -> Entity?
    func removeAll<Entity: NSManagedObject>(
        _ model: Entity.Type,
        completion: @escaping (Bool) -> Void
    )
}

class CoreDataManager: CoreDataManagerProtocol {

    private lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "AvitoInternshipTask")
        container.loadPersistentStores(
            completionHandler: { (storeDescription, error) in

            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    private var context: NSManagedObjectContext { persistentContainer.newBackgroundContext() }

    private func saveInCurrentContext (_ context: NSManagedObjectContext, completion: @escaping (Bool) -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completion(true)
            } catch {
                let nserror = error as NSError
                completion(false)
                print("[ERROR]: ", nserror, nserror.userInfo)
                //fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func create(createObject: (NSManagedObjectContext)->(), completion: @escaping (Bool) -> Void) {

        let currentContext = context

        createObject(currentContext)
        saveInCurrentContext(currentContext) { result in
            completion(result)
        }
    }

    func read<Entity: NSManagedObject>(_ model: Entity.Type) -> Entity? {

        let currentContext = context
        do {
            let request = Entity.fetchRequest()
            let result: [Entity] = try currentContext.fetch(request) as! [Entity]
            return result.last
        }
        catch {
            print("[ERROR]: ", error.localizedDescription)
            return nil
        }
    }

    func removeAll<Entity: NSManagedObject>(
        _ model: Entity.Type,
        completion: @escaping (Bool) -> Void
    ) {
        let currentContext = context
        let request = Entity.fetchRequest()
        let batch = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try currentContext.execute(batch)
            completion(true)
        }
        catch {
            completion(false)
        }
    }
}
