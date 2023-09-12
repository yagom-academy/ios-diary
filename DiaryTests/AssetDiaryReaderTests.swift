//
//  AssetDiaryReaderTests.swift
//  DiaryStorageTests
//
//  Created by Erick on 2023/08/30.
//

import XCTest
@testable import Diary

final class AssetDiaryReaderTests: XCTestCase {
    var sut: AssetDiaryReader?
    
    override func setUpWithError() throws {
        sut = AssetDiaryReader()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_AssetDiaryReader의_DiaryEntrys를_사용하면_DiaryEntry배열을_반환합니다() {
        do {
            // when
            let result = try sut?.diaryEntrys() is [DiaryEntry]
            // then
            XCTAssertTrue(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
