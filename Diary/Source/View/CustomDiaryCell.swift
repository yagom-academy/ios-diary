//
//  CustomDiaryCell.swift
//  Diary
//  Created by inho, dragon on 2022/12/20.
//

import UIKit

class CustomDiaryCell: UITableViewCell {
    static let identifier = "CustomDiaryCell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        return label
    }()
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)

        accessoryType = .disclosureIndicator
        setUpStackView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpStackView() {
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(bodyLabel)
        
        totalStackView.addArrangedSubview(titleLabel)
        totalStackView.addArrangedSubview(bottomStackView)
    }
    
    private func configureLayout() {
        contentView.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                    constant: 20),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                constant: 10),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                     constant: -20),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                   constant: -10)
        ])
    }
    
    func configureCell(with diary: Diary) {
        titleLabel.text = diary.title
        bodyLabel.text = diary.body
        dateLabel.text = diary.createdDate
    }
}
