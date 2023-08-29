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
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
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
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return label
    }()
    
    func configureCell(diary: Diary) {
        injectDataIntoLabelText(diary: diary)
        addSubviews()
        configureLayoutConstraint()
    }
    
    private func injectDataIntoLabelText(diary: Diary) {
        titleLabel.text = diary.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .current
        
        createdDateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(diary.createdDate)))
        contentLabel.text = diary.body
    }
    
    private func addSubviews() {
        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(titleLabel)
        cellStackView.addArrangedSubview(contentStackView)
        contentStackView.addArrangedSubview(createdDateLabel)
        contentStackView.addArrangedSubview(contentLabel)
        
        accessories = [.disclosureIndicator()]
    }
    
    func configureLayoutConstraint() {
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}
