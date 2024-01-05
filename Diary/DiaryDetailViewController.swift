//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Hisop on 2024/01/03.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let textView = UITextView()
    private var diaryDetail: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        textView.keyboardDismissMode = .interactive
    }
    
    func forwardingDiaryData(diary: Diary) {
        diaryDetail = diary
    }
}

extension DiaryDetailViewController {
    private func configureUI() {
        self.view.addSubview(textView)
        
        if let diary = diaryDetail {
            textView.text = (diary.title) + "\n\n" + (diary.body)
        }

        navigationItemInit()
        autoLayoutInit()
    }
    
    private func navigationItemInit() {
        guard let date = diaryDetail?.createdAt else {
            return
        }
        
        let dateFormatter = DateFormatter()
        let title = Date(timeIntervalSince1970: TimeInterval(date))
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        self.navigationItem.title = dateFormatter.string(from: title)
    }
    
    private func autoLayoutInit() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textView.bottomAnchor)
        ])
    }
}
