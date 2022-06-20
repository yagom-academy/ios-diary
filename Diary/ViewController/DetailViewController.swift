//
//  DetailViewController.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

final class DetailViewController: UIViewController {
    private lazy var detailView = DetailView(frame: view.frame)
    private let diaryData: DiaryModel
    
    init(diaryData: DiaryModel) {
        self.diaryData = diaryData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view = detailView
        super.viewDidLoad()
        setNavigationBarTitle()
        detailView.setUpView(diaryData: diaryData)
    }
    
    private func setNavigationBarTitle() {
        navigationItem.title = diaryData.createdAt?.formattedDate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.detailView.mainScrollView.contentSize = .init(width: self.detailView.mainScrollView.frame.width, height: self.detailView.mainScrollView.frame.height + keyboardSize.height - 140)
            
            if self.detailView.descriptionView.isFirstResponder {
                detailView.mainScrollView.scrollRectToVisible(detailView.descriptionView.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.detailView.mainScrollView.contentSize = .init(width: self.detailView.mainScrollView.frame.width, height: self.detailView.mainScrollView.frame.height - keyboardSize.height + 140)
        }
    }
}
