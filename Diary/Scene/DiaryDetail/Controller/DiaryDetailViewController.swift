//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/17.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    // MARK: - properties
    
    private let textView = DiaryDetailTextView()
    private lazy var keyboardManager = KeyboardManager(textView)
    private let diaryData = CoreDataManager()
    private var id: UUID?
    
    // MARK: - life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTextView()
        keyboardManager.addNotificationObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.removeNotificationObserver()
        updateDiary()
    }
    
    // MARK: - functions

    private func updateDiary() {
        let diaryInfomation = textView.text.split(separator: "\n", maxSplits: 1)
        guard let id = id else { return }
        
        if textView.text == "" {
            diaryData.delete(id)
            return
        }
        
        let title = String(diaryInfomation[0])
        let body = getBody(title: title)
        
        let diary = Diary(uuid: id, title: title, body: body, createdAt: Date().timeIntervalSince1970)
        
        diaryData.update(diary: diary)
    }
    
    private func getBody(title: String) -> String {
        guard var text = textView.text else { return "" }
        for _ in 0..<title.count {
            text.removeFirst()
        }
        return text
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
    }
    
    private func setupTextView() {
        if textView.text == Design.emptyString {
            textView.text = Design.textViewPlaceHolder
            textView.textColor = .lightGray
        } else {
            textView.textColor = .black
        }
        
        textView.delegate = self
        textView.setupConstraints(with: view)
        textView.layoutIfNeeded()
    }
}

// MARK: - extensions

extension DiaryDetailViewController: DataSendable {
    func setupData<T>(_ data: T) {
        guard let diaryInformation = data as? DiaryEntity,
              let title = diaryInformation.title,
              let body = diaryInformation.body else { return }
        navigationItem.title = diaryInformation.createdAt.convert1970DateToString()
        id = diaryInformation.uuid ?? UUID()
        textView.text = title + Design.lineBreak + body
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Design.textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count == 0 {
            textView.text = Design.textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}

private enum Design {
    static let emptyString = ""
    static let textViewPlaceHolder = "내용을 입력해주세요"
    static let lineBreak = "\n"
}
