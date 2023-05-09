//
//  DiaryServiceTests.swift
//  DiaryServiceTests
//
//  Created by Andrew, brody on 2023/05/02.
//

import XCTest
import CoreData
@testable import Diary

final class DiaryServiceTests: XCTestCase {
    var diaryService: DiaryService!
    
    override func setUp() {
        diaryService = DiaryService(coreDataStack: MockCoreDataManager.shared)
    }

    override func tearDown() {
        diaryService = nil
    }
    
    func test_create호출시_입력된값을_기반으로_일기장을_생성한다() {
        // given
        let id = UUID()
        let title = "일기장 제목"
        let body = "일기장"
        
        // when
        let result = diaryService.create(id: id, title: title, body: body)
        
        // then
        switch result {
        case .success(let newDiary):
            XCTAssertEqual(newDiary.title, title)
            XCTAssertEqual(newDiary.body, body)
        case .failure:
            XCTFail("일기장 생성 실패")
        }
    }
    
    func test_update호출시_id에_해당하는_내용을_변경한다() {
        // given
        let id = UUID()
        let title = "일기장 제목"
        let body = "일기장 내용"
        
        let updatedTitle = "변경될 제목"
        let updatedBody = "변경될 내용"
        
        // when
        diaryService.create(id: id, title: title, body: body)
        let result = diaryService.update(id: id, title: updatedTitle, body: updatedBody)
        
        // then
        switch result {
        case .success(let updatedDiary):
            XCTAssertEqual(updatedDiary.title, updatedTitle)
            XCTAssertEqual(updatedDiary.body, updatedBody)
        case .failure:
            XCTFail("일기장 수정 실패")
        }
    }
    
    func test_delete호출시_id에_해당하는_내용을_삭제한다() {
        // given
        let id = UUID()
        let title = "일기장 제목"
        let body = "일기장 내용"
        
        // when
        diaryService.create(id: id, title: title, body: body)
        let result = diaryService.delete(id: id)
        
        // then
        switch result {
        case .success:
            XCTAssert(true)
        case .failure:
            XCTFail("일기장 삭제 실패")
        }
    }
}
