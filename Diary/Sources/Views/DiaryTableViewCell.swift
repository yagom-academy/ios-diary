//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by yeton, hyeon2 on 2022/08/17.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell, ReuseIdentifying {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        
        return label
    }()
    
    private let dateLabel: UILabel = {
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
    
    private let previewLabel: UILabel = {
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
        
        configureLayout()
        configureAccessoryType()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    func setupComponents(item: DiaryContents) {
        guard let title = item.title,
              let body = item.body else {
            return
        }
        
        titleLabel.text = title
        
        dateLabel.text = DateFormatter.localizedString(
            from: Date(timeIntervalSince1970: item.createdAt),
            dateStyle: .long,
            timeStyle: .none
        )

        let bodyRemovedTitle = body.components(separatedBy: title)
        
        previewLabel.text = bodyRemovedTitle.last?.replacingOccurrences(of: "\n", with: "")
    }
    
    private func configureLayout() {
        contentView.addSubview(entireVerticalStackView)
        
        entireVerticalStackView.addArrangedSubview(titleLabel)
        entireVerticalStackView.addArrangedSubview(bottomHorizontalStackView)
        
        bottomHorizontalStackView.addArrangedSubview(dateLabel)
        bottomHorizontalStackView.addArrangedSubview(previewLabel)
        
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
    
    private func configureAccessoryType() {
        accessoryType = .disclosureIndicator
    }
}
