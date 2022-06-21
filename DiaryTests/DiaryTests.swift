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
        diaryUseCase = DiaryUseCase(containerManager: ContainerManager.shared)
    }

    override func tearDownWithError() throws {
        diaryUseCase = nil
    }

    func test_read() {
        do {
            let diaryList = try diaryUseCase.read()
            print("다이어리 리스트: \(diaryList)")
        } catch {
            XCTFail("실패")
        }
    }
    
    func test_write() {
        // given
        let diaryInfo = DiaryInfo(title: "첫날", body: "첫날\n 안녕하세요 반갑습니다.", date: Date(), key: nil)
        
        // when
        do {
            try diaryUseCase.create(element: diaryInfo)
        } catch {
            XCTFail("생성실패")
        }
        
        // then
    }
    
    func test_delete_fail() {
        do {
            //try diaryUseCase.delete(element: 0)
        } catch {
            XCTFail()
        }
    }
    
    func test_update() {
        do {
            let editedDairy = DiaryInfo(title: "수정된 제목", body: "수정된 내용", date: nil, key: nil)
            try diaryUseCase.update(element: editedDairy)
        } catch {
            XCTFail()
        }
    }
    
    func test_delete_success() {
        do {
            //try diaryUseCase.delete(element: 1)
        } catch {
            XCTFail()
        }
    }
}
