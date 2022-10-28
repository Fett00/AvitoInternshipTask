import Foundation

import Foundation

class NetworkManager {

    let api: URL
    let session: URLSession
    let cachePolicy: URLRequest.CachePolicy

    var task: URLSessionDataTask?

    init?(
        api: String,
        cachePolicy: URLRequest.CachePolicy = .reloadIgnoringCacheData
    ) {
        guard let apiStr = URL(string: api)?.host,
              let api = URL(string: apiStr)
        else {
            return nil
        }
        self.api = api
        self.cachePolicy = cachePolicy

        let sessionConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: sessionConfiguration)
    }

    private func _fetchToEndpoint(
        endpoint: String,
        completion: @escaping (Result<Data, URLError>) -> Void
    ) {

        assert(Thread.isMainThread)

        let url = api.appendingPathExtension(endpoint)
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
    ) -> Data {

        assert(Thread.isMainThread)

        var data = Data()
        let group = DispatchGroup()

        _fetchToEndpoint(
            endpoint: endpoint
        ) { result in

            group.enter()
            switch result {
            case .success(let success):
                data = success
            case .failure(let failure):
                print("[ERROR]", failure.localizedDescription)
            }
            group.leave()
        }
        group.wait()
        return data
    }
}

