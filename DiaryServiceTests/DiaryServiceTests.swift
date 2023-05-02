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

    var coreDataStack: CoreDataStack!
    var diaryService: DiaryService!
    
    override func setUp() {
        coreDataStack = CoreDataStack.shared
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
        let result = diaryService.create(title: title, body: body, id: id)
        let filteredRequest = Diary.fetchRequest()
        filteredRequest.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        // then
        do {
            let createdDiary = try CoreDataStack.shared.managedContext.fetch(filteredRequest).first
            XCTAssertEqual(createdDiary?.body, body)
            XCTAssertEqual(createdDiary?.title, title)
        } catch {
            XCTFail("테스트가 실패하였습니다.")
        }
    }
}
