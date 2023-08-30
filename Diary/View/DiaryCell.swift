//
//  DiaryCell.swift
//  Diary
//
//  Created by RedMango, Minsup on 2023/08/29.
//

import UIKit

final class DiaryCell: UICollectionViewListCell {
    
    // MARK: - Internal Property
    
    static let id = "DiaryCell"
    
    // MARK: - Private Property
    
    private let outerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let innerStackView: UIStackView = {
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
    
    // MARK: - Internal Method
    
    func configureCell(diary: Diary) {
        addSubviews()
        configureLabel(from: diary)
        constraintOuterStackView()
    }
    
    // MARK: - Private Method
    
    private func addSubviews() {
        contentView.addSubview(outerStackView)
        outerStackView.addArrangedSubview(titleLabel)
        outerStackView.addArrangedSubview(innerStackView)
        innerStackView.addArrangedSubview(createdDateLabel)
        innerStackView.addArrangedSubview(contentLabel)
        
        accessories = [.disclosureIndicator()]
    }
    
    private func configureLabel(from diary: Diary) {
        titleLabel.text = diary.title
        contentLabel.text = diary.body
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.locale = .current
        
        createdDateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: Double(diary.createdDate)))
    }
    
    private func constraintOuterStackView() {
        NSLayoutConstraint.activate([
            outerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            outerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            outerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            outerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }
}
