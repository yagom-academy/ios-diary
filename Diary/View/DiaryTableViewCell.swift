//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/08/29.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    private let diaryTitle: UILabel = {
        let label = UILabel()
        label.text = "여기는 제목이 들어갈 자리"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        
        return label
    }()
    
    private let dateAndPreview: UILabel = {
        let label = UILabel()
        label.text = "2021년 8월 29일, 작은 글자로 텍스트가 들어갈 자리."
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        addSubViews()
        contentStackViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fetchData(_ data: Diary) {
        diaryTitle.text = data.title
        dateAndPreview.attributedText = attributedDateAndPreview(data: data)
    }
    
    private func convertAttributedString(text: String, font: UIFont.TextStyle) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font: font as Any] as [NSAttributedString.Key : Any]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        
        return attributedString
    }
    
    private func attributedDateAndPreview(data: Diary) -> NSMutableAttributedString {
        let createdAt = convertAttributedString(text: String(data.createdAt), font: .body)
        let textBody = convertAttributedString(text: String(data.body), font: .caption1)
        let combinedAttributedString = NSMutableAttributedString()
        
        combinedAttributedString.append(createdAt)
        combinedAttributedString.append(NSAttributedString(string: " "))
        combinedAttributedString.append(textBody)
        
        return combinedAttributedString
    }
}

extension DiaryTableViewCell {
    private func addSubViews() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(diaryTitle)
        contentStackView.addArrangedSubview(dateAndPreview)
    }
    
    private func contentStackViewConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
}
