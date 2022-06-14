//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by Minseong, Lingo on 2022/06/14.
//

import XCTest
@testable import Diary

final class DiaryTests: XCTestCase {
  func testDiary_decodedData를호출했을때_title이주어진값이어야한다() {
    // given
    let diaries = Diary.decodedData
    let expectedValue = "똘기떵이호치새초미자축인묘"
    // when
    let title = diaries[0].title
    // then
    XCTAssertEqual(title, expectedValue)
  }
}
