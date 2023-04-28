//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    private let contents: Contents?
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()
    
    init(contents: Contents?) {
        self.contents = contents
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 16.0, *) {
            configureUIOption()
        }
        
        configureLayout()
    }
    
    private func configureLayout() {
        view.addSubview(textView)
        textView.contentOffset = .zero
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        NSLayoutConstraint.activate([
            view.keyboardLayoutGuide.topAnchor.constraint(equalTo: textView.bottomAnchor),
            
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    @available(iOS 16.0, *)
    private func configureUIOption() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = contents?.localizedDate ?? Date().translateLocalizedFormat()
        
        let backAction = UIAction(title: "back") { [weak self] _ in
            guard let contents = self?.contents else { return }
            
            CoreDataManager.shared.createContents(contents)
            self?.navigationController?.popToRootViewController(animated: true)
        }

        navigationItem.backAction = backAction
        
        if let contents {
            textView.text = """
            \(contents.title)
            
            \(contents.body)
            """
        } else {
            textView.text = nil
        }
    }
}
