import Foundation

enum DataManagerError: Error {

    case cantFetchData
    case dataIsEmpty
}

protocol DataManagerProtocol {

    func fetchData() -> Result<CompanyModel, DataManagerError>
}

class DataManager {

    private let network: NetworkManager
    private let coreData: CoreDataManager
    private let parseManager: ParseManager

    init(
        network: NetworkManager,
        coreData: CoreDataManager,
        parseManager: ParseManager
    ) {
        self.network = network
        self.coreData = coreData
        self.parseManager = parseManager
    }
}

// MARK: - Data Fetching
extension DataManager: DataManagerProtocol {

    func fetchData() -> Result<CompanyModel, DataManagerError> {

        let networkFetch = fetchFromNetwork()

        switch networkFetch {
        case .success(let data):
            return .success(data)
        case .failure(_):
            let coreDataFetch = fetchFromCoreData()

            switch coreDataFetch {
            case .success(let model):
                return .success(model)
            case .failure(_):
                return .failure(.cantFetchData)
            }
        }
    }

    private func fetchFromNetwork() -> Result<CompanyModel, URLError> {
        let result = network.fetchToEndpoint(endpoint: "/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c")

        switch result {
        case .success(let data):
            guard let models = parse(type: CompanyModel.self, data: data) else {
                return .failure(URLError(.cannotParseResponse))
            }
            DispatchQueue.global().async { [weak self] in
                self?.cacheData(data)
            }
            return .success(models)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func fetchFromCoreData() -> Result<CompanyModel, DataManagerError> {
        let cache = coreData.read(CacheModel.self)
        guard let cache = cache,
              let timestamp = cache.timestamp
        else { return .failure(.cantFetchData)}

        if Date().timeIntervalSince(timestamp) > 20.0 {
            clearCache()
            return .failure(.cantFetchData)
        }

        guard let data = cache.data,
              let model = parse(type: CompanyModel.self, data: data)
        else { return .failure(.cantFetchData) }

        return .success(model)
    }

    private func parse<ModelType: Decodable>(type: ModelType.Type, data: Data) -> ModelType? {
        parseManager.parse(type: type, data: data)
    }
}

// MARK: - Data Saving and Deleting
extension DataManager {

    private func cacheData(_ data: Data) {

        let timestamp = Date()

        coreData.create { context in
            let cache = CacheModel(context: context)
            cache.timestamp = timestamp
            cache.data = data
        } completion: { _ in }
    }

    private func clearCache() {
        coreData.removeAll(CacheModel.self) { _ in }
    }
}
