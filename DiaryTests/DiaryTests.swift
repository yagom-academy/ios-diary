//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by 박세리 on 2022/06/17.
//

import XCTest
@testable import Diary

class DiaryCoreDataTest: XCTestCase {

    var diaryUseCase: DiaryUseCase!
    
    override func setUpWithError() throws {
        diaryUseCase = DiaryUseCase(containerManager: DiaryContainerManager.shared,
                                    weatherUseCase: WeatherDataUseCase(network: Network(),
                                                                       jsonDecoder: JSONDecoder()
                                                                      )
        )
    }

    override func tearDownWithError() throws {
        diaryUseCase = nil
    }

    func test_read() {
        do {
            let diaryInfo: DiaryInfo? = try diaryUseCase.create(element: DiaryInfo(title: "Test",
                                                                   body: "Test \n 안녕하세요 반갑습니다.",
                                                                   date: Date(),
                                                                   key: nil))
            let diaryList = try diaryUseCase.read()
            var target: DiaryInfo?
            for diary in diaryList where diary == diaryInfo {
                target = diary
            }
            XCTAssertEqual(target, diaryInfo)
        } catch {
            XCTFail("실패")
        }
    }
    
    func test_write() {
        // given
        let diaryInfo = DiaryInfo(title: "Test",
                                  body: "Test \n 안녕하세요 반갑습니다.",
                                  date: Date(),
                                  key: nil)
        var savedDiaryInfo: DiaryInfo
        // when
        do {
            savedDiaryInfo = try diaryUseCase.create(element: diaryInfo)
            guard let key = savedDiaryInfo.key else {
                XCTFail("키 값 오류")
                return
            }
            XCTAssertEqual(savedDiaryInfo, diaryUseCase.readOne(key: key))
        } catch {
            XCTFail("생성실패")
        }
        // then
    }
    
    func test_delete_fail() {
        do {
            try diaryUseCase.delete(element: DiaryInfo(title: "Test",
                                                       body: "Test \n 안녕하세요 반갑습니다.",
                                                       date: Date(),
                                                       key: UUID()))
            XCTFail("삭제 성공")
        } catch {
            XCTAssertEqual(error as? CoreDataError, CoreDataError.deleteError)
        }
    }
    
    func test_update() {
        do {
            let diaryInfo: DiaryInfo = try diaryUseCase.create(element: DiaryInfo(title: "Test",
                                                                   body: "Test \n 안녕하세요 반갑습니다.",
                                                                   date: Date(),
                                                                   key: nil))
            guard let key = diaryInfo.key else {
                XCTFail("키 값 오류")
                return
            }
            let editedDairy = DiaryInfo(title: "수정된 제목", body: "수정된 내용", date: diaryInfo.date, key: key)
            try diaryUseCase.update(element: editedDairy)
            XCTAssertEqual(editedDairy, diaryUseCase.readOne(key: key))
        } catch {
            XCTFail("업데이트 실패")
        }
    }
    
    func test_update_fail() {
        do {
            let editedDairy = DiaryInfo(title: "수정된 제목", body: "수정된 내용", date: nil, key: nil)
            try diaryUseCase.update(element: editedDairy)
            XCTFail("업데이트 성공")
        } catch {
            XCTAssertEqual(error as? CoreDataError, CoreDataError.updateError)
        }
    }
    
    func test_delete_success() {
        do {
            let diaryInfo: DiaryInfo = try diaryUseCase.create(element: DiaryInfo(title: "Test",
                                                                   body: "Test \n 안녕하세요 반갑습니다.",
                                                                   date: Date(),
                                                                   key: nil))
            guard let key = diaryInfo.key else {
                XCTFail("키 값 오류")
                return
            }
            try diaryUseCase.delete(element: diaryInfo)
            XCTAssertEqual(nil, diaryUseCase.readOne(key: key))
        } catch {
            XCTFail("삭제 실패")
        }
    }
}
