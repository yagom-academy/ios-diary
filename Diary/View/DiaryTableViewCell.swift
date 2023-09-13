//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/28.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    static let identifier = "cell"
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 8
        
        return stackView
    }()
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    private let title: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    private let date: UILabel = {
        let label = UILabel()
        
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    private let preview: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    required override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCellSubviews()
        configureCellConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents(diary: DiaryEntity) {
        let formatter = DateFormatter()
        formatter.configureDiaryDateFormat()
        
        self.title.text = diary.title
        self.date.text = formatter.string(from: diary.date)
        self.preview.text = diary.body
    }
    
    private func configureCellSubviews() {
        contentView.addSubview(contentStackView)
        descriptionStackView.addArrangedSubview(date)
        descriptionStackView.addArrangedSubview(preview)
        contentStackView.addArrangedSubview(title)
        contentStackView.addArrangedSubview(descriptionStackView)
    }
    
    private func configureCellConstraint() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
