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
    var diaryListView: DiaryListViewController?
    var diaryContentView: DiaryContentViewController?
    var diaryPostView: DiaryPostViewController?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        self.viewModel = SpyDiaryContentViewModel()
        self.diaryListView = DiaryListViewController(viewModel: viewModel!)
        self.diaryContentView = DiaryContentViewController()
        self.diaryContentView?.diaryViewModel = viewModel
        self.diaryPostView = DiaryPostViewController()
        self.diaryPostView?.diaryViewModel = viewModel
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewModel = nil
        diaryListView = nil
        diaryContentView = nil
        diaryPostView = nil
    }
}
