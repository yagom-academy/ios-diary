//
//  DiaryCell.swift
//  Diary
//
//  Created by RedMango, Minsup on 2023/08/29.
//

import UIKit

final class DiaryCell: UICollectionViewListCell {
    
    // MARK: - Internal Property
    
    static let id = "DiaryCell"
    
    // MARK: - Private Property
    
    private var currentFormatter: DateFormattable?
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .left
        
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return label
    }()
    
    private lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Internal Method
    
    func configureCell(diary: Diary, formatter: DateFormattable) {
        initFormatter(formatter: formatter)
        addSubviews()
        configureLabel(from: diary)
        configureWeatherImage(from: diary)
        constraintOuterStackView()
        constraintWeatherIcon()
    }
    
    // MARK: - Private Method
    
    private func initFormatter(formatter: DateFormattable) {
        self.currentFormatter = formatter
    }
    
    private func addSubviews() {
        contentView.addSubview(verticalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(createdDateLabel)
        horizontalStackView.addArrangedSubview(weatherImage)
        horizontalStackView.addArrangedSubview(contentLabel)
        accessories = [.disclosureIndicator()]
    }
    
    private func configureWeatherImage(from diary: Diary) {
        if let pngData = diary.weatherImage {
            weatherImage.image = UIImage(data: pngData)
        }
    }
    
    private func configureLabel(from diary: Diary) {
        titleLabel.text = diary.title
        contentLabel.text = diary.content
        createdDateLabel.text = currentFormatter?.format(date: diary.createdDate ?? Date(), style: .long)
    }
    
    private func constraintOuterStackView() {
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    private func constraintWeatherIcon() {
        NSLayoutConstraint.activate([
            weatherImage.heightAnchor.constraint(equalToConstant: 24.0),
            weatherImage.widthAnchor.constraint(equalToConstant: 24.0)
        ])
    }
}
