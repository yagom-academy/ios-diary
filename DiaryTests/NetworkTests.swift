//
//  NetworkTests.swift
//  NetworkTests
//
//  Created by bonf, bard on 2022/08/29.
//

import XCTest
@testable import Diary

struct TestRequest: APIRequest {
    var method: HTTPMethod  {
        .get
    }
    
    var baseURL: String {
        URLHost.openWeather.url + path.value
    }
    
    var headers: [String: String]?
    
    var query: [URLQueryItem]? = [
        URLQueryItem(name: "lat", value: "35"),
        URLQueryItem(name: "lon", value: "139"),
        URLQueryItem(name: "appid", value: "63722b736b97508775be46f7cf76cb85")
    ]
    
    var body: Data?
    
    var path: URLAdditionalPath {
        .weather
    }
}

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
    var sut: TestRequest?
    var sut2: MockTestRequest?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = TestRequest()
        sut2 = MockTestRequest()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        sut2 = nil
    }
    
    func test_mockRequest를통해_데이터를_잘받아오는지() {
        // given
        let expectation = expectation(description: "wait")
        let mockSession = MockSession()
        var main: String?
        guard let sut2 = sut2 else { return }
        
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
    
    func test_urlRequest를통해_데이터를_잘받아오는지() {
        // given
        let expectation = expectation(description: "wait")
        let weatherSession = DiaryURLSession()
        var main: String?
        
        guard let sut = sut else { return }
        
        weatherSession.dataTask(with: sut) { (result: Result<WeatherModel, Error>) in
            switch result {
            case .success(let success):
                main = success.weather[0].main
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
