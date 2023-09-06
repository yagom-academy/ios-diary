//
//  NewDiaryViewController.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/30.
//

import UIKit
import CoreData

final class NewDiaryViewController: UIViewController {
    private var keyboardManager: KeyboardManager?
    private var today: String = ""
    
    private let textView: UITextView = {
        let view: UITextView = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        view.alwaysBounceVertical = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        configureLayout()
        configureTextView()
        setUpKeyboard()
    }
    
    private func configureNavigation() {
        navigationItem.title = DateFormatter.today
        today = DateFormatter.today
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
    
    private func configureTextView() {
        textView.delegate = self
    }
    
    private func setUpKeyboard() {
        keyboardManager = KeyboardManager(textView: textView)
    }
}

extension NewDiaryViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        CoreDataManager.shared.createDiary(textView)
    }
}
