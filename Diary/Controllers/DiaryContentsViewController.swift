//
//  DiaryContentsViewController.swift
//  Diary
//
//  Created by Toy, Morgan on 1/3/24.
//

import UIKit

final class DiaryContentsViewController: UIViewController {
    
    private let textTitle = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    private let textBody = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
    private let textStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }
    
    var dateTitleLabel: String?
    var diaryTitle: String?
    var body: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
