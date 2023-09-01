//
//  DateFormatManagerTests.swift
//  DateFormatManagerTests
//
//  Created by Erick on 2023/08/30.
//

import XCTest
@testable import Diary

final class DateFormatManagerTests: XCTestCase {
    
    func test_DateFormatManager의_string_메서드에_UserDateFormatter와_1608651333를_입력하면_2020년_12월_23일이_반환됩니다() {
        // given
        let userDateFormatter = UserDateFormatter()
        let expectation = "2020년 12월 23일"
        // when
        let result = DateFormatManager.string(localeDateFormatter: userDateFormatter, timestamp: 1608651333)
        // then
        XCTAssertEqual(result, expectation)
    }
}
