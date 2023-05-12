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
        label.font = .preferredFont(forTextStyle: .title1)
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
    
    private let weatherImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        stackView.alignment = .leading
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
        contentStackView.addArrangedSubview(weatherImageView)
        contentStackView.addArrangedSubview(previewLabel)
        diaryStackView.addArrangedSubview(titleLabel)
        diaryStackView.addArrangedSubview(contentStackView)
        
        NSLayoutConstraint.activate([
            weatherImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.05) ,
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor),
            
            diaryStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            diaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            diaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            diaryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureData(data: Diary, localizedDateFormatter: DateFormatter) {
        titleLabel.text = data.title.isEmpty ? "새로운 일기장".localized() : data.title
        dateLabel.text = localizedDateFormatter.string(from: data.createdAt)
        previewLabel.text = data.body
        
        let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(data.weatherIcon)@2x.png")
        guard let imageUrl else {
            return
        }
        ImageUtility.fetchImage(imageURL: imageUrl) { imageData in
            DispatchQueue.main.async {
                self.weatherImageView.image = UIImage(data: imageData)
            }
        }
    }
}
