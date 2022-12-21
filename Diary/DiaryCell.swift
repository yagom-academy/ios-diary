//
//  DiaryCell.swift
//  Diary
//
//  Created by jin on 12/21/22.
//

import UIKit

class DiaryCell: UITableViewCell {
    static let identifier = "CustomCell"
    
    private let spacing: CGFloat = 10
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(contentLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been impl")
    }
    
    func configureData(title: String?, date: String?, content: String?) {
        self.titleLabel.text = title
        self.dateLabel.text = date
        self.contentLabel.text = content
    }
    
    private func configureConstraints() {
        dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        contentLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: spacing),
            titleLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, constant: -(spacing * 2)),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: spacing),
            stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -spacing),
            stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -spacing),
            
            dateLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
}
