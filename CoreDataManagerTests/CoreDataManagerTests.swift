//
//  CoreDataManagerTests.swift
//  CoreDataManagerTests
//
//  Created by 리지, goat on 2023/04/28.
//

import XCTest
@testable import Diary

final class CoreDataManagerTests: XCTestCase {
    
    var sut: CoreDataManager!
    let diaryFileName = "sample"
    var sampleDiary: [SampleDiary] = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = CoreDataManager.shared
        sampleDiary = try Decoder.parseJSON(fileName: diaryFileName, returnType: [SampleDiary].self) ?? []
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    func test_create매서드_성공시_read매서드호출결과는_nil이_아니다() {
        // given
        guard let firstSampleDiary = sampleDiary.first else { return }
        sut.create(diary: firstSampleDiary)
        
        // when
        let result = sut.read(key: firstSampleDiary.title)

        // then
        XCTAssertNotNil(result)
    }
    
    func test_readAll메서드성공시_파싱한_sampleDiary와_같다() {
        // given
        sampleDiary.forEach {
            sut.create(diary: $0)
        }
        let expectation = sampleDiary.removeLast().body
        
        // when
        guard var coreData = sut.readAll() else { return }
        let result = coreData.removeLast().body
        
        // then
        XCTAssertEqual(expectation, result)
    }
    
    func test_create메서드_성공시_Diary에저장된첫번째값의_title은_똘기떵이호치새초미자축인묘이다() {
        // given
        guard let firstSampleDiary = sampleDiary.first else { return }
        sut.create(diary: firstSampleDiary)
        let expectation = "똘기떵이호치새초미자축인묘"
        
        // when
        guard let result = sut.read(key: firstSampleDiary.title)?.title else { return }
        
        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_deleteAll메서드_성공시_read메서드호출결과는_nil이다() {
        // given
        guard let firstSampleDiary = sampleDiary.first else { return }
        sut.create(diary: firstSampleDiary)
        
        // when
        sut.deleteAll()
        let result = sut.read(key: firstSampleDiary.title)
        
        // then
        XCTAssertNil(result)
    }
    
    func test_delete메서드로_첫번째sampleDiary를_삭제했을시_다음의_첫번째sampleDiary는_드라고요롱이마초미미진사오미이다 () {
        // given
        sampleDiary.forEach {
            sut.create(diary: $0)
        }
        let expectation = "드라고요롱이마초미미진사오미"
    
        // when
        guard let firstSampleDiary = sampleDiary.first else { return }
        sut.delete(key: firstSampleDiary.title)
        guard let result = sut.read(key: firstSampleDiary.title)?.title else { return }
        
        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_update메서드_성공시_첫번째값의title이_update된다() {
        // given
        guard let firstSampleDiary = sampleDiary.first else { return }
        sut.create(diary: firstSampleDiary)
        let expectation = "드라고요롱이마초미미진사오미"
        
        // when
        sut.update(key: firstSampleDiary.title, diary: sampleDiary[1])
        guard let result = sut.read(key: firstSampleDiary.title)?.title else { return }
        
        // then
        XCTAssertEqual(result, expectation)
    }
}
