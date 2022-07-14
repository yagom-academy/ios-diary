//
//  DiaryTextView.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/28.
//

import UIKit

final class DiaryTextView: UITextView {
    private var keyboard: Keyboard?
    
    var title: String? {
        let text = self.text.components(separatedBy: "\n")
        return text.first == "" ? nil : text.first
    }
    
    var body: String {
        let splitedText = self.text.split(separator: "\n", maxSplits: 1)
        let body = splitedText.map { String($0) }
        return body[safe: 1] ?? ""
    }
    
    init(delegate: UITextViewDelegate) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0), textContainer: nil)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        setUpTextView(delegate: delegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpTextView(delegate: UITextViewDelegate) {
        becomeFirstResponder()
        self.delegate = delegate
    }
    
    func setUpTextViewLayout(view: UIView) {        
        let bottomContraint = bottomAnchor.constraint(equalTo: view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomContraint
        ])
        
        keyboard = Keyboard(bottomContraint: bottomContraint, textView: self)
    }
}

// MARK: - Array
private extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
