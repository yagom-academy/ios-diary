//
//  UpdateViewController.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import UIKit

protocol BackGroundDelegate: AnyObject {
    func updateCoredata()
}

extension UpdateViewController: BackGroundDelegate {
    func updateCoredata() {
        saveData()
    }
}

final class UpdateViewController: UIViewController, DiaryProtocol {
    enum Const {
        static let separator = "\n"
    }
    private lazy var textView = DiaryTextView(delegate: self)
    
    private let diaryData: DiaryDTO?
    private var isSavingData = false
    
    private var date: String {
        return navigationItem.title ?? ""
    }
    
    var textViewAndDiaryData: (DiaryTextView, DiaryDTO?) {
        return (textView, diaryData)
    }
    
    init(diaryData: DiaryDTO? = nil) {
        self.diaryData = diaryData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpDelegate()
        setUpView()
        setUpNavigationController(title: Formatter.getCurrentDate())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveData()
    }
    
    private func setUpDelegate() {
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        scene.delegate = self
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(textView)
        textView.setUpTextViewLayout(view: view)
        
        if let diaryData = diaryData {
            setUpEditPage(diaryData: diaryData)
        }
    }
    
    private func setUpEditPage(diaryData: DiaryDTO) {
        setUpNavigationController(title: diaryData.dateString)
        textView.text = "\(diaryData.title)\(Const.separator)\(diaryData.body)"
    }
    
    private func setUpNavigationController(title: String) {
        navigationController?.setUpNavigationController(title: title,
                                                        diaryData: diaryData,
                                                        viewController: self)
    }
    
    private func saveData() {
        guard let title = textView.title,
              let date = Formatter.getDate(from: date) else {
            return
        }
        let body = textView.body
        let isNew = diaryData == nil
        
        let data = DiaryDTO(identifier: diaryData?.identifier,
                            title: title,
                            body: body,
                            date: date)
        
        if isSavingData == false {
            DiaryDAO.shared.save(data, isNew: isNew)
            isSavingData = true
        }
    }
}

extension UpdateViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveData()
    }
}

extension UINavigationController: DiaryProtocol {
    private enum Const {
        static let moreButton = "더보기"
    }
        
    func setUpNavigationController(title: String, diaryData: DiaryDTO?, viewController: UIViewController) {
        func setUpRightButton() {
            let button = UIBarButtonItem(
                title: Const.moreButton,
                style: .plain,
                target: self,
                action: #selector(touchUpMoreButton)
            )
            viewController.navigationItem.rightBarButtonItem = button
        }
        
        if diaryData != nil {
            setUpRightButton()
        }
        
        viewController.navigationItem.title = title
    }
    
    @objc private func touchUpMoreButton() {
        guard let viewController = viewControllers.last as? UpdateViewController else {
            return
        }
        
        let (textView, diaryData) = viewController.textViewAndDiaryData
        
        guard let title = textView.title else {
            return
        }
        
        let shareSheetAction = makeAction(title: "Share", style: .default) { [weak self] in
            self?.showActivity(title: title)
        }
        
        let deleteAction = makeAction(title: "Delete", style: .destructive) { [weak self] in
            DiaryDAO.shared.delete(identifier: diaryData?.identifier.uuidString)
            self?.popViewController(animated: true)
        }
        
        let cancel = makeAction(title: "Cancel", style: .cancel)
        
        let deleteSheetAction = makeAction(title: "Delete", style: .destructive) { [weak self] in
            self?.showAlert(title: "진짜요?", message: "진짜로 삭제 하시겠어요?", actions: [deleteAction, cancel])
        }
        
        showActionSheet(actions: [shareSheetAction, deleteSheetAction, cancel])
    }
}
