import Foundation

enum DataManagerError: Error {
    case canNotFetchData
    case dataIsEmpty
}

protocol DataManagerProtocol<ModelType>: AnyObject {
    associatedtype ModelType: Codable
    func fetchData() -> Result<ModelType, DataManagerError>
}

// Класс для работы с данными
class DataManager<ModelType: Codable> {

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

    func fetchData() -> Result<ModelType, DataManagerError> {

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
                return .failure(.canNotFetchData)
            }
        }
    }

    // Запрос данных из сети
    private func fetchFromNetwork() -> Result<ModelType, URLError> {
        let result = network.fetchToEndpoint(endpoint: .emploees)

        switch result {
        case .success(let data):
            guard let models = parse(type: ModelType.self, data: data) else {
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
    private func fetchFromCoreData() -> Result<ModelType, DataManagerError> {
        let cache = coreData.read(CacheModel.self)
        guard let cache = cache,
              let timestamp = cache.timestamp
        else { return .failure(.canNotFetchData)}

        #warning("Поменять время на 3600 (1 час) после дебага")
        //Проверям на протухшесть данных
        if Date().timeIntervalSince(timestamp) > 20.0 {
            clearCache()
            return .failure(.canNotFetchData)
        }

        guard let data = cache.data,
              let model = parse(type: ModelType.self, data: data)
        else { return .failure(.canNotFetchData) }

        return .success(model)
    }

    //Парсинг полученных данных
    private func parse(type: ModelType.Type, data: Data) -> ModelType? {
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
