//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by 리지, Goat on 2023/04/24.
//

import XCTest
@testable import Diary

final class DiaryTests: XCTestCase {
    var sut: [SampleDiary]!
    let fileName = "sample"

    override func setUpWithError() throws {
       try super.setUpWithError()
        
        sut = Decoder.parseJSON(fileName: fileName, returnType: [SampleDiary].self)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    func test_parseJSON실행시_sut는nil이아니다() {
        XCTAssertNotNil(sut)
    }
    
    func test_sampleDiary의첫번째타이틀은_똘기떵이호치새초미자축인묘이다() {
        // given
        let expectation = "똘기떵이호치새초미자축인묘"
        
        // when
        let result = sut[0].title
        
        // then
        XCTAssertEqual(result, expectation)
    }
    
    func test_sampleDiary의갯수는_15개이다() {
        // given
        let expectation = 15
        
        // when
        let result = sut.count
        
        // then
        XCTAssertEqual(result, expectation)
    }
}
