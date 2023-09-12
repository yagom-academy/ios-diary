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
            // given
            let expectation = DiaryEntry(title: "test", body: "Read Test")
            try sut.storeDiary(expectation)
            // when
            let result = try sut.diaryEntrys().first
            // then
            XCTAssertEqual(result, expectation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_storeDiary로_일기를_저장할_수_있습니다() {
        do {
            // given
            let expectation = DiaryEntry(title: "test", body: "store Test")
            try sut.storeDiary(expectation)
            // when
            let result = try sut.diaryEntrys().first
            // then
            XCTAssertEqual(result, expectation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_storeDiary로_저장된_일기를_수정할_수_있습니다() {
        do {
            // given
            var expectation = DiaryEntry(title: "test", body: "update test")
            try sut.storeDiary(expectation)
            
            // when
            expectation.body = "update test update test"
            try sut.storeDiary(expectation)
            let result = try sut.diaryEntrys().first
            // then
            XCTAssertEqual(result, expectation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_deleteDiary로_원하는_일기를_삭제할_수_있습니다() {
        do {
            // given
            let diaryEntry = DiaryEntry(title: "test", body: "delete test")
            try sut.storeDiary(diaryEntry)
            // when
            try sut.deleteDiary(diaryEntry)
            let result = try sut.diaryEntrys().isEmpty
            // then
            XCTAssertTrue(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
