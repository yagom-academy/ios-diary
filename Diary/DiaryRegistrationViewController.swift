//
//  DiaryRegistrationViewController.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/18.
//

import UIKit

class DiaryRegistrationViewController: UIViewController {
    
    private let textView = DiaryRegistrationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        textView.setupConstraints(with: view)
        textView.backgroundColor = .yellow
    }
}
