//
//  DiaryEntryTests.swift
//  DiaryEntryTests
//
//  Created by Erick on 2023/08/29.
//

import XCTest
@testable import Diary

final class DiaryEntryTests: XCTestCase {

    func test_sample_Asset_data를_디코딩할_때_DiaryEntry와_매칭_시킬_수_있습니다() {
        // given
        let asset = NSDataAsset.init(name: "sample")
        // when
        let diaryEntrys = try? JSONDecoder().decode([DiaryEntry].self, from: asset!.data)
        // then
        XCTAssertNotNil(diaryEntrys)
    }
}
