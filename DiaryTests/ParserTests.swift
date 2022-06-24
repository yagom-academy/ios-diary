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
}
