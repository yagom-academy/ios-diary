//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by bonf, bard on 2022/08/29.
//

import XCTest
@testable import Diary

struct MockTestRequest: APIRequest {
    var method: HTTPMethod {
        .get
    }
    
    var baseURL: String {
        guard let fileLocation = Bundle.main.url(forResource: "MockData", withExtension: "json") else { return "" }
        guard let url = try? String(contentsOf: fileLocation) else { return "" }
        
        return url
    }
    
    var headers: [String: String]?
    
    var query: [URLQueryItem]?
    
    var body: Data?
    
    var path: URLAdditionalPath {
        .weather
    }
}


class NetworkTests: XCTestCase {
    var sut: MockTestRequest?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = MockTestRequest()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_mockRequest를통해_데이터를_잘받아오는지() {
        // given
        let expectation = expectation(description: "wait")
        let mockSession = MockSession()
        var main: String?
        guard let sut2 = sut else { return }
        
        mockSession.dataTask(with: sut2) { (result: Result<WeatherModel, Error>) in
            switch result {
            case .success(let success):
                main = success.weather[0].main
            case .failure(let failure):
                print(failure)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 200)
        
        // when
        let result = "Rain"
        
        // then
        XCTAssertEqual(main, result)
    }
}
