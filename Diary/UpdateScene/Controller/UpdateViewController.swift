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

final class UpdateViewController: UIViewController {
    enum Const {
        static let moreButton = "더보기"
        static let separator = "\n"
    }
    
    private let textView = UITextView()
    private var keyboard: Keyboard?
    private let diaryData: DiaryDTO?
    private var isSavingData = false
    
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
        setUpTextViewLayout()
        
        keyboard?.setUpKeyboard()
        showKeyboard()
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
        guard let title = textView.extractData(date: navigationItem.title)?.title,
              let identifier = diaryData?.identifier else {
            return
        }
        
        showActionSheet(shareTitle: title, identifer: identifier) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func saveData() {
        guard isSavingData == false,
              let (title, body, date) = textView.extractData(date: navigationItem.title) else {
            return
        }
        
        isSavingData = true
        
        if let identifier = diaryData?.identifier {
            let edittedData = DiaryDTO(
                identifier: identifier,
                title: title,
                body: body,
                date: date
            )
            
            DiaryDAO.shared.update(userData: edittedData)
        } else {
            let newData = DiaryDTO(
                title: title,
                body: body,
                date: date
            )
            
            DiaryDAO.shared.create(userData: newData)
        }
    }
    
    private func setUpTextViewLayout() {
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomContraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomContraint
        ].compactMap { $0 })
        
        keyboard = Keyboard(bottomContraint: bottomContraint, textView: textView)
    }
    
    private func showKeyboard() {
        textView.becomeFirstResponder()
    }
}

extension UpdateViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveData()
    }
}

private extension UITextView {
    enum Const {
        static let separator: Character = "\n"
        static let defaultBody = ""
    }
    
    func extractData(date: String?) -> (title: String, body: String, date: Date)? {
        guard let date = date else {
            return nil
        }
        
        let splitedText = text.split(separator: Const.separator, maxSplits: 1).map {
            String($0)
        }
        
        let body: String
        
        switch splitedText.count {
        case 1:
            body = Const.defaultBody
        case 2:
            guard let lastText = splitedText.last else {
                return nil
            }
            
            body = lastText
        default:
            return nil
        }
        
        guard let title = splitedText.first,
              let date = Formatter.getDate(from: date) else {
            return nil
        }
        
        return (title, body, date)
    }
}
