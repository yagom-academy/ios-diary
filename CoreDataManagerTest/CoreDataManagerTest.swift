//
//  CoreDataManagerTest.swift
//  CoreDataManagerTest
//
//  Created by 리지, goat on 2023/04/28.
//

import XCTest
@testable import Diary

final class CoreDataManagerTest: XCTestCase {
    
    var sut: CoreDataManager!
    
    let diaryFileName = "sample"
    var sampleDiary: [SampleDiary] = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sampleDiary = Decoder.parseJSON(fileName: diaryFileName, returnType: [SampleDiary].self) ?? []
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
    
    func test_create매서드_성공시_read매서드는_nil이_아니다(){
        guard let firstSampleDiary = sampleDiary.first else { return }
        
//        let diary = firstSampleDiary.
//        
//        sut.create(key: firstSampleDiary.title, diary: [Diary])
    }

}
