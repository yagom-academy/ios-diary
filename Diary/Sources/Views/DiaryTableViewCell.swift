//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/17.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    private let diaryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private let diaryDateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )
        
        return label
    }()
    
    private let diaryPreviewLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption2)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bottomHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let entireVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        setConstraint()
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setComponents(item: DiarySample) {
        diaryTitleLabel.text = item.title
        diaryDateLabel.text = DateFormatter().format(
            data: Date(timeIntervalSince1970: item.createdAt)
        )
        diaryPreviewLabel.text = item.body
    }
    
    private func setConstraint() {
        contentView.addSubview(entireVerticalStackView)
        
        entireVerticalStackView.addArrangedSubview(diaryTitleLabel)
        entireVerticalStackView.addArrangedSubview(bottomHorizontalStackView)
        
        bottomHorizontalStackView.addArrangedSubview(diaryDateLabel)
        bottomHorizontalStackView.addArrangedSubview(diaryPreviewLabel)
        
        NSLayoutConstraint.activate([
            entireVerticalStackView.topAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.topAnchor,
                constant: 5
            ),
            entireVerticalStackView.trailingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.trailingAnchor,
                constant: -15
            ),
            entireVerticalStackView.bottomAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.bottomAnchor,
                constant: -5
            ),
            entireVerticalStackView.leadingAnchor.constraint(
                equalTo: contentView.safeAreaLayoutGuide.leadingAnchor,
                constant: 15
            )
        ])
    }
}
