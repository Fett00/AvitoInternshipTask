import Foundation

class NetworkManager {

    private let api: URL
    private let session: URLSession
    private let cachePolicy: URLRequest.CachePolicy

    var task: URLSessionDataTask?

    init?(
        api: String,
        cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData
    ) {

        guard let api = URL(string: api) else { return nil }
        self.api = api
        self.cachePolicy = cachePolicy

        let sessionConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: sessionConfiguration)
    }

    private func _fetchToEndpoint(
        endpoint: String,
        completion: @escaping (Result<Data, URLError>) -> Void
    ) {

        let url = api.appendingPathComponent(endpoint)
        let request = URLRequest(url: url, cachePolicy: cachePolicy)
        task = NetworkDataTaskFactory.makeDefaultDataTask(
            session,
            request,
            completion: completion
        )

        task?.resume()
    }

    public func fetchToEndpoint(
        endpoint: String
    ) -> Result<Data, URLError> {

        var result: Result<Data, URLError> = .failure(URLError(.unknown))
        let group = DispatchGroup()

        group.enter()
        _fetchToEndpoint(
            endpoint: endpoint
        ) { res in
            result = res
            group.leave()
        }
        group.wait()
        return result
    }
}

