//
//  DiaryViewController.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/21.
//

import UIKit

final class DiaryViewController: UIViewController {
    private var diary: Diary
    private let isNewDiary: Bool

    private let scrollView: DiaryScrollView = {
        let scrollView = DiaryScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        scrollView.keyboardDismissMode = .interactive

        return scrollView
    }()

    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .title3)

        return textView
    }()

    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)

        return textView
    }()

    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextView, bodyTextView])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    init(diary: Diary, isNewDiary: Bool = false) {
        self.diary = diary
        self.isNewDiary = isNewDiary
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        configureHierarchy()
        configureView(with: diary)
        configureLayout()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !titleTextView.hasText {
            titleTextView.becomeFirstResponder()
        } else if !bodyTextView.hasText {
            bodyTextView.becomeFirstResponder()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        updateCoreDataIfNeeded()
    }

    private func configureHierarchy() {
        scrollView.addSubview(containerStackView)
        view.addSubview(scrollView)
        titleTextView.delegate = self
        bodyTextView.delegate = self
    }

    private func showDeleteActionAlert() {
        let alert = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.navigationController?.popViewController(animated: true)
            CoreDataManager.shared.delete(diary: self.diary)
        }

        alert.addAction(cancelAction)
        alert.addAction(deleteAction)

        present(alert, animated: true)
    }

    private func showActivityViewController() {
        let textToShare: String = "\(diary.title)\n\(diary.body)"
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)

        self.present(activityViewController, animated: true, completion: nil)
    }

    private func makeEllipsisMenu() -> UIMenu {
        let shareAction = UIAction(title: "공유",
                                   image: UIImage(systemName: "square.and.arrow.up")) { _ in
            self.showActivityViewController()
        }
        let deleteAction = UIAction(title: "삭제",
                                    image: UIImage(systemName: "trash"),
                                    attributes: .destructive) { _ in
            self.showDeleteActionAlert()
        }
        let cancelAction = UIAction(title: "취소",
                                    image: UIImage(systemName: "xmark")) { _ in }
        let menu = UIMenu(identifier: nil,
                          options: .displayInline,
                          children: [shareAction, deleteAction, cancelAction])

        return menu
    }

    private func configureNavigationBar() {
        navigationItem.title = diary.createdAt.localeFormattedText
        if !isNewDiary {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"),
                                                                menu: makeEllipsisMenu())
        }
    }

    private func configureView(with diary: Diary) {
        configureNavigationBar()
        titleTextView.text = diary.title
        bodyTextView.text = diary.body
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            containerStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            containerStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }

    private func generateDiary() -> Diary {
        return Diary(title: titleTextView.text,
                     body: bodyTextView.text,
                     createdAt: diary.createdAt,
                     uuid: diary.uuid)
    }

    func updateCoreDataIfNeeded() {
        if diary.title != titleTextView.text || diary.body != bodyTextView.text {
            diary = generateDiary()
            CoreDataManager.shared.update(diary: diary)
        }
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n", textView == titleTextView {
            bodyTextView.becomeFirstResponder()
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updateCoreDataIfNeeded()
    }
}
