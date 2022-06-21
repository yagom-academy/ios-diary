//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/14.
//

import UIKit

protocol diaryDetailViewDelegate: AnyObject {
    func save(_ diary: Diary)
    func update(_ diary: Diary)
    func delete(_ diary: Diary)
}

final class DiaryDetailViewController: UIViewController {
    private let mainView = DiaryDetailView()
    private let diary: Diary?
    weak var delegate: diaryDetailViewDelegate?
    
    init(diary: Diary? = nil) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        registerNotification()
        configureNavigationItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setViewFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let diary = diary {
            delegate?.update(updateDiary(diary))
        } else {
            delegate?.save(makeDiary())
        }
    }
    
    private func setViewFirstResponder() {
        mainView.setFirstResponder()
    }
    
    private func configureView() {
        mainView.configure(diary: diary)
        view.backgroundColor = .systemBackground
        title = DateFormatter().changeDateFormat(time: diary?.createdAt)
    }
    
    private func configureLayout() {
        self.view.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            mainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    private func configureContent() -> (String, String) {
        let component = mainView.readText()
            .split(separator: "\n", maxSplits: 1)
            .map(String.init)
        let title = component[safe: 0] ?? ""
        let body = component[safe: 1] ?? ""
        
        return (title, body)
    }
    
    private func makeDiary() -> Diary {
        let (title, body) = configureContent()
        
        return Diary(title: title, body: body, createdAt: Date())
    }
    
    private func updateDiary(_ diary: Diary) -> Diary {
        let (title, body) = configureContent()
        
        return Diary(title: title, body: body, createdAt: diary.createdAt, uuid: diary.uuid)
    }
}

// MARK: - Keyboard Notification

extension DiaryDetailViewController {
    private func registerNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ sender: Notification) {
        guard let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keybaordRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keybaordRectangle.height
        
        mainView.changeBottomConstraint(value: keyboardHeight)
    }
    
    @objc private func keyboardWillHide(_ sender: Notification) {
        mainView.changeBottomConstraint(value: .zero)
    }
}

// MARK: - Alert Action

extension DiaryDetailViewController {
    private func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(viewMoreButtonDidTapped))
    }
    
    private func showDeleteAlert() {
        AlertBuilder(target: self).addAction("취소", style: .default) {
            // empty
        }.addAction("삭제", style: .destructive) { [weak self] in
            guard let diary = self?.diary else { return }
            self?.delegate?.delete(diary)
            self?.navigationController?.popViewController(animated: true)
        }.show("진짜요?", message: "정말로 삭제하시겠어요?", style: .alert)
    }
    
    private func showShareController() {
        let shareText = mainView.readText()
        var shareObject = [String]()
        shareObject.append(shareText)
        let activityViewController = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true)
    }
    
    @objc func viewMoreButtonDidTapped() {
        AlertBuilder(target: self).addAction("Share...", style: .default) { [weak self] in
            self?.showShareController()
        }.addAction("Delete", style: .destructive) { [weak self] in
            self?.showDeleteAlert()
        }.addAction("Cancel", style: .cancel) {
            // empty
        }.show(style: .actionSheet)
    }
}

private extension Array {
    subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}
