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
        static let moreButton = "더보기"
        static let separator = "\n"
    }
    
    private let textView = UITextView()
    private var keyboard: Keyboard?
    private let diaryData: DiaryDTO?
    private var isSavingData = false
    
    private var date: String {
        return navigationItem.title ?? ""
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
        setUpTextView()
        setUpTextViewLayout()
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
        textView.delegate = self
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
        
        if let diaryData = diaryData {
            setUpEditPage(diaryData: diaryData)
        }
    }
    
    private func setUpEditPage(diaryData: DiaryDTO) {
        setUpNavigationController(title: diaryData.dateString)
        textView.text = "\(diaryData.title)\(Const.separator)\(diaryData.body)"
    }
    
    private func setUpNavigationController(title: String) {
        func setUpRightButton() {
            let button = UIBarButtonItem(
                title: Const.moreButton,
                style: .plain,
                target: self,
                action: #selector(touchUpMoreButton)
            )
            navigationItem.rightBarButtonItem = button
        }
        
        if diaryData != nil {
            setUpRightButton()
        }
        
        navigationItem.title = title
    }
    
    @objc private func touchUpMoreButton() {
        guard let title = textView.title else {
            return
        }
        
        let shareSheetAction = makeAction(title: "Share", style: .default) { [weak self] in
            self?.showActivity(title: title)
        }
        
        let deleteAction = makeAction(title: "Delete", style: .destructive) { [weak self] in
            DiaryDAO.shared.delete(identifier: self?.diaryData?.identifier.uuidString)
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancel = makeAction(title: "Cancel", style: .cancel)
        
        let deleteSheetAction = makeAction(title: "Delete", style: .destructive) { [weak self] in
            self?.showAlert(title: "진짜요?", message: "진짜로 삭제 하시겠어요?", actions: [deleteAction, cancel])
        }
        
        showActionSheet(actions: [shareSheetAction, deleteSheetAction, cancel])
    }
    
    private func saveData() {
        guard let title = textView.title,
              let date = Formatter.getDate(from: date) else {
            return
        }
        
        let isNew = diaryData == nil
        
        let data = DiaryDTO(identifier: diaryData?.identifier,
                            title: title,
                            body: textView.body,
                            date: date)
        
        if isSavingData == false {
            DiaryDAO.shared.save(data, isNew: isNew)
            isSavingData = true
        }
    }
    
    private func setUpTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.becomeFirstResponder()
    }
    
    private func setUpTextViewLayout() {
        view.addSubview(textView)
        
        let bottomContraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomContraint
        ].compactMap { $0 })
        
        keyboard = Keyboard(bottomContraint: bottomContraint, textView: textView)
    }
}

extension UpdateViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveData()
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

private extension UITextView {
    var title: String? {
        let text = self.text.components(separatedBy: "\n")
        return text.first == "" ? nil : text.first
    }
    
    var body: String {
        let splitedText = self.text.split(separator: "\n", maxSplits: 1)
        let body = splitedText.map { String($0) }
        return body[safe: 1] ?? ""
    }
}
