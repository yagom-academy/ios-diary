//
//  DetailViewController.swift
//  Diary
//
//  Created by yyss99, Jusbug on 2023/08/30.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    private var sample: Sample?
    private var originalFrame: CGRect?
    
    init?(sample: Sample, coder: NSCoder) {
        self.sample = sample
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
        guard let createdDate = sample?.createdDate else { return }
        let formattedSampleDate = CustomDateFormatter.formatSampleDate(sampleDate: createdDate)
        
        self.navigationItem.title = formattedSampleDate
    }
    
    private func configureTextView() {
        titleTextView.text = sample?.title
        bodyTextView.text = sample?.body
        titleTextView.layer.borderWidth = 1
        bodyTextView.layer.borderWidth = 1
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if originalFrame == nil {
            originalFrame = view.frame
        }
        
        if let keyboardFrame = (sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardFrame.height
            let safeAreaBottom = view.safeAreaInsets.bottom
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - safeAreaBottom, right: 0)
            
            bodyTextView.contentInset = contentInsets
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if originalFrame != nil {
            bodyTextView.contentInset = UIEdgeInsets.zero
        }
    }
}
