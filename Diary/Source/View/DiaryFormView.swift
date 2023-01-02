//
//  DiaryFormView.swift
//  Diary
//  Created by inho, dragon on 2022/12/21.
//

import UIKit

final class DiaryFormView: UIView {
    let diaryTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    var components: [String] {
        return diaryTextView.text.components(separatedBy: NameSpace.lineBreak)
    }
    var diaryTitle: String {
        return components.first ?? String()
    }
    var diaryBody: String {
        var components = components
        components.removeFirst()
        
        return components.filter { !$0.isEmpty }.first ?? String()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(diaryTextView)
        
        NSLayoutConstraint.activate([
            diaryTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
            diaryTextView.topAnchor.constraint(equalTo: topAnchor),
            diaryTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
            diaryTextView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

private enum NameSpace {
    static let lineBreak = "\n"
}
