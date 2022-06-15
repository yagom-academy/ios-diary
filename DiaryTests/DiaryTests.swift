//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by dudu, papri on 2022/06/14.
//

import XCTest
@testable import Diary

class DiaryTests: XCTestCase {
    func test_sample_json이_Diary배열_타입으로_decoding되는지() {
        // given
        let url = Bundle.main.url(forResource: "sample", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let targetTitle = "똘기떵이호치새초미자축인묘"
        
        // when
        let diarys = try! JSONDecoder().decode([Diary].self, from: data)
        
        // then
        XCTAssertEqual(diarys.first?.title, targetTitle)
    }
}
