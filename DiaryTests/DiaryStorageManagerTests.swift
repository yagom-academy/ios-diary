//
//  DiaryStorageManagerTests.swift
//  DiaryTests
//
//  Created by Minseong, Lingo on 2022/06/22.
//

import XCTest
@testable import Diary

final class DiaryStorageManagerTests: XCTestCase {
  private var sut: DiaryStorageManager?

  override func setUpWithError() throws {
    try super.setUpWithError()
    self.sut = DiaryStorageManager()
    self.sut?.deleteAll()
  }

  override func tearDownWithError() throws {
    try super.tearDownWithError()
    self.sut = nil
  }

  func testCreate_새로운텍스트를저장할때_coreData저장소에저장되어야한다() {
    // given
    let text = "테스트\n테스트중입니다."
    let expectedValue = "테스트"

    // when
    self.sut?.create(text: text)
    guard let diaries = self.sut?.fetchAllDiaries() else {
      XCTFail()
      return
    }

    // then
    XCTAssertEqual(diaries[0].title, expectedValue)
  }

  func testUpdate_수정할diary가주어졌을때_수정이반영되어야한다() {
    // given
    var text = "테스트\n테스트중입니다."
    self.sut?.create(text: text)
    guard let input = self.sut?.fetchAllDiaries().first,
          let uuid = input.uuid
    else {
      XCTFail()
      return
    }

    // when
    text = "수정테스트\n테스트중입니다."
    self.sut?.update(uuid: uuid, text: text)
    guard let output = self.sut?.fetchAllDiaries().first else {
      XCTFail()
      return
    }

    // then
    XCTAssertNotEqual(input.title, output.title)
  }

  func testDelete_삭제할diary가주어졌을때_삭제가반영되어야한다() {
    // given
    let expectedValue = 0
    let text = "테스트\n테스트중입니다."
    self.sut?.create(text: text)
    guard let input = self.sut?.fetchAllDiaries().first,
          let uuid = input.uuid
    else {
      XCTFail()
      return
    }

    // when
    self.sut?.delete(uuid: uuid)
    guard let diaries = self.sut?.fetchAllDiaries() else {
      XCTFail()
      return
    }

    // then
    XCTAssertEqual(diaries.count, expectedValue)
  }
}
