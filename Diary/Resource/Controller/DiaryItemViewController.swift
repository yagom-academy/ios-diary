//
//  DiaryItemViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/26.
//

import UIKit

class DiaryItemViewController: UIViewController {
    var hasTitle: Bool = false
    var diaryData: DiaryModel = DiaryModel(id: UUID(),
                                           title: "제목 없음",
                                           body: "",
                                           createdAt: Date())
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = LayoutConstant.stackViewSpacing
        return stackView
    }()
    
    let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.textColor = .systemGray3
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        textView.text = Placeholder.editText
        textView.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        return textView
    }()
    
    let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .systemGray3
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.text = Placeholder.editText
        textView.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        return textView
    }()
    
    private lazy var titleHeightConstraint =
    titleTextView.heightAnchor.constraint(equalToConstant: LayoutConstant.titleTextViewMaxHeight)
    
    private var isOversized = false {
        didSet {
            guard oldValue != isOversized else { return }
            titleTextView.isScrollEnabled = isOversized
            titleHeightConstraint.isActive = !oldValue
            titleTextView.setNeedsUpdateConstraints()
        }
    }
    
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        configureTextView()
        configureNavigationBar()
        configureMainStackView()
        addKeyboardDismissAction()
        addObserver()
    }

    override func viewWillDisappear(_ animated: Bool) {
        saveOrUpdate()
    }
    
    private func configureTextView() {
        titleTextView.delegate = self
        bodyTextView.delegate = self
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        let date = Date()
        title = DateFormatterManager().formatDate(date)
    }
    
    func configureMainStackView() {
        mainStackView.addArrangedSubview(titleTextView)
        mainStackView.addArrangedSubview(bodyTextView)
        mainStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: LayoutConstant.mainStackViewTopMargin,
                                                                         leading: LayoutConstant.mainStackViewLeadingMargin,
                                                                         bottom: LayoutConstant.mainStackViewBottomMargin,
                                                                         trailing: LayoutConstant.mainStackViewTrailingMargin)
        mainStackView.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor)
        ])
    }
    
    func addObserver() {
        let notificationName = Notification.Name("sceneDidEnterBackground")
        
        NotificationCenter.default.addObserver(self, selector: #selector(saveOrUpdate),
                                               name: notificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveOrUpdate),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func updateDiaryModel() {
        diaryData.title = titleTextView.text
        diaryData.body = bodyTextView.text
        diaryData.createdAt = Date()
    }
    
    @objc func saveOrUpdate() {
        guard CoreDataStack.shared.fetchDiary(with: diaryData.id) != nil else {
            CoreDataStack.shared.insertDiary(diaryData)
            return
        }

        updateDiaryModel()
        CoreDataStack.shared.updateDiary(diaryData)
    }
    
    private enum LayoutConstant {
        static let stackViewSpacing = CGFloat(8)
        static let mainStackViewTopMargin = CGFloat(8)
        static let mainStackViewLeadingMargin = CGFloat(8)
        static let mainStackViewBottomMargin = CGFloat(8)
        static let mainStackViewTrailingMargin = CGFloat(8)
        static let titleTextViewMaxHeight = CGFloat(100)
    }
}

extension DiaryItemViewController {
    func addKeyboardDismissAction() {
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                                              action: #selector(dismissKeyboard))
        swipeGesture.direction = .down
        bodyTextView.addGestureRecognizer(swipeGesture)
    }
    
    @objc func dismissKeyboard() {
        bodyTextView.resignFirstResponder()
    }
}

extension DiaryItemViewController: UITextViewDelegate { }

enum Placeholder {
    static let editText = "일기를 입력해주세요."
}
