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
        task = session.dataTask(with: request) { data, responce, error in

            if
                error != nil,
                let error = error as? URLError
            {
                completion(.failure(error))
                return
            }

            guard let httpResponse = responce as? HTTPURLResponse,
                  (200...299) ~= httpResponse.statusCode
            else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.zeroByteResource)))
                return
            }
            completion(.success(data))
        }

        task?.resume()
    }

    public func fetchToEndpoint(
        endpoint: String
    ) -> Data {

        var data = Data()
        let group = DispatchGroup()

        group.enter()
        _fetchToEndpoint(
            endpoint: endpoint
        ) { result in

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

