//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/25.
//

import UIKit

final class DiaryDetailViewController: UIViewController {
    // MARK: - Nested Type
    private enum LocalizationKey {
        static let barButtonTitle = "barButtonTitle"
        static let delete = "delete"
        static let cancel = "cancel"
        static let share = "share"
        static let more = "more"
    }
    
    enum WriteMode {
        case create
        case update
    }
    
    // MARK: - Properties
    private let diaryService = DiaryService()
    private let dateFormatter = DiaryDateFormatter.shared
    private var writeMode = WriteMode.create

    private var diary: Diary?
    private var id = UUID()
    private var iconData: Data?
    private var timeInterval: Int?
    private var isSave: Bool = true
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .preferredFont(forTextStyle: .body)
        textView.layer.borderWidth = 0.8
        textView.layer.cornerRadius = 4
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()

    // MARK: - Initializer
    init(_ diary: Diary?) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkWriteMode()
        configureUI()
        configureLayout()
        configureNavigationBar()
        configureNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveDiaryToStorage()
    }
    
    // MARK: - Methods
    private func checkWriteMode() {
        writeMode = diary == nil ? .create : .update
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        
        switch writeMode {
        case .create:
            textView.becomeFirstResponder()
            configureNewTitleView()
        case .update:
            guard let validDiary = diary else { return }
            
            id = validDiary.id
            iconData = validDiary.iconData
            textView.text = validDiary.sharedText
            timeInterval = validDiary.timeIntervalSince1970
            configureTitleView(iconData: validDiary.iconData, timeInterval: validDiary.timeIntervalSince1970)
        }
    }
    
    private func configureNewTitleView() {
        let formatter = DiaryDateFormatter.shared
        
        diaryService.fetchWeatherIcon { data in //fetchweathericon
            let timeInterval = self.diary?.timeIntervalSince1970 ?? formatter.nowTimeIntervalSince1970
            self.timeInterval = timeInterval
            
            guard let data = self.diary?.iconData ?? data else { return }
            self.iconData = data
            
            DispatchQueue.main.async {
                self.configureTitleView(iconData: data, timeInterval: timeInterval)
            }
        }
    }
    
    private func configureLayout() {
        view.addSubview(textView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8),
            textView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -8)
        ])
    }
    
    private func configureTitleView(iconData: Data, timeInterval: Int) {
        let titleView = TitleStackView()
        let dateText = dateFormatter.convertToString(from: timeInterval)
        titleView.configureContent(iconData: iconData, date: dateText)
        
        self.navigationItem.titleView = titleView
    }
    
    private func configureNavigationBar() {
        let buttonItem: UIBarButtonItem = {
            let button = UIBarButtonItem(
                title: LocalizationKey.more.localized(),
                style: .plain,
                target: self,
                action: #selector(presentActionSheet)
            )
            
            return button
        }()
        
        navigationItem.rightBarButtonItem = buttonItem
    }
    
    @objc private func presentActionSheet() {
        let shareActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(
            title: LocalizationKey.cancel.localized(),
            style: .cancel
        )
        
        let shareAction = UIAlertAction(
            title: LocalizationKey.share.localized(),
            style: .default
        ) { [weak self] _ in
            self?.presentActivityView(diary: self?.diary)
        }
        
        let deleteAction = UIAlertAction(
            title: LocalizationKey.delete.localized(),
            style: .destructive
        ) { [weak self] _ in
            
            self?.presentDeleteAlert(diary: self?.diary) { _ in
                self?.isSave = false
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        shareActionSheet.addAction(cancelAction)
        shareActionSheet.addAction(shareAction)
        shareActionSheet.addAction(deleteAction)
        
        present(shareActionSheet, animated: true)
    }
    
    private func configureNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackground),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              var keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        keyboardFrame = view.convert(keyboardFrame, from: nil)
        
        textView.contentInset.bottom = keyboardFrame.size.height
        textView.scrollIndicatorInsets = textView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        textView.scrollIndicatorInsets = textView.contentInset
        
        saveDiaryToStorage()
    }
    
    @objc private func didEnterBackground() {
        saveDiaryToStorage()
    }
    
    private func createCurrentDiary() -> Diary? {
        guard let contents = verifyText(text: textView.text) else { return nil }
        let components = contents.split(separator: "\n", maxSplits: 1)
        
        guard let title = components.first,
              let iconData = self.iconData,
              let timeInterval = self.timeInterval  else { return nil }
        
        var body = components[safe: 1] ?? ""
        if body.first == "\n" {
            body.removeFirst()
        }
        
        let currentDiary = Diary(
            id: id,
            title: String(title),
            body: String(body),
            timeIntervalSince1970: timeInterval,
            iconData: iconData
        )
        
        return currentDiary
    }
    
    private func saveDiaryToStorage() {
        guard let diary = createCurrentDiary() else { return }
        self.diary = diary
        
        if isSave {
            if CoreDataManager.shared.search(id: diary.id) == true {
                CoreDataManager.shared.update(diary)
            } else {
                CoreDataManager.shared.create(diary)
            }
        }
    }
    
    private func verifyText(text: String) -> String? {
        let trimmedText = text.trimmingCharacters(in: .whitespaces)
        
        if trimmedText.isEmpty {
            return nil
        } else {
            return trimmedText
        }
    }
}
