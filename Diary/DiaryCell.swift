//
//  DiaryCell.swift
//  Diary
//
//  Created by Andrew, brody on 2023/04/25.
//

import UIKit

final class DiaryCell: UITableViewCell {
    private let titleLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let previewLabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private let contentStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private let diaryStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(diaryStackView)
        contentStackView.addArrangedSubview(dateLabel)
        contentStackView.addArrangedSubview(previewLabel)
        diaryStackView.addArrangedSubview(titleLabel)
        diaryStackView.addArrangedSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            diaryStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            diaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            diaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            diaryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureData(data: DiaryItem, localizedDateFormatter: DateFormatter) {
        titleLabel.text = data.title
        let date = Date(timeIntervalSince1970: TimeInterval(data.date))
        dateLabel.text = localizedDateFormatter.string(from: date)
        previewLabel.text = data.body
    }
}
