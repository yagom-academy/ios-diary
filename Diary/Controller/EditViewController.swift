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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveDiary()
    }
    
    private func setInitialView() {
        if let createdAt = diary?.createdAt {
            self.title = Date(timeIntervalSince1970: createdAt).dateToKoreanString
            configureDiaryView()
        }
    }

    private func configureDiaryView() {
        guard let diary = diary else {
            return
        }
        
        diaryView.configureContents(diary: diary)
    }
}
