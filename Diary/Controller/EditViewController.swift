//
//  EditViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/20.
//

import UIKit

final class EditViewController: DiaryViewController {
    private var diary: DiaryModel?
    
    init(diary: DiaryModel?) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        update(setTestData())
        delegate?.updateView()
    }
    
    private func setInitialView() {
        if let createdAt = diary?.createdAt {
            self.title = Date(timeIntervalSince1970: createdAt).dateToKoreanString
            configureDiaryView()
        }
    }
    
    private func setTestData() -> TestData? {
        var textArray = diaryView.diaryTextView.text.components(separatedBy: "\n")
        guard let id = diary?.id else {
            return nil
        }
        return TestData(title: textArray.removeFirst(), body: textArray.joined(separator: "\n"), createdAt: Date().timeIntervalSince1970, id: id)
    }
    
    private func configureDiaryView() {
        guard let diary = diary else {
            return
        }
        
        diaryView.configureContents(diary: diary)
    }
}
