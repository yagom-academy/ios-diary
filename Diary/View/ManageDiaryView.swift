//
//  AddDiaryView.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/17.
//

import UIKit

final class ManageDiaryView: UIView {
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.adjustsFontForContentSizeCategory = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.keyboardType = .default
        textView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        textView.keyboardDismissMode = .onDrag
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}

extension ManageDiaryView {
    private func commonInit() {
        addSubView()
        setupConstraint()
    }
    private func addSubView() {
        self.addSubview(bodyTextView)
        self.backgroundColor = .white
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            bodyTextView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            bodyTextView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            bodyTextView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func fetchBodyTextView(_ content: String) {
        self.bodyTextView.text = content
        self.bodyTextView.contentOffset.y = 0
    }
    
    func adjustContentInset(height: CGFloat) {
        self.bodyTextView.contentInset.bottom = height
    }
    
    func focusBodyTextView() {
        self.bodyTextView.becomeFirstResponder()
    }
    
    func convertDiaryItem(with id: UUID, icon: Data, createdData: Double) -> DiaryItem? {
        guard let content = self.bodyTextView.text,
              let firstLineIndex = content.firstIndex(of: "\n") else { return nil }
        
        let title = String(content[content.startIndex..<firstLineIndex])
        let body = String(content[firstLineIndex..<content.endIndex])
        let createdAt = Date().timeIntervalSince1970
        
        return DiaryItem(id: id, title: title, body: body, createdAt: createdAt, icon: icon)
    }
}
