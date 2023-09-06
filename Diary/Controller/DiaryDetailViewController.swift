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
        textView.delegate = self

    }
    
    init(uuid: String) {
        self.uuid = uuid
        self.fetchRequest = CoreDataManager.shared.receivePredicateData(uuid: uuid)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureNavigation() {
        navigationItem.title = "aa"
    }
    
    private func configureUI() {
        view.addSubview(textView)
        view.backgroundColor = .systemBackground
    }
    
    private func configureTextView() {
        do {
            let data = try CoreDataManager.shared.context.fetch(fetchRequest)
            textView.text = data.first?.body
        } catch {
            print(error)
        }
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
        do {
            let data = try CoreDataManager.shared.context.fetch(fetchRequest)
            data.first?.body = textView.text
            saveCoreData()
        } catch {
            print(error)
        }
    }
    
    func saveCoreData() {
        do {
            try CoreDataManager.shared.context.save()
            print("success")
        } catch {
            print(error.localizedDescription)
        }
    }
}

