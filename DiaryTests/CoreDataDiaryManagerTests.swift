//
//  CoreDataDiaryManagerTests.swift
//  DiaryTests
//
//  Created by Erick on 2023/09/08.
//

import XCTest
import CoreData
@testable import Diary

final class CoreDataDiaryManagerTests: XCTestCase {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DiaryData")
        
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    var sut: CoreDataDiaryManager!
    
    override func setUpWithError() throws {
        sut = CoreDataDiaryManager(persistentContainer: persistentContainer)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func test_CoreDataDiaryManager의_DiaryEntrys를_사용하면_DiaryEntry배열을_반환합니다() {
        do {
            // given
            let expectation = DiaryEntry(title: "test", body: "Read Test")
            try sut.storeDiary(expectation)
            // when
            let result = try sut.diaryEntrys().first
            // then
            XCTAssertEqual(result, expectation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_storeDiary로_일기를_저장할_수_있습니다() {
        do {
            // given
            let expectation = DiaryEntry(title: "test", body: "store Test")
            try sut.storeDiary(expectation)
            // when
            let result = try sut.diaryEntrys().first
            // then
            XCTAssertEqual(result, expectation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_storeDiary로_저장된_일기를_수정할_수_있습니다() {
        do {
            // given
            var expectation = DiaryEntry(title: "test", body: "update test")
            try sut.storeDiary(expectation)
            
            // when
            expectation.body = "update test update test"
            try sut.storeDiary(expectation)
            let result = try sut.diaryEntrys().first
            // then
            XCTAssertEqual(result, expectation)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_deleteDiary로_원하는_일기를_삭제할_수_있습니다() {
        do {
            // given
            let diaryEntry = DiaryEntry(title: "test", body: "delete test")
            try sut.storeDiary(diaryEntry)
            // when
            try sut.deleteDiary(diaryEntry)
            let result = try sut.diaryEntrys().isEmpty
            // then
            XCTAssertTrue(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
