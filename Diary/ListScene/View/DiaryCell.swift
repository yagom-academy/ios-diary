//
//  DiaryCell.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/13.
//

import UIKit

final class DiaryCell: UITableViewCell {
    private var identifier: UUID?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(
            .required,
            for: .horizontal
        )
        label.setContentHuggingPriority(
            .required,
            for: .horizontal
        )
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        
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
        
        accessoryType = .disclosureIndicator
        
        addSubviews()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(informationStackView)
        
        informationStackView.addArrangedSubviews(
            dateLabel,
            bodyLabel
        )
    }
    
    private func setUpLayout() {
        let verticalInset: CGFloat = 10
        let horizontalInset: CGFloat = 20
        
        func setUpTitleLayout() {
            NSLayoutConstraint.activate([
                titleLabel.heightAnchor.constraint(equalTo: informationStackView.heightAnchor),
                titleLabel.topAnchor.constraint(
                    equalTo: contentView.topAnchor,
                    constant: verticalInset
                ),
                titleLabel.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: horizontalInset
                ),
                titleLabel.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -horizontalInset
                )
            ])
        }
        
        func setupInfoLayout() {
            NSLayoutConstraint.activate([
                informationStackView.topAnchor.constraint(
                    equalTo: titleLabel.bottomAnchor,
                    constant: verticalInset
                ),
                informationStackView.bottomAnchor.constraint(
                    equalTo: contentView.bottomAnchor,
                    constant: -verticalInset
                ),
                informationStackView.leadingAnchor.constraint(
                    equalTo: contentView.leadingAnchor,
                    constant: horizontalInset
                ),
                informationStackView.trailingAnchor.constraint(
                    equalTo: contentView.trailingAnchor,
                    constant: -horizontalInset
                )
            ])
        }
        
        setUpTitleLayout()
        setupInfoLayout()
    }
    
    func extractData() -> (
        title: String?,
        identifier: UUID?
    ) {
        return (
            titleLabel.text,
            identifier
        )
    }
    
    func configure(data: DiaryDTO) {
        identifier = data.identifier
        titleLabel.text = data.title
        dateLabel.text = data.dateString
        bodyLabel.text = data.body
    }
}
