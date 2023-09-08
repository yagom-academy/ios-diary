//
//  CoreDataDiaryStorage.swift
//  DiaryTests
//
//  Created by Erick on 2023/09/08.
//

import XCTest
@testable import Diary

final class CoreDataDiaryStorageTests: XCTestCase {
    var sut: DiaryStorageProtocol?
    
    override func setUpWithError() throws {
        sut = CoreDataDiaryStorage()
    }

    override func tearDownWithError() throws {
        try sut?.deleteAll()
    }

    func test_CoreDataDiaryStorage의_DiaryEntrys를_사용하면_DiaryEntry배열을_반환합니다() {
        do {
            // when
            let result = try sut?.diaryEntrys() is [DiaryEntry]
            // then
            XCTAssertTrue(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_storeDiary로_일기를_저장할_수_있습니다() {
        // given
        let id = UUID()
        
        do {
            // given
            let diary = DiaryEntry(id: id, title: "test", body: "store", creationDate: "2020년 12월 23일")
            // when
            try sut?.storeDiary(diary)
            let result = try sut?.diaryEntrys().first
            // then
            XCTAssertEqual(result, diary)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_updateDiary로_저장된_일기를_수정할_수_있습니다() {
        // given
        let id = UUID()
        
        do {
            // given
            let diary = DiaryEntry(id: id, title: "test", body: "store", creationDate: "2020년 12월 23일")
            try sut?.storeDiary(diary)
            let updateDiary = DiaryEntry(id: id, title: "test", body: "update", creationDate: "2020년 12월 23일")
            // when
            try sut?.updateDiary(updateDiary)
            let result = try sut?.diaryEntrys().first
            // then
            XCTAssertEqual(result, updateDiary)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_deleteDiary로_원하는_일기를_삭제할_수_있습니다() {
        // given
        let id = UUID()
        
        do {
            // given
            let diary = DiaryEntry(id: id, title: "test", body: "store", creationDate: "2020년 12월 23일")
            try sut?.storeDiary(diary)
            // when
            try sut?.deleteDiary(diary)
            let result = try sut?.diaryEntrys().isEmpty
            // then
            XCTAssertTrue(result!)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
