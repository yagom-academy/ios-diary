//
//  DiaryListCell.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import UIKit

final class DiaryListCell: UITableViewCell {
    static let identifier: String = "DiaryListCell"
    
    let diaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true

        return label
    }()

    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 4

        return stackView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()

    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(diaryStackView)
        self.accessoryType = .disclosureIndicator
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabelText(from content: DiaryContent) {
        titleLabel.text = content.title
        dateLabel.text = "\(content.createdAt)"
        previewLabel.text = content.body
    }

    private func configureStackView() {
        [titleLabel, informationStackView].forEach { view in
            self.diaryStackView.addArrangedSubview(view)
        }

        [dateLabel, previewLabel].forEach { label in
            self.informationStackView.addArrangedSubview(label)
        }
        
        configureConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            diaryStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            diaryStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            diaryStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            diaryStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8)
        ])
        previewLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
