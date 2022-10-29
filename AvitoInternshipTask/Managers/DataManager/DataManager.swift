import Foundation

enum DataManagerError: Error {

    case cantFetchData
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
            return .success(models)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func fetchFromCoreData() -> Result<CompanyModel, Error> {
        return .failure(Error.self as! Error)
    }

    private func parse<ModelType: Decodable>(type: ModelType.Type, data: Data) -> ModelType? {
        parseManager.parse(type: type, data: data)
    }
}
