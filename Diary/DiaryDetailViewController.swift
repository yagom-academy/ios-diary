//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/21.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private var diary: Diary?
    
    init(diary: Diary) {
        super.init(nibName: nil, bundle: nil)
        self.diary = diary
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = DiaryDetailView()
        setupNavigationBar()
    }

}

extension DiaryDetailViewController {
    private func setupNavigationBar() {
        self.navigationItem.title = diary?.createdDate
    }
}
