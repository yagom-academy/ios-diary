//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by 박세리 on 2022/06/17.
//

import XCTest

class DiaryCoreDataTest: XCTestCase {

    var diaryUseCase: DiaryUseCase!
    
    override func setUpWithError() throws {
        diaryUseCase = DiaryUseCase()
    }

    override func tearDownWithError() throws {
        diaryUseCase = nil
    }

    func test_read() {
        do {
            let diaryList = try diaryUseCase.read()
            print(diaryList)
        } catch {
            XCTFail("실패")
        }
    }
    
    
    func test_write() {
        // given
        let diaryInfo = DiaryInfo(title: "첫날", body: "안녕하세요 반갑습니다.", date: Date(), key: nil)
        
        // when
        do {
            try diaryUseCase.create(diary: diaryInfo)
        } catch {
            XCTFail("생성실패")
        }
        
        // then
    }
    
    func test_delete_fail() {
        do {
            try diaryUseCase.delete(key: 0)
            XCTFail()
        } catch {
            
        }
    }
    
    func test_delete_success() {
        do {
            try diaryUseCase.delete(key: 1)
        } catch {
            XCTFail()
        }
    }
}
