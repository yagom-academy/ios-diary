//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/08/29.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    private let diaryTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        
        return label
    }()
    
    private let dateAndPreview: UILabel = {
        let label = UILabel()
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
    
    private func attributedDateAndPreview(data: Diary) -> NSMutableAttributedString {
        let text = "\(formatCreatedAt(data.createdAt)) \(data.body)"
        let attributedString = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .baselineOffset: 2
        ]
        
        attributedString.addAttributes(attributes, range: (text as NSString).range(of: data.body))
        
        return attributedString
    }
    
    private func formatCreatedAt(_ date: Int) -> String {
        
        return DiaryDateFormatter.fetchDate(date, Locale.current.identifier)
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
