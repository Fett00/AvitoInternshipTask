import XCTest
@testable import AvitoInternshipTask

final class NetworkManagerTests: XCTestCase {

    func test_NetworkManagerResolveApi() {

        let networkManager = NetworkManager(api: "https://run.mocky.io")
        XCTAssertNotNil(networkManager)
    }

    func test_NetworkManagerFetchData() {

        let networkManager = NetworkManager(api: "https://run.mocky.io")
        XCTAssertNotNil(networkManager)

        let result = networkManager!.fetchToEndpoint(
            endpoint: "/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        )

        switch result {
        case .success(let data):
            XCTAssert(data.isEmpty == false)
        case .failure(_):
            XCTAssert(true)
        }
    }

}
