//
//  NewDiaryViewController.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

import UIKit

final class NewDiaryViewController: UIViewController {
    private let textView: UITextView = {
        let view: UITextView = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var keyboardManager: KeyboardManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        configureLayout()
        setUpKeyboard()
    }

    private func configureNavigation() {
        navigationItem.title = DateFormatter.today
    }
    
    private func configureUI() {
        view.addSubview(textView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setUpKeyboard() {
        keyboardManager = KeyboardManager(textView: textView)
    }
}
