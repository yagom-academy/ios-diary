//
//  UpdateViewController.swift
//  Diary
//
//  Created by 김태현 on 2022/06/14.
//

import UIKit

protocol BackGroundDelegate: AnyObject {
    func updateCoredata()
}

extension UpdateViewController: BackGroundDelegate {
    func updateCoredata() {
        saveData()
    }
}

final class UpdateViewController: UIViewController {
    private let textView = UITextView()
    private var keyboard: Keyboard?
    private let identifier: UUID?
    
    init(diaryData: DiaryDTO? = nil) {
        guard let diaryData = diaryData else {
            identifier = nil
            super.init(nibName: nil, bundle: nil)
            return
        }

        identifier = diaryData.identifier
        super.init(nibName: nil, bundle: nil)
        
        setUpEditPage(diaryData: diaryData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        guard let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return
        }
        
        scene.delegate = self
        
        setUpView()
        setUpNavigationController(title: Formatter.getCurrentDate())
        setUpTextViewLayout()
        
        keyboard?.setUpKeyboard()
        showKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        saveData()
    }
    
    private func setUpView() {
        view.backgroundColor = .systemBackground
    }
    
    private func setUpEditPage(diaryData: DiaryDTO) {
        setUpNavigationController(title: diaryData.dateString)
        textView.text = "\(diaryData.title)\n\n\(diaryData.body)"
    }
    
    private func setUpNavigationController(title: String) {
        func setUpRightButton() {
            let button = UIBarButtonItem(title: "더보기", style: .plain, target: self, action: #selector(more))
            navigationItem.rightBarButtonItem = button
        }
        
        navigationItem.title = title
        setUpRightButton()
    }
    
    @objc private func more() {
        showActionSheet()
    }
    
    private func saveData() {
        guard textView.text.isEmpty != true else {
            return
        }
        
        let splitedText = textView.text.split(separator: "\n", maxSplits: 1, omittingEmptySubsequences: false)
            .map {
                String($0)
            }
                
        guard let title = splitedText.first,
              let body = splitedText.last,
              let date = Formatter.getDate(from: navigationItem.title ?? "") else {
            return
        }
        
        if let identifier = identifier {
            let edittedData = DiaryDTO(identifier: identifier, title: title, body: body, date: date)
            
            DiaryDAO.shared.update(userData: edittedData)
        } else {
            let newData = DiaryDTO(title: title, body: body, date: date)

            DiaryDAO.shared.create(userData: newData)
        }
    }
    
    private func setUpTextViewLayout() {
        view.addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
       
        let bottomContraint = textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomContraint
        ].compactMap { $0 })
        
        keyboard = Keyboard(bottomContraint: bottomContraint, textView: textView)
    }
    
    private func showKeyboard() {
        textView.becomeFirstResponder()
    }
}

extension UpdateViewController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        saveData()
    }
}

extension UpdateViewController {
    func showActionSheet() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let share = UIAlertAction(title: "Share", style: .default) { [self] _ in
            print("share")
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [self] _ in
            showAlert()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        sheet.addAction(share)
        sheet.addAction(delete)
        sheet.addAction(cancel)
        
        present(sheet, animated: true)
    }
    
    func showAlert() {
        let sheet = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let identifier = self?.identifier else {
                return
            }
            DiaryDAO.shared.delete(identifier: identifier.uuidString)
            self?.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        sheet.addAction(delete)
        sheet.addAction(cancel)
        
        present(sheet, animated: true)
    }
}
