//
//  DiaryContentViewModelTest.swift
//  DiaryContentViewModelTest
//
//  Created by dhoney96 on 2022/08/29.
//

import XCTest
@testable import Diary

class DiaryContentViewModelTest: XCTestCase {
    var viewModel: SpyDiaryContentViewModel?
    var diaryPostView: DiaryPostViewController?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.viewModel = SpyDiaryContentViewModel()
        self.diaryPostView = DiaryPostViewController()
        self.diaryPostView?.diaryViewModel = viewModel
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewModel = nil
        diaryPostView = nil
    }
}
