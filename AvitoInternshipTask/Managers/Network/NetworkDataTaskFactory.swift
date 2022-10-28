import Foundation

class NetworkDataTaskFactory {

    static func makeDefaultDataTask(
        _ session: URLSession,
        _ request: URLRequest,
        completion: @escaping (Result<Data, URLError>) -> Void
    ) -> URLSessionDataTask {

        session.dataTask(with: request) { data, responce, error in

            if error != nil,
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
    }
}
