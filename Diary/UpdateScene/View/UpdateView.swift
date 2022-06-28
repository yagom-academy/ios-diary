//
//  UpdateView.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/28.
//

import UIKit

final class UpdateView: UIView {
    private var keyboard: Keyboard?
    private let textView: UITextView = {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    init(delegate: UITextViewDelegate) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setUpTextView(delegate: delegate)
        setUpTextViewLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTextView(text: String) {
        textView.text = text
    }
    
    func getTextViewTitle() -> String? {
        return textView.title
    }
    
    func getTextViewBody() -> String {
        return textView.body
    }
    
    private func setUpTextView(delegate: UITextViewDelegate) {
        textView.becomeFirstResponder()
        textView.delegate = delegate
    }
    
    private func setUpTextViewLayout() {
        addSubview(textView)
        
        let bottomContraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            bottomContraint
        ])
        
        keyboard = Keyboard(bottomContraint: bottomContraint, textView: textView)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

private extension UITextView {
    var title: String? {
        let text = self.text.components(separatedBy: "\n")
        return text.first == "" ? nil : text.first
    }
    
    var body: String {
        let splitedText = self.text.split(separator: "\n", maxSplits: 1)
        let body = splitedText.map { String($0) }
        return body[safe: 1] ?? ""
    }
}
