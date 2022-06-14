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
        detailView.scrollToTop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardHideShow),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        if let keyboardSize = (keyboardInfo as? NSValue)?.cgRectValue {
            detailView.baseTextView.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc func keyboardHideShow(notification: NSNotification) {
        detailView.baseTextView.contentInset = .zero
    }
    
    private func setUpNavigationBar() {
        title = diary.createdAt.formattedString
    }
}
