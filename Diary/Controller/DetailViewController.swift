//
//  DetailViewController.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
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
        detailView.scrollTextViewToTop()
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
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setUpNavigationBar() {
        title = diary.createdAt.formattedString
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            return
        }
        let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
        if let keyboardSize = (keyboardInfo as? NSValue)?.cgRectValue {
            detailView.baseTextView.contentInset.bottom = keyboardSize.height
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        detailView.baseTextView.contentInset = .zero
    }
}
