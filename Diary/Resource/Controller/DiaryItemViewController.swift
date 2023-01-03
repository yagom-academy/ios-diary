//
//  DiaryItemViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/26.
//

import UIKit

final class DiaryItemViewController: UIViewController {
    private var diaryItem: DiaryModel?
    private var hasTitle: Bool = false
    
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
    
    init(diaryItem: DiaryModel) {
        self.diaryItem = diaryItem
        super.init(nibName: nil, bundle: nil)
    }
    
    init() {
        self.diaryItem = DiaryItemManager.shared.create()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView(frame: .zero)
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainStackView)
        titleTextView.becomeFirstResponder()
        configureTextView()
        configureNavigationBar()
        configureMainStackView()
        addKeyboardDismissAction()
        addObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
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
            textView.text = (textView == titleTextView) ? Placeholder.title : Placeholder.body
        } else {
            titleTextView.resignFirstResponder()
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Namespace.moreImage),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showActionSheet))
        
        let date = Date()
        title = (title == nil ? DateFormatterManager().formatDate(date) : title)
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
    
    private func addObserver() {
        let notificationName = Notification.Name("sceneDidEnterBackground")
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: notificationName,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showAlert(_:)),
                                               name: Notification.Name("CoreDataError"),
                                               object: nil)
    }
    
    @objc private func save() {
        diaryItem?.title = titleTextView.text
        diaryItem?.body = bodyTextView.text
        DiaryItemManager.shared.update(diaryItem: diaryItem)
    }
    
    @objc private func showAlert(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let title = userInfo[Namespace.alertTitle, default: Namespace.empty] as? String else { return }
        
        showErrorAlert(title: title)
    }
    
    func fillTextView(with data: DiaryModel) {
        titleTextView.text = data.title
        bodyTextView.text = data.body
        title = DateFormatterManager().formatDate(data.createdAt)
    }
    
    @objc private func showActionSheet() {
        let alert: UIAlertController = UIAlertController(title: nil,
                                                         message: nil,
                                                         preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: Namespace.share, style: .default) { _ in
            let diaryForm = DiaryItemManager.shared.createDiaryShareForm(diaryItem: self.diaryItem)
            let activityVC = UIActivityViewController(activityItems: [diaryForm], applicationActivities: nil)
            self.present(activityVC, animated: true)
        })
        alert.addAction(UIAlertAction(title: Namespace.delete, style: .destructive) { _ in
            let handler: (UIAlertAction) -> Void = { _ in
                self.delete()
                self.navigationController?.popViewController(animated: false)
            }
            
            self.showDeleteAlert(handler: handler)
        })
        alert.addAction(UIAlertAction(title: Namespace.cancel, style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func delete() {
        self.titleTextView.text = Namespace.empty
        self.bodyTextView.text = Namespace.empty
        DiaryItemManager.shared.deleteDiary(data: diaryItem)
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

// MARK: dismiss keyboard
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
        if textView.textColor == .systemGray3 {
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
