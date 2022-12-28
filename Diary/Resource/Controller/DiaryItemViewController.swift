//
//  DiaryItemViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/26.
//

import UIKit

class DiaryItemViewController: UIViewController {
    private var hasTitle: Bool = false
    private var diaryItemManager = DiaryItemManager()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = LayoutConstant.stackViewSpacing
        return stackView
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.font = UIFont.preferredFont(forTextStyle: .title2)
        textView.textContainerInset = UIEdgeInsets(top: .zero, left: .zero, bottom: .zero, right: .zero)
        return textView
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
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
        save()
    }
    
    private func configureTextView() {
        titleTextView.delegate = self
        bodyTextView.delegate = self
        setPlaceholder(for: titleTextView)
        setPlaceholder(for: bodyTextView)
    }
    
    private func setPlaceholder(for textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .systemGray3
            textView.text = Placeholder.editText
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        let date = Date()
        
        if title == nil {
            title = DateFormatterManager().formatDate(date)
        }
    }
    
    private func configureMainStackView() {
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
    
    func configureDetailView(data: DiaryModel) {
        titleTextView.text = data.title
        bodyTextView.text = data.body
        title = DateFormatterManager().formatDate(data.createdAt)
    }
    
    private func addObserver() {
        let notificationName = Notification.Name("sceneDidEnterBackground")
        
        NotificationCenter.default.addObserver(self, selector: #selector(save),
                                               name: notificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(save),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func save() {
        diaryItemManager.saveDiaryWith(title: titleTextView.text, body: bodyTextView.text)
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
    private func addKeyboardDismissAction() {
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self,
                                                                              action: #selector(dismissKeyboard))
        swipeGesture.direction = .down
        bodyTextView.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func dismissKeyboard() {
        bodyTextView.resignFirstResponder()
    }
}

extension DiaryItemViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Placeholder.editText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView == titleTextView else { return }
        
        let titleTextViewHeight = textView.contentSize.height
        
        if titleTextViewHeight > LayoutConstant.titleTextViewMaxHeight {
            isOversized = true
        } else {
            isOversized = false
        }
        
        if !hasTitle,
           titleTextView.text.firstIndex(of: "\n") != nil {
            hasTitle = true
            titleTextView.text = titleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            titleTextView.resignFirstResponder()
            bodyTextView.becomeFirstResponder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        setPlaceholder(for: textView)
    }
}

enum Placeholder {
    static let editText = "내용을 입력해주세요."
}
