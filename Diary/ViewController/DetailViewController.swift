//
//  DetailViewController.swift
//  Diary
//
//  Created by yyss99, Jusbug on 2023/08/30.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    let coreDataManager = CoreDataManager.shared
    private let entity: Entity?
    private let placeHolderText = "Input Text"
    
    init?(entity: Entity? = nil, coder: NSCoder) {
        self.entity = entity
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureNavigationTitle()
        setUpObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let text = textView.text, !text.isEmpty, text != placeHolderText else {
            return
        }
        let (title, body) = self.splitText(text: text)
        
        if let entity = self.entity ?? nil {
            coreDataManager.updateEntity(entity: entity, newTitle: title, newBody: body)
        } else {
            coreDataManager.createEntity(title: title, body: body)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    @IBAction func didTapMenu(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Menu",
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let share = UIAlertAction(title: "Share", style: .default) { action in
            let textToShare = "share the app"
            let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
            
            self.present(activityVC, animated: true, completion: nil)
        }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { action in
            let doublecheck = UIAlertController(title: "진짜요?", message: "정말로 삭제하시겠어요?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .default)
            let delete = UIAlertAction(title: "Delete", style: .destructive) { action in
                guard let entity = self.entity else {
                     return
                }
                self.coreDataManager.deleteEntity(entity: entity)
                self.navigationController?.popViewController(animated: true)
            }
            
            doublecheck.addAction(cancel)
            doublecheck.addAction(delete)
            self.present(doublecheck, animated: true, completion: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(share)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func setUpObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func splitText(text: String) -> (title: String, body: String) {
        let lines = text.components(separatedBy: "\n")
        var title = ""
        var body = ""
        
        if let firstLine = lines.first {
            title = firstLine
        }
        
        if lines.count > 1 {
            body = lines[2...]
                .joined(separator: "\n")
        }
        
        return (title, body)
    }
    
    private func configureNavigationTitle() {
        guard let createdDate = entity?.createdDate else {
            let formattedTodayDate = CustomDateFormatter.formatTodayDate()
            self.navigationItem.title = formattedTodayDate
            return
        }
        let formattedSampleDate = CustomDateFormatter.formatSampleDate(sampleDate: Int(createdDate))
        
        self.navigationItem.title = formattedSampleDate
    }
    
    private func configureTextView() {
        textView.layer.borderWidth = 1
        
        guard let entity, let title = entity.title, let body = entity.body else {
            textView.text = placeHolderText
            textView.textColor = .lightGray
            textView.delegate = self
            
            return
        }
        
        textView.text = title + "\n\n" + body
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            let safeAreaBottom = view.safeAreaInsets.bottom
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - safeAreaBottom, right: 0)
            
            textView.contentInset = contentInsets
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        textView.contentInset = UIEdgeInsets.zero
        
        guard let text = textView.text, !text.isEmpty, let entity = self.entity else {
            return
        }
        
        let (title, body) = self.splitText(text: text)
        coreDataManager.updateEntity(entity: entity, newTitle: title, newBody: body)
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolderText
            textView.textColor = .lightGray
        }
    }
}
