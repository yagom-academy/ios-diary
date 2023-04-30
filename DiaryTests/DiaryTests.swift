//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by Seoyeon Hong on 2023/04/25.
//

import XCTest
@testable import Diary

final class DiaryTests: XCTestCase {
    func testDecode_SampleDataTitleSameAsExpectation() {
        // given
        guard let diaryItem = JsonConverter.decode() else { return }
        let expectation = "똘기떵이호치새초미자축인묘"
        // when
        let title = diaryItem[0].title
        // then
        XCTAssertEqual(title, expectation)
    }
}
