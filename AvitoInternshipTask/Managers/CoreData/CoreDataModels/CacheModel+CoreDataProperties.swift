import Foundation
import CoreData


extension CacheModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CacheModel> {
        return NSFetchRequest<CacheModel>(entityName: "CacheModel")
    }

    @NSManaged public var data: Data?
    @NSManaged public var timestamp: Date?

}

extension CacheModel : Identifiable {

}
