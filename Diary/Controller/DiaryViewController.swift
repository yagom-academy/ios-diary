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
    private let diary: Diary
    private let textView = UITextView()
    private let compositor: DiaryContentComposable
    private let segregator: DiaryContentSegregatable
    private let currentFormatter: DateFormattable
    private let weatherFetcher: WeatherFetcher
    
    // MARK: - Lifecycle
    
    init(dataManager: DataManager,
         formatter: DateFormattable,
         diary: Diary? = nil
    ) {
        self.dataManager = dataManager
        self.currentFormatter = formatter
        self.compositor = DiaryContentCompositor()
        self.segregator = DiaryContentSegregator()
        self.weatherFetcher = WeatherFetcher()
        
        if let diary = diary {
            self.diary = diary
        } else {
            self.diary = Diary(context: dataManager.container.viewContext)
        }
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
        configureSceneLifecycle()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateDiary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.textView.text.isEmpty {
            textView.becomeFirstResponder()
            self.weatherFetcher.fetch { pngData in
                self.diary.weatherImage = pngData
            }
        }
    }
    
    // MARK: - CRUD
    
    private func updateDiary() {
        let trimmedText = self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            self.dataManager.delete(self.diary)
            return
        }
        
        let text = self.segregator.segregate(text: trimmedText)
        
        self.diary.title = text.title
        self.diary.content = text.content
        self.diary.createdDate = diary.createdDate ?? Date()
        
        dataManager.saveContext()
    }
    
    // MARK: - Private Method(Navigation)
    
    private func configureNavigation() {
        setupNavigationTitle()
        setupNavigationToolbar()
    }
    
    private func setupNavigationTitle() {
        let date = currentFormatter.format(date: self.diary.createdDate ?? Date(), style: .long)
        self.navigationItem.title = date
    }
    
    private func setupNavigationToolbar() {
        let infoButton = UIBarButtonItem(
            title: "더보기",
            style: .plain,
            target: self,
            action: #selector(tapOptionButton)
        )
        
        self.navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc private func tapOptionButton() {
        let alertController = configureAlertController()
        present(alertController, animated: true)
    }
    
    // MARK: - Private Method(Alert)
    
    private func configureAlertController() -> UIAlertController {
        let alertController = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        let share = shareAction()
        let delete = deleteAction()
        let cancel = UIAlertAction(title: "cancel", style: .cancel)
        
        alertController.addAction(share)
        alertController.addAction(delete)
        alertController.addAction(cancel)
        
        return alertController
    }
    
    private func shareAction() -> UIAlertAction {
        return UIAlertAction(
            title: "Share",
            style: .default,
            handler: { [weak self]  _ in
                guard let diaryContent = self?.compositor.composite(
                    title: self?.diary.title,
                    content: self?.diary.content
                ) else { return }
                
                let activityView = UIActivityViewController(
                    activityItems: [diaryContent],
                    applicationActivities: nil
                )
                
                self?.present(activityView, animated: true)
            }
        )
    }
    
    private func deleteAction() -> UIAlertAction {
        return UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: { [weak self] _ in
                if let self = self {
                    self.deleteDiaryAlert(diary: self.diary)
                }
            }
        )
    }
    
    private func deleteDiaryAlert(diary: Diary) {
        let deleteAlert = UIAlertController(
            title: "진짜요?",
            message: "정말로 삭제하시겠어요?",
            preferredStyle: .alert
        )
        
        let delete = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            self?.dataManager.delete(diary)
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        deleteAlert.addAction(cancel)
        deleteAlert.addAction(delete)
        
        present(deleteAlert, animated: true)
    }
    
    // MARK: - Private Method(TextView)
    
    private func configureTextView() {
        setupTextView()
        constraintTextView()
    }
    
    private func setupTextView() {
        view.addSubview(textView)
        self.textView.text = compositor.composite(
            title: diary.title,
            content: diary.content
        )
        self.textView.font = UIFont.preferredFont(forTextStyle: .body)
        self.textView.autocorrectionType = .no
    }
    
    private func constraintTextView() {
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.textView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - Private Method(Keyboard)
    
    private func configureKeyboard() {
        setupKeyboardToolbar()
        registerNotification()
    }
    
    private func setupKeyboardToolbar() {
        let toolbar = UIToolbar()
        let space = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let keyboardHideButton = UIBarButtonItem(
            image: UIImage(systemName: "keyboard.chevron.compact.down"),
            style: .plain,
            target: self,
            action: #selector(endEditing)
        )
        toolbar.items = [space, keyboardHideButton]
        toolbar.sizeToFit()
        self.textView.inputAccessoryView = toolbar
    }
    
    @objc private func endEditing() {
        self.textView.endEditing(true)
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keybordWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keybordWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keybordWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.size.height
            self.textView.contentInset.bottom = keyboardHeight
        }
    }
    
    @objc private func keybordWillHide() {
        self.textView.contentInset = .zero
        updateDiary()
    }
    
    // MARK: - Private Method(scene lifecycle)
    
    private func configureSceneLifecycle() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(enterBackground),
            name: UIScene.didEnterBackgroundNotification,
            object: nil
        )
    }
    
    @objc private func enterBackground() {
        updateDiary()
    }
}
