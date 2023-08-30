//
//  DetailViewController.swift
//  Diary
//
//  Created by yyss99, Jusbug on 2023/08/29.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    let placeHolderText = "Input Text"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTitleTextView()
        initbodyTextView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.titleTextView.resignFirstResponder()
    }
    
    private func initTitleTextView() {
        titleTextView.text = placeHolderText
        titleTextView.textColor = .lightGray
        titleTextView.layer.borderWidth = 1
        titleTextView.delegate = self
    }
    
    private func initbodyTextView() {
        bodyTextView.text = placeHolderText
        bodyTextView.textColor = .lightGray
        bodyTextView.layer.borderWidth = 1
        bodyTextView.delegate = self
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
