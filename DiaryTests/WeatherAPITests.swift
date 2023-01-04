//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by 이태영 on 2023/01/04.
//

import XCTest
import CoreLocation
@testable import Diary

final class WeatherAPITests: XCTestCase {
    var sut: StubNetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = StubNetworkManager()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_searchWeatherAPI네트워킹이잘되는지() {
        // given
        let location = CLLocationCoordinate2D(latitude: 37.5666805, longitude: 126.9784147)
        let endPoint = SearchWeatherAPI(location: location)
        
        // when
        sut.requestData(endPoint: endPoint, type: WeatherEntity.self) { _ in }
        
        // then
        XCTAssertTrue(sut.data == WeatherEntity.mockData)
    }
}
