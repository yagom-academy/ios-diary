//
//  CoreDataDiaryManagerTests.swift
//  DiaryTests
//
//  Created by Erick on 2023/09/08.
//

import XCTest
@testable import Diary

final class CoreDataDiaryManagerTests: XCTestCase {
    var sut: CoreDataDiaryManager!
    
    override func setUpWithError() throws {
        sut = CoreDataDiaryManager()
    }

    override func tearDownWithError() throws {
        try sut.deleteAll()
    }

    func test_CoreDataDiaryManager의_DiaryEntrys를_사용하면_DiaryEntry배열을_반환합니다() {
        do {
            // when
            let result = try sut.diaryEntrys() is [DiaryEntry]
            // then
            XCTAssertTrue(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_storeDiary로_일기를_저장할_수_있습니다() {
        do {
            // given
            try sut.storeDiary(title: "test", body: "store test")
            let expectation = "store test"
            // when
            let result = try sut.diaryEntrys().first?.body
            // then
            XCTAssertEqual(result, expectation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_updateDiary로_저장된_일기를_수정할_수_있습니다() {
        do {
            // given
            try sut.storeDiary(title: "test", body: "update test")
            var diaryEntry = try sut.diaryEntrys().first
            diaryEntry?.body = "update test update test"
            // when
            try sut.updateDiary(diaryEntry!)
            let result = try sut.diaryEntrys().first
            // then
            XCTAssertEqual(result, diaryEntry)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_deleteDiary로_원하는_일기를_삭제할_수_있습니다() {
        do {
            // given
            try sut.storeDiary(title: "test", body: "delete test")
            let diaryEntry = try sut.diaryEntrys().first
            // when
            try sut.deleteDiary(diaryEntry!)
            let result = try sut.diaryEntrys().isEmpty
            // then
            XCTAssertTrue(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
