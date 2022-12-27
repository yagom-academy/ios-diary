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
        CoreDataManager.shared.createDiary(data: DiaryData(id: UUID(), title: "일번", body: "ㅋㅋ", createdAt: 123))
        CoreDataManager.shared.createDiary(data: DiaryData(id: UUID(), title: "이번", body: "ㅋㅋ", createdAt: 123))
        CoreDataManager.shared.createDiary(data: DiaryData(id: UUID(), title: "삼번", body: "ㅋㅋ", createdAt: 123))
    }
    
    func test_코어데이터저장소에서_데이터를_정상적으로_불러오는지() {
        let result = CoreDataManager.shared.fetchDiaryList()
        
        result?.forEach({ diary in
            print("diary.id: ", diary.id)
            print("diary.content: ", diary.content ?? "")
            print("diary.createdAt: ", diary.createdAt)
            print("diary.title: ", diary.title ?? "")
        })
        
    }
    
    func test_코어데이터저장소에서_데이터를_정상적으로_수정하는지() {
        if let result = CoreDataManager.shared.fetchDiaryList()?.last {
            result.content = "수정된 내용입니다."
            result.title = "내용입니다."
            CoreDataManager.shared.updateDiary(diary: result)
        }

        test_코어데이터저장소에서_데이터를_정상적으로_불러오는지()
    }
    
    func test_코어데이터저장소에서_데이터를_정상적으로_삭제하는지() {
        guard let given = CoreDataManager.shared.fetchDiaryList()?.last else { return }
        CoreDataManager.shared.deleteDiary(diary: given)
        
        test_코어데이터저장소에서_데이터를_정상적으로_불러오는지()
    }
}
