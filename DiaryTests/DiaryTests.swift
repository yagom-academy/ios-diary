//
//  DiaryTests.swift
//  DiaryTests
//
//  Created by leewonseok on 2022/12/27.
//

import XCTest
@testable import Diary

final class DiaryTests: XCTestCase {

    func testExample() throws {
        CoreDataManager.shared.createDiary(data: DiaryData(title: "ㅋㅋ", body: "ㅋㅋ", createdAt: 123))
    }
}
