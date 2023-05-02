//
//  DiaryServiceTests.swift
//  DiaryServiceTests
//
//  Created by Andrew, brody on 2023/05/02.
//

import XCTest
@testable import Diary
import CoreData

final class DiaryServiceTests: XCTestCase {

    var coreDataStack: CoreDataStack!
    var diaryService: DiaryService!
    
    override func setUp() {
        coreDataStack = CoreDataStack.shared
        coreDataStack.changeStoreType(type: .inMemory)
        diaryService = DiaryService(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        coreDataStack = nil
        diaryService = nil
    }
}


