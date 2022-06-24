//
//  EditViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/20.
//

import UIKit

final class EditViewController: DiaryViewController {
    init(diary: Diary?) {
        super.init(nibName: nil, bundle: nil)
        self.diary = diary
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitialView()
    }

    private func setInitialView() {
        guard let createdAt = diary?.createdAt else {
            return
        }
        
        self.title = Date(timeIntervalSince1970: createdAt).dateToKoreanString
        configureDiaryView()
    }

    private func configureDiaryView() {
        guard let diary = diary else {
            return
        }
        
        diaryView.configureContents(diary: diary)
    }
}
