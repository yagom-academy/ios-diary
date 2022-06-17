//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/14.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func update(diary: Diary)
    func delete(diary: Diary)
}

final class DiaryDetailViewController: UIViewController {
    private let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let diary: Diary
    weak var delegate: DiaryDetailViewDelegate?
    
    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        attribute()
        addSubViews()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if diary.isEmpty {
            diaryTextView.becomeFirstResponder()
        }
    }
    
    private func setUp() {
        setUpNavigationBar()
        setUpTextView()
    }
    
    private func setUpNavigationBar() {
        title = diary.createdDate.formattedString
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(moreButtonDidTap)
        )
    }
    
    @objc
    private func moreButtonDidTap() {
        AlertBuilder(viewController: self)
            .addAction(title: "Share...", style: .default) { [weak self] in
                guard let text = self?.diaryTextView.text else { return }
                
                let activityViewController = UIActivityViewController(
                    activityItems: [text],
                    applicationActivities: nil
                )
                
                self?.present(activityViewController, animated: true)
            }
            .addAction(title: "Delete", style: .destructive) { [weak self] in
                AlertBuilder(viewController: self)
                    .addAction(title: "취소", style: .cancel)
                    .addAction(title: "삭제", style: .destructive) { [weak self] in
                        guard let diary = self?.diary else { return }
                        
                        self?.delegate?.delete(diary: diary)
                        self?.navigationController?.popViewController(animated: true)
                    }
                    .show(title: "진짜요?", message: "정말로 삭제하시겠어요?", style: .alert)
            }
            .addAction(title: "Cancel", style: .cancel)
            .show(style: .actionSheet)
    }
    
    private func setUpTextView() {
        diaryTextView.contentOffset = .zero
        diaryTextView.delegate = self
        
        if diary.isEmpty == false {
            diaryTextView.text = diary.title + "\n\n" + diary.body
        }
    }
    
    private func attribute() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubViews() {
        view.addSubview(diaryTextView)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            diaryTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            diaryTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension DiaryDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "완료",
            style: .plain,
            target: self,
            action: #selector(doneButtonDidTap)
        )
    }
    
    @objc
    private func doneButtonDidTap() {
        diaryTextView.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let texts = textView.text else { return }
        
        let newDiary: Diary
        
        if let index = texts.firstIndex(of: "\n") {
            let title = String(texts[..<index])
            let body = texts[index...].trimmingCharacters(in: .newlines)
            
            newDiary = Diary(title: title, body: body, createdDate: diary.createdDate, id: diary.id)
        } else {
            newDiary = Diary(title: texts, body: "", createdDate: diary.createdDate, id: diary.id)
        }
        
        delegate?.update(diary: newDiary)
    }
}
