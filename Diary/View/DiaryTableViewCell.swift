//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/24.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    static let reuseIdentifier = "DiaryTableViewCell"
    
    // MARK: - Property
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let subTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
    
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()
    
    // MARK: - Method
    
    func configureCell(diary: Diary) {
        titleLabel.text = diary.title
        dateLabel.text = diary.createdAt.convertFormattedDate()
        contentsLabel.text = diary.body
        
        configureUI()
        configureLayout()
        configureCellStyle()
    }
    
    private func configureUI() {
        self.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subTitleStackView)
        
        subTitleStackView.addArrangedSubview(dateLabel)
        subTitleStackView.addArrangedSubview(contentsLabel)
    }
    
    private func configureLayout() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            mainStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            mainStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            dateLabel.widthAnchor.constraint(equalTo: subTitleStackView.widthAnchor, multiplier: 0.41)
        ])
    }
    
    private func configureCellStyle() {
        self.accessoryType = .disclosureIndicator
    }
}
