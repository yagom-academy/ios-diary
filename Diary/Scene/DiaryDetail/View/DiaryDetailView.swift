//
//  DiaryDetailView.swift
//  Diary
//
//  Created by 재재, 그루트 on 2022/08/18.
//

import UIKit

final class DiaryDetailView: UIView {
    // MARK: - properties
    
    private let detailTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .preferredFont(forTextStyle: .body)
        
        return textView
    }()

    // MARK: - initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - methods

    func configureDetailTextView(ofText: String?) {
        detailTextView.text = ofText
    }
    
    private func commonInit() {
        configureView()
        configureViewLayouts()
    }

    private func configureView() {
        addSubview(detailTextView)
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func configureViewLayouts() {
        NSLayoutConstraint.activate([
            detailTextView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            detailTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            detailTextView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            detailTextView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
