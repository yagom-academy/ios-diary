//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by 재재, 그루트 on 2022/08/17.
//

import XCTest
@testable import Diary

class DiaryTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_Json_데이터_디코딩이_되는지() {
        // given
        let data = NSDataAsset(name: "testSample")
        guard let decodedData = try? JSONDecoder().decode(DiaryTestData.self,
                                                          from: data?.data ?? Data()) else { return }
        let title = decodedData.title

        // when
        let result = "똘기떵이호치새초미자축인묘"

        // then
        XCTAssertEqual(result, title)
    }
}
