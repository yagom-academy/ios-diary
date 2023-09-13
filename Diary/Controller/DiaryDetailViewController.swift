//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/29.
//

import UIKit

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
        let title = diary.title
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: .default) { _ in
            self.showActivityView(title)
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
            guard let identifier = self.diary.identifier else {
                return
            }
            
            CoreDataManager.shared.delete(diary: identifier)
            self.navigationController?.popViewController(animated: true)
        }
        
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(deleteAction)
        present(deleteAlertController, animated: true)
    }
    
    func showActivityView(_ diary: String?) {
        let activityViewController = UIActivityViewController(activityItems: [diary as Any], applicationActivities: nil)
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
        
        textView.text = title + "\n" + body
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
    func textViewDidEndEditing(_ textView: UITextView) {
        var body = ""
        
        guard let text = textView.text,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        let lines = text.components(separatedBy: "\n")
        diary.title = lines[0]
        
        if lines.count > 1 {
            for line in 1..<lines.count {
                body = body + lines[line] + "\n"
            }
        }
        
        diary.body = body
        CoreDataManager.shared.saveContext()
    }
}
