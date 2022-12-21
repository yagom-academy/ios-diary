//  Diary - DiaryViewController.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryView = DiaryView(frame: .zero)
    private var diary: Diary

    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = diary.date
    }
}
