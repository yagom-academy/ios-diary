//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by bonf, bard on 2022/08/29.
//

import XCTest
@testable import Diary

struct TestRequest: APIRequest {
    var method: HTTPMethod = .get
    
    var baseURL: String {
        URLHost.openWeather.url + path.value
    }
    
    var headers: [String: String]?
    
    var query: [URLQueryItem]? = [URLQueryItem(name: "lat", value: "35"),
    URLQueryItem(name: "lon", value: "139"),
    URLQueryItem(name: "appid", value: "63722b736b97508775be46f7cf76cb85")]
    
    var body: Data?
    
    var path: URLAdditionalPath {
        .weather
    }
}

class NetworkTests: XCTestCase {
    var sut: TestRequest?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TestRequest()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_urlRequest를통해_데이터를_잘받아오는지() {
        // given
        let expectation = expectation(description: "wait")
        var main: String?
        var icon: String?
        let weatherSession = WeatherURLSession()
        guard let sut = sut else { return }
        
        
        weatherSession.dataTask(with: sut) { (result: Result<WeatherModel, Error>) in
            switch result {
            case .success(let success):
                main = success.weather[0].main
                icon = success.weather[0].icon
            case .failure(let failure):
                print(failure)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 300)
        
        
        // when
        let result = "Clouds"
        
        // then
        XCTAssertEqual(main, result)
    }

}
