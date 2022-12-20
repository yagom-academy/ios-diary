//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/20.
//

import XCTest
@testable import Diary

class DiaryTests: XCTestCase {
    func test_JSON_sample_data가_diary_타입에_맞게_decoding이_되는지() {
        guard let asset = NSDataAsset.init(name: "sample") else {
            return
        }

        let jsonDecoder = JSONDecoder()
        guard let decodedData = try? jsonDecoder.decode([Diary].self, from: asset.data) else {
            return
        }

        XCTAssertNotNil(decodedData)
    }
}
