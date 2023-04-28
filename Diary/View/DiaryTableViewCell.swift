//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by rilla, songjun on 2023/04/24.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    static let reuseIdentifier = DiaryTableViewCell.description()
    
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
    
    private lazy var titleLabel: UILabel = createDynamicLabel(font: .title3)
    private lazy var dateLabel: UILabel = createDynamicLabel(font: .body)
    private lazy var contentsLabel: UILabel = createDynamicLabel(font: .caption1)
    
    // MARK: - Method
    
    func configureCell(diary: Diary) {
        configureUIContent(diary)
        configureUI()
        configureLayout()
        configureCellStyle()
    }
    
    private func configureUIContent(_ diary: Diary) {
        titleLabel.text = diary.title
        dateLabel.text = diary.createdDate.convertFormattedDate()
        contentsLabel.text = diary.body
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
    
    private func createDynamicLabel(font: UIFont.TextStyle) -> UILabel {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: font)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }
}
