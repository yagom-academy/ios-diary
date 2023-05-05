//
//  DiaryEditViewController.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/25.
//

import UIKit
import Foundation

final class DiaryEditViewController: UIViewController {
    private var diaryData: DiaryData?
    private var diaryType: DiaryType
    
    private let textView: UITextView = {
        let textView = UITextView()
        
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(diaryData: DiaryData? = nil, type: DiaryType = .new) {
        self.diaryData = diaryData
        self.diaryType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureText()
        configureTitle()
        setupNotification()
        showKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        autoSaveDiary()
    }

    private func configureUI() {
        let image = UIImage(systemName: "ellipsis.circle")
        let navigationRightButton = UIBarButtonItem(image: image,
                                                    style: .plain,
                                                    target: self,
                                                    action: #selector(ellipsisButtonTapped))
        navigationItem.rightBarButtonItem = navigationRightButton
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureText() {
        guard let title = diaryData?.title else { return }
        
        if let body = diaryData?.body {
            textView.text = "\(title)\n\(body)"
        } else {
            textView.text = title
        }
    }
    
    private func configureTitle() {
        guard let date = diaryData?.createDate else { return }
        navigationItem.title = DateManger.shared.convertToDate(fromDouble: date)
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveDiary),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(saveDiary),
                                               name: UIApplication.keyboardDidHideNotification,
                                               object: nil)
    }
    
    private func showKeyboard() {
        if diaryType == .new {
            textView.becomeFirstResponder()
        }
    }
    
    private func divide(text: String?) -> (title: String, body: String?) {
        guard let text = textView.text,
              let spacingIndex = text.firstIndex(of: "\n") else {
            return (text!, nil)
        }
        let spacingNextIndex = text.index(after: spacingIndex)
        let title = String(text[..<spacingIndex])
        let body = String(text[spacingNextIndex...])
        
        return (title, body)
    }

    @objc
    private func ellipsisButtonTapped() {
        textView.resignFirstResponder()
        
        AlertManager().showActionSheet(target: self) { [weak self] in
            guard let self,
                  let id = self.diaryData?.id else { return }
            AlertManager().showAlert(target: self) {
                CoreDataManger.shared.deleteDiary(id: id)
                self.navigationController?.popViewController(animated: true)
            }
        } shareCompletion: { [weak self] in
            guard let self else { return }
            ActivityViewManager().showActivityView(target: self)
        }
    }
    
    @objc
    private func saveDiary() {
        autoSaveDiary()
    }
    
    private func autoSaveDiary() {
        let (title, body) = divide(text: textView.text)
        
        switch diaryType {
        case .new:
            let diary = CoreDataManger.shared.createDiary(title: title, body: body)
            self.diaryData = diary
            self.diaryType = .old
        case .old:
            guard let date = diaryData?.createDate,
                  let id = diaryData?.id else { return }
            CoreDataManger.shared.updateDiary(id: id,
                                              title: title,
                                              createDate: date,
                                              body: body)
        }
    }
}
