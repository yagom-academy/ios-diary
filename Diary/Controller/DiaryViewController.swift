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

    init(diary: Diary?) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryView
    private func configureDiaryView() {
        guard let diary = diary else {
            return
        }

        diaryView.configureContents(diary: diary)
    }
}
