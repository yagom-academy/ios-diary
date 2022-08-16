//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by Hugh, Derrick on 2022/08/16.
//

import XCTest
@testable import Diary

class DiaryTests: XCTestCase {
    var sut: NetworkingProvider?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkingProvider()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_JSON파일을_호출할때_DiaryContent타입의_Data반환() {
        //given
        let fileName = "diarySample"
        let expectation = "똘기떵이호치새초미자축인묘"
        let decodedData = sut?.requestAndDecode(fileName, dataType: [DiaryContent].self)
        
        //when
        switch decodedData {
        case .success(let contents):
            //then
            let result = contents[0].title
            XCTAssertEqual(expectation, result)
        default:
            return
        }
    }
    
    func test_JSON파일_이름이_다를때_JSONError를_반환() {
        //given
        let fileName = "diary"
        let expectation = JSONError.noneFile
        let decodedData = sut?.requestAndDecode(fileName, dataType: [DiaryContent].self)
        
        //when
        switch decodedData {
        case .failure(let error):
            //then
            XCTAssertEqual(expectation, error)
        default:
            return
        }
    }
    
    func test_JSON파일_디코딩이_실패할때_JSONError를_반환() {
        //given
        let fileName = "diarySample"
        let expectation = JSONError.decodingFailure
        let decodedData = sut?.requestAndDecode(fileName, dataType: DiaryContent.self)
        
        //when
        switch decodedData {
        case .failure(let error):
            //then
            XCTAssertEqual(expectation, error)
        default:
            return
        }
    }
}
