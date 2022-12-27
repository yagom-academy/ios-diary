//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by leewonseok on 2022/12/27.
//

import XCTest
@testable import Diary

final class DiaryTests: XCTestCase {
    
    func test_코어데이터저장소에_정상적으로_데이터가_insert_되는지() throws {
        do {
            let result: () = try CoreDataManager.shared.createDiary(data: DiaryData(id: UUID(), title: "일번", body: "ㅋㅋ", createdAt: 123))
            XCTAssertNotNil(result)
        } catch {
            XCTFail("Fail")
        }
    }
    
    func test_코어데이터저장소에서_데이터를_정상적으로_불러오는지() {
        let result = try? CoreDataManager.shared.fetchDiaryList()
        
        result?.forEach({ diary in
            print("diary.id: ", diary.id)
            print("diary.title: ", diary.title)
        })

        XCTAssertNotNil(result)
    }
    
    func test_코어데이터저장소에서_데이터를_정상적으로_수정하는지() {
        let editTitle = ["수정될 제목", "수정된 제목", "수정할 제목", "수정 제목"].randomElement()!
        
        do {
            guard let diary = try CoreDataManager.shared.fetchDiaryList().first else {
                XCTFail("Fail")
                return
            }
            
            diary.title = editTitle
            try CoreDataManager.shared.updateDiary(updatedDiary: diary)
            let result = try CoreDataManager.shared.fetchDiaryList().first
            
            XCTAssertEqual(result?.title, editTitle)
        } catch {
            XCTFail("Fail")
        }
    }
    
    func test_코어데이터저장소에서_데이터를_정상적으로_삭제하는지() {
        guard let diary = try? CoreDataManager.shared.fetchDiaryList().first else {
            XCTFail("Fail")
            return
        }
        
        XCTAssertNotNil(try? CoreDataManager.shared.deleteDiary(diary: diary))
    }
}
