//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/20.
//

import XCTest
@testable import Diary

class DiaryTests: XCTestCase {
    func test_JSON_sample_data는_DiaryResponseDTO타입으로_decoding_된다() throws {
        guard let path = Bundle.main.path(forResource: "sample", ofType: "json") else {
            return XCTFail("sample data 경로 오류")
        }

        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decodedData = try JSONDecoder().decode([DiaryResponseDTO].self, from: data)

        XCTAssertNotNil(decodedData)
    }
}
