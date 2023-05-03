//
//  DiaryEditViewController.swift
//  Diary
//
//  Created by Christy, vetto on 2023/04/25.
//

import UIKit

final class DiaryEditViewController: UIViewController {
    private let diaryData: DiaryData?
    private var diaryType: DiaryType
    
    private let textView: UITextView = {
        let textView = UITextView()
        
        textView.font = .preferredFont(forTextStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.keyboardDismissMode = .onDrag
        configureText()
        configureUI()
        configureTitle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let (title, body) = divideText(text: textView.text)
        guard let title,
              let body else { return }
        
        switch diaryType {
        case .new:
            CoreDataManger.shared.createDiary(title: title, body: body)
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
    
    init(diaryData: DiaryData? = nil, type: DiaryType = .new) {
        self.diaryData = diaryData
        self.diaryType = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
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
        guard let title = diaryData?.title,
              let body = diaryData?.body else { return }
        textView.text = "\(title)\n\n\(body)"
    }
    
    private func configureTitle() {
        guard let date = diaryData?.createDate else { return }
        navigationItem.title = DateManger.shared.convertToDate(fromDouble: date)
    }
    
    private func divideText(text: String?) -> (title: String?, body: String?) {
        guard let text else { return
            (nil, nil)
        }
        let arr = text.split(separator: "\n").map { String($0) }
        let title = arr[0]
        let bodyArr = arr[1...].map { String($0) }
        let body = bodyArr.joined(separator: "\n")
        
        return (title, body)
    }
    
    private func updateDiary() {
        
    }
}

enum DiaryType {
    case new
    case old
}
