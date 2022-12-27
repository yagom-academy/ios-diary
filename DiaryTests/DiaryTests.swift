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
    
    func test_코어데이터저장소에서_데이터를_정상적으로_불러오는지() throws {
        let result = CoreDataManager.shared.readDiary()
        
        result?.forEach({ diary in
            print("diary.id: ", diary.id ?? "")
            print("diary.content: ", diary.content ?? "")
            print("diary.createdAt: ", diary.createdAt)
            print("diary.title: ", diary.title ?? "")
        })
        
    }
}
