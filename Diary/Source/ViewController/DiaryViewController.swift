//  Diary - DiaryViewController.swift
//  Created by Ayaan, zhilly on 2022/12/21

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryView = DiaryView(frame: .zero)
    private var diary: Diary?

    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        diaryView.setupScrollViewDelegate(scrollViewDelegate: self)
    }
    
    private func configure() {
        title = diary?.date
        diaryView.setupData(of: diary)
    }
}

extension DiaryViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        if velocity.y < -2 {
            diaryView.endEditing(true)
        }
    }
}
