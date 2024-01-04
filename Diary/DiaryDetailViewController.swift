//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Hisop on 2024/01/03.
//

import UIKit

class DiaryDetailViewController: UIViewController {
    private var textView = UITextView()
    private var diaryDetail: Diary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUI()
    }
    
    func forwardingDiaryData(diary: Diary) {
        diaryDetail = diary
    }
}

extension DiaryDetailViewController {
    private func configureUI() {
        self.view.addSubview(textView)
        
        navigationItemInit()
        autoLayoutInit()
    }
    
    private func navigationItemInit() {
        
        
        self.navigationItem.title = "YY년 MM월 DD일"
    }
    
    }
    
    private func autoLayoutInit() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
