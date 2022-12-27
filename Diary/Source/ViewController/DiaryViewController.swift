//  Diary - DiaryViewController.swift
//  Created by Ayaan, zhilly on 2022/12/21

import UIKit

final class DiaryViewController: UIViewController {
    private enum Constant {
        static let endEditingVelocity = -2.0
    }
    
    private let diaryView = DiaryView(frame: .zero)
    private var diary: Diary

    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        diaryView.setupScrollViewDelegate(scrollViewDelegate: self)
        diaryView.setupBodyTextViewDelegate(textViewDelegate: self)
    }
    
    private func configure() {
        title = DateFormatter.converted(date: diary.createAt,
                                        locale: Locale.preference,
                                        dateStyle: .long)
        diaryView.setupData(of: diary)
    }
}

extension DiaryViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        if velocity.y < Constant.endEditingVelocity {
            diaryView.endEditing(true)
        }
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        if let diaryTextView = textView as? DiaryTextView {
            diaryTextView.configurePlaceholder()
        }
    }
}
