//
//  DiaryItemViewController.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/26.
//

import UIKit

final class DiaryItemViewController: UIViewController {
    private let diaryItemManager: DiaryItemManager
    private let alertManager = AlertManager()
    weak var alertDelegate: AlertDelegate?
    
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
    
    init(diaryItemManager: DiaryItemManager) {
        self.diaryItemManager = diaryItemManager
        do {
            try self.diaryItemManager.create()
        } catch {
            alertDelegate?.showErrorAlert(title: "생성 실패")
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    init(diaryItemManager: DiaryItemManager, id: UUID) {
        self.diaryItemManager = diaryItemManager
        self.diaryItemManager.fetchID(id: id)
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
        configureUI()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        do {
            try diaryItemManager.validate(title: titleTextView.text, body: bodyTextView.text)
        } catch {
            alertDelegate?.showErrorAlert(title: Content.saveFailure)
        }
    }
    
    private func configureUI() {
        view.addSubview(mainStackView)
        titleTextView.becomeFirstResponder()
        configureTextView()
        configureNavigationBar()
        configureMainStackView()
        addKeyboardDismissAction()
        addObserver()
    }
    
    private func configureTextView() {
        titleTextView.delegate = self
        bodyTextView.delegate = self
        setPlaceholder()
    }
    
    private func setPlaceholder() {
        if diaryItemManager.needsPlaceholder(for: titleTextView.text) {
            titleTextView.text = Placeholder.title
            titleTextView.textColor = .systemGray3
        }
        
        if diaryItemManager.needsPlaceholder(for: bodyTextView.text) {
            bodyTextView.text = Placeholder.body
            bodyTextView.textColor = .systemGray3
        }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: Content.moreImage),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showActionSheet))
        
        let date = Date()
        title = title ?? DateFormatterManager().formatDate(date)
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func save() {
        let title = titleTextView.text
        let body = bodyTextView.text
        do {
            try diaryItemManager.update(title: title, body: body)
        } catch {
            present(alertManager.showErrorAlert(title: Content.saveFailure), animated: true)
        }
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
            let diaryForm = self.diaryItemManager.createDiaryShareForm()
            let activityViewController = UIActivityViewController(activityItems: [diaryForm],
                                                      applicationActivities: nil)
            self.present(activityViewController, animated: true)
        })
        alert.addAction(UIAlertAction(title: Namespace.delete, style: .destructive) { _ in
            let handler: (UIAlertAction) -> Void = { _ in
                self.delete()
                self.navigationController?.popViewController(animated: false)
            }
            
            self.present(self.alertManager.showDeleteAlert(handler: handler), animated: true)
        })
        alert.addAction(UIAlertAction(title: Namespace.cancel, style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func delete() {
        self.titleTextView.text = Namespace.empty
        self.bodyTextView.text = Namespace.empty
        do {
            try diaryItemManager.deleteDiary()
        } catch {
            present(alertManager.showErrorAlert(title: Content.deleteFailure), animated: true)
        }
    }
    
    private enum LayoutConstant {
        static let stackViewSpacing = CGFloat(8)
        static let mainStackViewTopMargin = CGFloat(8)
        static let mainStackViewLeadingMargin = CGFloat(8)
        static let mainStackViewBottomMargin = CGFloat(8)
        static let mainStackViewTrailingMargin = CGFloat(8)
        static let titleTextViewMaxHeight = CGFloat(100)
    }
    
    private enum Content {
        static let moreImage = "ellipsis.circle"
        static let saveFailure = "저장 실패"
        static let deleteFailure = "삭제 실패"
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
        let isPlaceholder: Bool = textView.textColor == .systemGray3
        
        if isPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard textView == titleTextView else { return }
        
        let titleTextViewHeight = textView.contentSize.height
        
        isOversized = diaryItemManager.isOversized(height: titleTextViewHeight,
                                                   maxHeight: LayoutConstant.titleTextViewMaxHeight)
        let trimmedTitle = diaryItemManager.createTrimmedTitle(from: titleTextView.text)
        
        if trimmedTitle != titleTextView.text {
            titleTextView.text = trimmedTitle
            titleTextView.resignFirstResponder()
            bodyTextView.becomeFirstResponder()
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        setPlaceholder()
    }
}
