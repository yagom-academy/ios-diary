//
//  DiaryViewController.swift
//  Diary
//
//  Created by Redmango, Minsup on 2023/08/30.
//

import UIKit

final class DiaryViewController: UIViewController {
    
    // MARK: - Private Property
    
    private let dataManager: DataManager
    private let diary: Diary?
    private let isNew: Bool
    private var textView = UITextView()
    private let compositor: DiaryContentComposable
    private let segregator: DiaryContentSegregatable
    private let currentFormatter: DateFormattable
    
    // MARK: - Lifecycle
    
    init(dataManager: DataManager,
         formatter: DateFormattable,
         diary: Diary? = nil
    ) {
        self.dataManager = dataManager
        self.currentFormatter = formatter
        
        if diary == nil {
            self.diary = Diary(context: dataManager.container.viewContext)
            self.isNew = true
        } else {
            self.diary = diary
            self.isNew = false
        }
        
        self.compositor = DiaryContentCompositor()
        self.segregator = DiaryContentSegregator()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureTextView()
        configureKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateDiary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNew {
            textView.becomeFirstResponder()
        }
    }
    
    // MARK: - CRUD
    
    private func updateDiary() {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else { return }
        
        let text = segregator.segregate(text: trimmedText)
        self.diary?.title = text.title
        self.diary?.content = text.content
        self.diary?.createdDate = Date()
        
        dataManager.saveContext()
    }
    
    // MARK: - Private Method(Navigation)
    
    private func configureNavigation() {
        let date = currentFormatter.format(date: diary?.createdDate ?? Date())
        
        self.navigationItem.title = date
        
    }
    
    private func setupNavigationToolbar() {
        let infoButton = UIBarButtonItem(title: "더보기", style: .plain, target: self, action: #selector(tapOptionButton))
        
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func tapOptionButton() {
        let actionSheet = configureActionSheet()
        present(actionSheet, animated: true)
    }
    
    private func configureActionSheet() -> UIAlertController {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction(title: "Share", style: .default) {_ in
            
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let diary = self?.diary else {
                return
            }
            
            self?.dismiss(animated: true)
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
        actionSheet.addAction(share)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        return actionSheet
    }
    
    
    // MARK: - Private Method(TextView)
    
    private func configureTextView() {
        setupTextView()
        constraintTextView()
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        textView.text = compositor.composite(title: diary?.title, content: diary?.content)
        textView.font = UIFont.preferredFont(forTextStyle: .body)
    }
    
    private func constraintTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Private Method(Keyboard)
    
    private func configureKeyboard() {
        setupKeyboardToolbar()
        registerNotification()
    }
    
    private func setupKeyboardToolbar() {
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let keyboardHideButton = UIBarButtonItem(image: UIImage(systemName: "keyboard.chevron.compact.down"), style: .plain, target: self, action: #selector(endEditing))
        toolbar.items = [space, keyboardHideButton]
        toolbar.sizeToFit()
        textView.inputAccessoryView = toolbar
    }
    
    @objc private func endEditing() {
        self.textView.endEditing(true)
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keybordWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keybordWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.size.height
            textView.contentInset.bottom = keyboardHeight
        }
    }
    
    @objc private func keybordWillHide() {
        textView.contentInset = .zero
        updateDiary()
    }
}
