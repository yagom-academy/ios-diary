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
    private var uuid: String
    private let fetchRequest: NSFetchRequest<Diary>
    
    private let textView: UITextView = {
        let view: UITextView = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.keyboardDismissMode = .interactive
        view.alwaysBounceVertical = true
        
        return view
    }()
    
    init(uuid: String) {
        self.uuid = uuid
        self.fetchRequest = CoreDataManager.shared.receiveFetchRequest(for: uuid)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        let seeMoreButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .done, target: self, action: #selector(seeMoreButtonTapped))
        navigationItem.rightBarButtonItem = seeMoreButton
        today = DateFormatter.today
        
    }
    
    @objc func seeMoreButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
        
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
        CoreDataManager.shared.fetchDiary(fetchRequest).first?.body = textView.text
        CoreDataManager.shared.saveContext()
    }
}
