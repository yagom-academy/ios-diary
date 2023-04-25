//
//  DiaryCell.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/25.
//

import UIKit

final class DiaryCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let previewLabel = UILabel()
    private let contentStackView = UIStackView()
    private let diaryStackView = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        configureTitleLabel()
        configureDateLabel()
        configurePreviewLabel()
        configureContentStackView()
        configureDiaryStackView()
        contentView.addSubview(diaryStackView)
        
        NSLayoutConstraint.activate([
            diaryStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            diaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            diaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            diaryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func configureDateLabel() {
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        dateLabel.font = .preferredFont(forTextStyle: .title3)
        dateLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func configurePreviewLabel() {
        previewLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        previewLabel.font = .preferredFont(forTextStyle: .caption1)
        previewLabel.adjustsFontForContentSizeCategory = true
    }
    
    private func configureContentStackView() {
        contentStackView.axis = .horizontal
        contentStackView.spacing = 10
        contentStackView.alignment = .center
        contentStackView.addArrangedSubview(dateLabel)
        contentStackView.addArrangedSubview(previewLabel)
    }
    
    private func configureDiaryStackView() {
        diaryStackView.axis = .vertical
        diaryStackView.spacing = 5
        diaryStackView.translatesAutoresizingMaskIntoConstraints = false
        diaryStackView.addArrangedSubview(titleLabel)
        diaryStackView.addArrangedSubview(contentStackView)
        diaryStackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        diaryStackView.isLayoutMarginsRelativeArrangement = true
    }
    
    func configureData(data: DiaryItem) {
        titleLabel.text = data.title
        let date = Date(timeIntervalSince1970: TimeInterval(data.date))
        dateLabel.text = Date.dateFormatter.string(from: date)
        previewLabel.text = data.body
    }
}
