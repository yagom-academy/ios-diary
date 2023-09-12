//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/29.
//

import UIKit
import CoreData

final class DiaryDetailViewController: UIViewController {
    private let diary: Diary
    private var keyboardManager: KeyboardManager?
    
    private let textView: UITextView = {
        let view: UITextView = UITextView()
        view.font = UIFont.systemFont(ofSize: 17.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        view.alwaysBounceVertical = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureUI()
        configureTextView()
        configureLayout()
        setUpKeyboard()
    }
    
    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigation() {
        navigationItem.title = diary.createdAt
        let seeMoreButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .done, target: self, action: #selector(seeMoreButtonTapped))
        navigationItem.rightBarButtonItem = seeMoreButton
    }

    @objc func seeMoreButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showActivityView()
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteButtonTapped()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func deleteButtonTapped() {
        let deleteAlertController = UIAlertController(title: "Really??", message: "Think one more", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            CoreDataManager.shared.delete(diary: self.diary.identifier!)
            self.navigationController?.popViewController(animated: true)
        }
        
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(deleteAction)
        present(deleteAlertController, animated: true)
    }
    
    func showActivityView() {
        let activityViewController = UIActivityViewController(activityItems: ["타이틀 넣어야함"], applicationActivities: nil)
        present(activityViewController, animated: true)
    }

    private func configureUI() {
        view.addSubview(textView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureTextView() {
        textView.delegate = self
        guard let title = diary.title,
              let body = diary.body else {
            return
        }
        
        textView.text = title + body
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

extension DiaryDetailViewController: UITextViewDelegate {
    func updateTitle(by textView: UITextView) -> String {
        let textViewWidth = Int(textView.frame.width)
        let textViewFontSize = 17
        let titleLength: Int = textViewWidth / textViewFontSize
//        print(textViewWidth)
//        print(textViewFontSize)
//        print(titleLength)
        let title = String(textView.text.prefix(Int(titleLength)))
        
        return title
    }
    
    func updateBody(by textView: UITextView) -> String {
        let textViewWidth = Int(textView.frame.width)
        let textViewFontSize = 17
        let startBodyLength: Int = textViewWidth / textViewFontSize
        let endIndex = textView.text.index(textView.text.endIndex, offsetBy: -startBodyLength)
        let body = String(textView.text.suffix(from: endIndex))

        return body
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        <#code#>
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
//        diary.title = updateTitle(by: textView)
//
//        diary.body = updateBody(by: textView)
        guard let text = textView.text else { return }
        let lines = text.components(separatedBy: "\n")
        if lines.count > 0 {
            let title = lines[0]
            diary.title = title
            var content = ""
            if lines.count > 1 {
                for iii in 1..<lines.count {
                    content += lines[iii]
                }
            }
            diary.body = content
        }
        
        print("title = \(String(describing: diary.title))")
        print("body = \(String(describing: diary.body))")
        CoreDataManager.shared.update(newDiary: diary)
    }
}
