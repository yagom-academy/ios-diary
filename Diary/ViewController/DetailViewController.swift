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
    private var initEntity: Entity?
    private let placeHolderText = "Input Text"
    
    init?(entity: Entity? = nil, coder: NSCoder) {
        self.entity = entity
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextView()
        configureNavigationTitle()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let text = textView.text, !text.isEmpty else {
            return
        }
        
        let (title, body) = self.splitText(text: text)
        
        if initEntity == nil {
            coreDataManager.createEntity(title: title, body: body)
        } else {
            guard let entity = self.entity else {
                return
            }
            coreDataManager.updateEntity(entity: entity, newTitle: title, newBody: body)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func splitText(text: String) -> (title: String, body: String) {
        let lines = text.components(separatedBy: "\n")
        var title = ""
        var body = ""
        
        if let firstLine = lines.first {
            print("title: (firstLine)")
            title = firstLine
        }
        
        if lines.count > 1 {
            body = lines[1...]
                .joined(separator: "\n")
            print("body: (body)")
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
        
        guard let entity else {
            textView.text = placeHolderText
            textView.textColor = .lightGray
            textView.delegate = self
            
            return
        }
        
        textView.text = entity.title
        textView.text = entity.body
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
        
        guard let text = textView.text, !text.isEmpty else {
            return
        }
        
        let (title, body) = self.splitText(text: text)
        
        guard let entity = self.entity else {
            return
        }
        coreDataManager.updateEntity(entity: entity, newTitle: title, newBody: body)
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = placeHolderText
            textView.textColor = .lightGray
        }
    }
}
