//
//  DiaryViewController.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import UIKit

final class DiaryViewController: UIViewController {
    private lazy var diaryView = DiaryView.init(frame: view.bounds)
    private var diary: Diary?

    enum DiaryViewType {
        case add
        case edit
    }
    
    private var diaryViewType: DiaryViewType = .add
    
    init(diary: Diary?, type: DiaryViewType) {
        self.diary = diary
        self.diaryViewType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryView

        if diaryViewType == .add {
            self.title = DateConverter.changeDateFormat(Date())
        } else {
            self.title = diary?.createdAt ?? ""
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
