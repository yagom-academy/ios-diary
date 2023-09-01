//
//  DiaryStorageTests.swift
//  DiaryStorageTests
//
//  Created by Erick on 2023/08/30.
//

import XCTest
@testable import Diary

final class DiaryStorageTests: XCTestCase {
    var sut: DiaryStorageProtocol?
    
    override func setUpWithError() throws {
        sut = AssetDiaryStorage()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_DiaryStorageProtocol_타입의_DiaryEntrys를_사용하면_DiaryEntry배열을_반환합니다() {
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
