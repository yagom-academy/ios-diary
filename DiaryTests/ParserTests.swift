//
//  ParserTests.swift
//  ParserTests
//
//  Created by Minseong, Lingo on 2022/06/14.
//

import XCTest
@testable import Diary

final class ParserTests: XCTestCase {
  func testDecode_Sample데이터를Decode했을때_title이올바른값이어야한다() {
    // given
    guard let diaries = Parser.decode(type: [Diary].self, assetName: "sample") else {
      XCTFail()
      return
    }
    let expectedValue = "똘기떵이호치새초미자축인묘"

    // when
    let title = diaries[0].title

    // then
    XCTAssertEqual(title, expectedValue)
  }

  func testDecode_Weather데이터를불러왔을때_올바르게decode가되어야한다() {
    let promise = expectation(description: "NetworkServiceExpectation")

    let service = NetworkService(session: .shared)
    let endpoint = APIEndpoint.fetchWeather(lat: 33.33, lon: 12.33)

    service.request(endpoint: endpoint) { result in
      guard case let .success(data) = result else {
        XCTFail()
        return
      }
      let result = Parser.decode(WeatherResponse.self, data: data)
      XCTAssertNotNil(result)

      promise.fulfill()
    }

    wait(for: [promise], timeout: 5)
  }
}
