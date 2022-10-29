import Foundation

enum DataManagerError: Error {
    case cantFetchData
    case dataIsEmpty
}

protocol DataManagerProtocol: AnyObject {
    func fetchData() -> Result<CompanyModel, DataManagerError>
}

// Класс для работы с данными
class DataManager {

    private let network: NetworkManagerProtocol
    private let coreData: CoreDataManagerProtocol
    private let parseManager: ParseManagerProtocol

    init(
        network: NetworkManagerProtocol,
        coreData: CoreDataManagerProtocol,
        parseManager: ParseManagerProtocol
    ) {
        self.network = network
        self.coreData = coreData
        self.parseManager = parseManager
    }
}

// MARK: - Data Fetching
extension DataManager: DataManagerProtocol {

    func fetchData() -> Result<CompanyModel, DataManagerError> {

        //Запрос в сеть
        let networkFetch = fetchFromNetwork()

        switch networkFetch {
        case .success(let data):
            return .success(data)
        case .failure(_):
            //Если запрос в сеть зафейлен, ищем в кэше
            let coreDataFetch = fetchFromCoreData()

            switch coreDataFetch {
            case .success(let model):
                return .success(model)
            case .failure(_):
                return .failure(.cantFetchData)
            }
        }
    }

    // Запрос данных из сети
    private func fetchFromNetwork() -> Result<CompanyModel, URLError> {
        let result = network.fetchToEndpoint(endpoint: .emploees)

        switch result {
        case .success(let data):
            guard let models = parse(type: CompanyModel.self, data: data) else {
                return .failure(URLError(.cannotParseResponse))
            }
            DispatchQueue.global().async { [weak self] in
                //кэшируем данные из сети
                self?.cacheData(data)
            }
            return .success(models)
        case .failure(let error):
            return .failure(error)
        }
    }

    //Запрос данных из кэша
    private func fetchFromCoreData() -> Result<CompanyModel, DataManagerError> {
        let cache = coreData.read(CacheModel.self)
        guard let cache = cache,
              let timestamp = cache.timestamp
        else { return .failure(.cantFetchData)}

        #warning("Поменять время на 3600 (1 час) после дебага")
        //Проверям на протухшесть данных
        if Date().timeIntervalSince(timestamp) > 20.0 {
            clearCache()
            return .failure(.cantFetchData)
        }

        guard let data = cache.data,
              let model = parse(type: CompanyModel.self, data: data)
        else { return .failure(.cantFetchData) }

        return .success(model)
    }

    //Парсинг полученных данных
    private func parse<ModelType: Decodable>(type: ModelType.Type, data: Data) -> ModelType? {
        parseManager.parse(type: type, data: data)
    }
}

// MARK: - Data Saving and Deleting
extension DataManager {

    //Кэширование данных
    private func cacheData(_ data: Data) {

        let timestamp = Date()

        coreData.create { context in
            let cache = CacheModel(context: context)
            cache.timestamp = timestamp
            cache.data = data
        } completion: { _ in }
    }

    //Очистка кэша(когда он протухнет)
    private func clearCache() {
        coreData.removeAll(CacheModel.self) { _ in }
    }
}
