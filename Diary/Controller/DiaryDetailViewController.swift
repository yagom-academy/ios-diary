//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/29.
//

import UIKit
import CoreData

final class DiaryDetailViewController: UIViewController {
    private var uuid: String
    private var keyboardManager: KeyboardManager?
    var fetchRequest: NSFetchRequest<Diary>
    
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
        configureTextView()
        configureLayout()
        setUpKeyboard()
    }
    
    init(uuid: String) {
        self.uuid = uuid
        self.fetchRequest = CoreDataManager.shared.receiveFetchRequest(for: uuid)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigation() {
        navigationItem.title = CoreDataManager.shared.fetchDiary(fetchRequest).first?.createdAt
        let seeMoreButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .done, target: self, action: #selector(seeMoreButtonTapped))
        navigationItem.rightBarButtonItem = seeMoreButton
        
    }
    
    @objc func seeMoreButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let shareAction = UIAlertAction(title: "Share", style: .default, handler: { action in
            self.showActivityView()
        })
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(shareAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    private func showActivityView() {
        let activityViewController = UIActivityViewController(activityItems: ["테스트1", "테스트2"], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    private func configureUI() {
        view.addSubview(textView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureTextView() {
        textView.delegate = self
        textView.text = CoreDataManager.shared.fetchDiary(fetchRequest).first?.body
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
        CoreDataManager.shared.fetchDiary(fetchRequest).first?.body = textView.text
        CoreDataManager.shared.saveContext()
    }
}
