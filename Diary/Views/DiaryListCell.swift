//
//  DiaryListCell.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit

final class DiaryListCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "CustomCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
    
    let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.textAlignment = .left
        
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(weatherIconImageView)
        stackView.addArrangedSubview(bodyLabel)
        
        NSLayoutConstraint.activate([
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 28),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor),

            titleLabel.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 10
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            
            stackView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 10
            ),
            stackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 10
            ),
            stackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -10
            ),
            stackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -10
            )
        ])
    }
}
