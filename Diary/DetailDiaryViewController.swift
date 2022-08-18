//
//  DetailDiaryViewController.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/18.
//

import UIKit

class DetailDiaryViewController: UIViewController {
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.translatesAutoresizingMaskIntoConstraints = false

        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = DateFormatter().format(data: Date())
        self.view.addSubview(textView)
        configureUI()
        
    }
    
    private func configureUI() {
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
