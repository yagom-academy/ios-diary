//
//  DiaryCell.swift
//  Diary
//
//  Created by hoon, karen on 2023/08/29.
//

import UIKit

final class DiaryCell: UITableViewCell {
    private let titleLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    private let previewLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let contentStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let descriptionStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String, date: String, preview: String) {
        titleLabel.text = title
        dateLabel.text = date
        previewLabel.text = preview
    }
    
    private func configure() {
        configureAccessory()
        configureSubviews()
        configureConstraints()
    }
    
    private func configureAccessory() {
        accessoryType = .disclosureIndicator
    }
    
    private func configureSubviews() {
        configureContentView()
        configureDescriptionStackView()
        configureContentStackView()
    }
    
    private func configureContentView() {
        contentView.addSubview(contentStackView)
    }
    
    private func configureDescriptionStackView() {
        descriptionStackView.addArrangedSubview(dateLabel)
        descriptionStackView.addArrangedSubview(previewLabel)
    }
    
    private func configureContentStackView() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionStackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
}
