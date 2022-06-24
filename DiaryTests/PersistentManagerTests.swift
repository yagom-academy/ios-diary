//
//  PersistentManagerTests.swift
//  DiaryTests
//
//  Created by Minseong, Lingo on 2022/06/22.
//

import XCTest
@testable import Diary

final class PersistentManagerTests: XCTestCase {

  override func setUpWithError() throws {
    try super.setUpWithError()
    DiaryPersistentManager.shared.deleteAll()
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }

  func testCreate_새로운diary가주어졌을때_coreData저장소에저장돼어야한다() {
    // given
    let diary = Diary(title: "테스트", body: "테스트중입니다.", createdAt: 30)
    let expectedValue = "테스트"

    // when
    DiaryPersistentManager.shared.create(diary: diary)
    let diaries = DiaryPersistentManager.shared.fetchAll()

    // then
    XCTAssertEqual(diaries[0].title, expectedValue)
  }

  func testUpdate_수정할diary가주어졌을때_수정이반영되어야한다() {
    // given
    var diary = Diary(title: "테스트", body: "테스트중입니다.", createdAt: 30)
    DiaryPersistentManager.shared.create(diary: diary)
    let input = DiaryPersistentManager.shared.fetchAll()

    // when
    diary.title = "수정테스트"
    DiaryPersistentManager.shared.update(diary: diary)
    let output = DiaryPersistentManager.shared.fetchAll()

    // then
    XCTAssertNotEqual(input[0].title, output[0].title)
  }

  func testDelete_삭제할diary가주어졌을때_삭제가반영되어야한다() {
    // given
    let expectedValue = 0
    let diary = Diary(title: "테스트", body: "테스트중입니다.", createdAt: 30)
    DiaryPersistentManager.shared.create(diary: diary)

    // when
    DiaryPersistentManager.shared.delete(diary: diary)
    let diaries = DiaryPersistentManager.shared.fetchAll()

    // then
    XCTAssertEqual(diaries.count, expectedValue)
  }
}
