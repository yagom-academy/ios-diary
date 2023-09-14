//
//  DetailViewController.swift
//  Diary
//
//  Created by yyss99, Jusbug on 2023/08/30.
//

import UIKit

final class DetailViewController: UIViewController {
    @IBOutlet private weak var titleTextView: UITextView!
    @IBOutlet private weak var bodyTextView: UITextView!
    private let entity: Entity?
    let placeHolderText = "Input Text"
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
        titleTextView.layer.borderWidth = 1
        bodyTextView.layer.borderWidth = 1
        
        guard let entity else {
            titleTextView.text = placeHolderText
            titleTextView.textColor = .lightGray
            titleTextView.delegate = self
            
            bodyTextView.text = placeHolderText
            bodyTextView.textColor = .lightGray
            bodyTextView.delegate = self
            return
        }
        
        titleTextView.text = entity.title
        bodyTextView.text = entity.body
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            let safeAreaBottom = view.safeAreaInsets.bottom
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - safeAreaBottom, right: 0)
            
            bodyTextView.contentInset = contentInsets
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        bodyTextView.contentInset = UIEdgeInsets.zero
    }
}

extension DetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if titleTextView.text == placeHolderText {
            titleTextView.text = nil
            titleTextView.textColor = .black
        }
        
        if bodyTextView.text == placeHolderText {
            bodyTextView.text = nil
            bodyTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if titleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            titleTextView.text = placeHolderText
            titleTextView.textColor = .lightGray
        }
        
        if bodyTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            bodyTextView.text = placeHolderText
            bodyTextView.textColor = .lightGray
        }
    }
}
