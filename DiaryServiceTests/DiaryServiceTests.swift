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
    var coreDataStack: CoreDataManager!
    var diaryService: DiaryService!
    
    override func setUp() {
        coreDataStack = CoreDataManager.shared
        coreDataStack.changeStoreType(type: .inMemory)
        diaryService = DiaryService(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        coreDataStack = nil
        diaryService = nil
    }
    
    func test_create호출시_입력된값을_기반으로_일기장을_생성한다() {
        // given
        let id = UUID()
        let title = "일기장 제목"
        let body = "일기장 내용"
        
        // when
        diaryService.create(id: id, title: title, body: body)
        let filteredRequest = Diary.fetchRequest()
        filteredRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        // then
        do {
            let createdDiary = try CoreDataManager.shared.managedContext.fetch(filteredRequest).first
            XCTAssertEqual(createdDiary?.title, title)
            XCTAssertEqual(createdDiary?.body, body)
        } catch {
            XCTFail("테스트가 실패하였습니다.")
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
        diaryService.update(id: id, title: updatedTitle, body: updatedBody)
        let filteredRequest = Diary.fetchRequest()
        filteredRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        // then
        do {
            let createdDiary = try CoreDataManager.shared.managedContext.fetch(filteredRequest).first
            XCTAssertEqual(createdDiary?.title, updatedTitle)
            XCTAssertEqual(createdDiary?.body, updatedBody)
        } catch {
            XCTFail("테스트가 실패하였습니다.")
        }
    }
    
    func test_delete호출시_id에_해당하는_내용을_삭제한다() {
        // given
        let id = UUID()
        let title = "일기장 제목"
        let body = "일기장 내용"
        
        // when
        diaryService.create(id: id, title: title, body: body)
        diaryService.delete(id: id)
        let filteredRequest = Diary.fetchRequest()
        filteredRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        // then
        do {
            let createdDiary = try CoreDataManager.shared.managedContext.fetch(filteredRequest).first
            XCTAssertNil(createdDiary)
        } catch {
            XCTFail("테스트가 실패하였습니다.")
        }
    }
}
