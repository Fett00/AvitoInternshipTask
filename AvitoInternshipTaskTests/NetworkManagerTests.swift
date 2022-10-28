//
//  NetworkManagerTests.swift
//  AvitoInternshipTaskTests
//
//  Created by Садык Мусаев on 28.10.2022.
//

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

        let data = networkManager?.fetchToEndpoint(
            endpoint: "/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        )

        XCTAssert(data?.isEmpty == false)
    }

}
