//
//  DetailViewController.swift
//  Diary
//
//  Created by 조성훈 on 2022/06/14.
//

import UIKit

final class DetailViewController: UIViewController {
    private lazy var detailView = DetailView(frame: view.bounds)
    private let diary: Diary
    
    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        detailView.setUpContents(data: diary)
    }
    
    private func setUpNavigationBar() {
        title = diary.createdAt.formattedString
    }
}
