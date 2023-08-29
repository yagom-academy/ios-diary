//
//  DiaryCell.swift
//  Diary
//
//  Created by 김민성 on 2023/08/29.
//

import UIKit

final class DiaryCell: UICollectionViewListCell {
    
    static let id = "DiaryCell"
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return label
    }()
    
    func configureCell(diary: Diary) {
        injectDataIntoLabelText(diary: diary)
        addSubviews()
        layout()
    }
    
    private func injectDataIntoLabelText(diary: Diary) {
        titleLabel.text = diary.title
        createdDateLabel.text = String(diary.createdDate)
        contentLabel.text = diary.body
    }
    
    private func addSubviews() {
        addSubview(cellStackView)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(contentStackView)
        
        contentStackView.addArrangedSubview(createdDateLabel)
        contentStackView.addArrangedSubview(contentLabel)
        
        accessories = [.disclosureIndicator()]
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: topAnchor),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: cellStackView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: cellStackView.trailingAnchor),
            
            createdDateLabel.leadingAnchor.constraint(equalTo: contentStackView.leadingAnchor),
            createdDateLabel.trailingAnchor.constraint(equalTo: contentLabel.leadingAnchor),
            
            contentLabel.trailingAnchor.constraint(equalTo: contentStackView.trailingAnchor)
        ])
    }
}
