import Foundation

protocol ParseManagerProtocol: AnyObject {
    func parse<ModelType: Decodable>(type: ModelType.Type, data: Data) -> ModelType?
}

class ParseManager: ParseManagerProtocol {

    private let jsonParser: JSONDecoder

    init(jsonParser: JSONDecoder = JSONDecoder()) {
        self.jsonParser = jsonParser
        jsonParser.keyDecodingStrategy = .convertFromSnakeCase
    }

    func parse<ModelType: Decodable>(type: ModelType.Type, data: Data) -> ModelType? {

        do {
            let model = try jsonParser.decode(ModelType.self, from: data)
            return model
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
