//
//  DiaryContentViewController.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/26.
//

import UIKit

final class DiaryContentViewController: UIViewController {
    typealias DiaryText = (title: String?, body: String?)
    
    private var diary: Diary?
    private let textView = UITextView()
    private let alertFactory: AlertFactoryService = AlertMaker()
    private let alertDataMaker: AlertDataService = AlertViewDataMaker()

    init(diary: Diary? = nil) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRootView()
        setUpNavigationBar()
        setUpTextView()
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showKeyboardIfNeeded()
        createDiaryIfNeeded()
    }
    
    private func setUpRootView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
    }
    
    private func setUpNavigationBar() {
        let timeInterval = diary?.date ?? Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timeInterval)
        let image = UIImage(systemName: "ellipsis.circle")
        
        navigationItem.title = DateFormatter.diaryForm.string(from: date)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(tapEllipsisButton))
    }
    
    private func setUpTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        setUpTextViewLayout()
        configureTextViewContent()
    }
    
    private func configureTextViewContent() {
        guard let diary = diary else { return }
        
        if let title = diary.title, let body = diary.body {
            textView.text = title + body
        } else {
            textView.text = diary.title
        }
        
    }
    
    private func setUpTextViewLayout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            textView.topAnchor.constraint(equalTo: safe.topAnchor),
            textView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(noti:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc
    private func keyboardWillShow(noti: NSNotification) {
        guard let keyboardSize = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        textView.contentInset.bottom = keyboardHeight
        textView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc
    private func keyboardWillHide() {
        textView.contentInset.bottom = .zero
        textView.verticalScrollIndicatorInsets.bottom = .zero
        
        updateDiary()
    }
    
    func updateDiary() {
        guard let id = diary?.id else { return }
        
        let devidedContents: DiaryText = devide(text: textView.text)
        let updatedDate = Date().timeIntervalSince1970

        DiaryCoreDataManager.shared.updateDiary(title: devidedContents.title,
                                                body: devidedContents.body,
                                                date: updatedDate,
                                                id: id)
    }
    
    private func devide(text: String?) -> DiaryText {
        guard let text,
              let newLineIndex = text.firstIndex(of: "\n") else { return (text, nil) }
        
        let startIndex = text.startIndex
        let titleRange = startIndex..<newLineIndex
        let bodyRange = newLineIndex...
        let title = String(text[titleRange])
        let body = String(text[bodyRange])
        
        return (title, body)
    }
    
    private func showKeyboardIfNeeded() {
        if diary == nil {
            textView.becomeFirstResponder()
        }
    }
    
    private func createDiaryIfNeeded() {
        if diary == nil {
            let createdDate = Date().timeIntervalSince1970
            
            diary = DiaryCoreDataManager.shared.createDiary(title: "",
                                                            body: "",
                                                            date: createdDate,
                                                            id: UUID())
        }
    }
    
    @objc
    private func tapEllipsisButton() {
        presentActionSheet()
    }
    
    private func presentActionSheet() {
        let share = AlertActionData(actionTitle: "Share...",
                                    actionStyle: .default,
                                    completion: presentActivityView)
        let delete = AlertActionData(actionTitle: "Delete",
                                     actionStyle: .destructive,
                                     completion: presentDeleteAlert)
        let cancel = AlertActionData(actionTitle: "Cancel",
                                     actionStyle: .cancel,
                                     completion: nil)
        let actionDataList = [share, delete, cancel]
        
        let alertData = alertDataMaker.makeData(alertStyle: .actionSheet, actionDataList: actionDataList)
        let alertController = alertFactory.make(for: alertData)
        
        present(alertController, animated: true)
    }
    
    private func presentActivityView() {
        guard let text = textView.text else { return }
        
        let activityView = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        self.present(activityView, animated: true)
    }
    
    private func deleteDiary() {
        guard let id = diary?.id else { return }
        
        DiaryCoreDataManager.shared.deleteDiary(id: id)
        diary = nil
        navigationController?.popViewController(animated: true)
    }
    
    private func presentDeleteAlert() {
        let delete = AlertActionData(actionTitle: "삭제",
                                     actionStyle: .destructive,
                                     completion: deleteDiary)
        let cancel = AlertActionData(actionTitle: "취소",
                                     actionStyle: .cancel,
                                     completion: nil)
        let actionDataList = [delete, cancel]
        let alertData = alertDataMaker.makeData(title: "진짜요?",
                                                message: "정말로 삭제하시겠어요?",
                                                alertStyle: .alert,
                                                actionDataList: actionDataList)
        let alertController = alertFactory.make(for: alertData)
        
        present(alertController, animated: true)
    }
}
