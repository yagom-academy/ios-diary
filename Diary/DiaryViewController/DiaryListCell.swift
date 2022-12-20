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
        stackView.distribution = .fill
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "일기를 쓰겠습니다. 근데 영어로"
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
        label.text = "2022년 12월 20일"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        
        return label
    }()

    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart."
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 12))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            diaryStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            diaryStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            diaryStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            diaryStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
        previewLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
