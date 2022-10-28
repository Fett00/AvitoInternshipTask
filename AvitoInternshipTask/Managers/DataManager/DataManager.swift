import Foundation

protocol DataManagerProtocol {

    func fetchData() -> [CompanyModel]
}

class DataManager {

    private let network: NetworkManager
    private let coreData: CoreDataManager

    init(network: NetworkManager, coreData: CoreDataManager) {
        self.network = network
        self.coreData = coreData
    }
}

extension DataManager: DataManagerProtocol {

    func fetchData() -> [CompanyModel] {

        return []
    }
}
