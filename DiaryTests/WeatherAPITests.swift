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
    var sut: NetworkService!
    
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
        var result: WeatherEntity?
        sut.requestData(endPoint: endPoint, type: WeatherEntity.self) { value in
            guard let resultedValue = value as? WeatherEntity else {
                XCTFail("기대하는 타입과 반환된 타입이 다릅니다.")
                return
            }
            
            result = resultedValue
        }
        
        // then
        XCTAssertTrue(result == WeatherEntity(main: "Clear", icon: "01d"))
    }
}
