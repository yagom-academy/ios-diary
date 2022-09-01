//
//  DiaryListCollectionViewCell.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/16.
//

import UIKit

final class DiaryListCollectionViewCell: UICollectionViewCell {
    // MARK: - properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.adjustsImageSizeForAccessibilityContentSizeCategory = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .footnote)
        
        return label
    }()
    
    private let subtitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Design.stackViewSpacing
        
        return stackView
    }()
    
    private let accessoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonImage = UIImage(systemName: Design.accessoryImageName)
        
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .lightGray
        
        return button
    }()
    
    // MARK: - initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - functions
    
    func setupCellProperties(with model: Diary) {
        titleLabel.text = model.title
        dateLabel.text = model.createdAt.convert1970DateToString()
        setupWeatherImageView(icon: model.icon)
        guard let body = model.body.split(separator: "\n").first else { return }
        previewLabel.text = String(body)
    }
    
    private func setupSubviews() {
        [dateLabel, weatherImageView, previewLabel]
            .forEach { subtitleStackView.addArrangedSubview($0) }
        
        [titleLabel, subtitleStackView, accessoryButton]
            .forEach { self.addSubview($0) }
    }
    
    private func setupWeatherImageView(icon: String) {
        DispatchQueue.main.async {
            self.weatherImageView.leadingAnchor.constraint(equalTo: self.dateLabel.trailingAnchor).isActive = true
            self.dateLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            self.weatherImageView.widthAnchor.constraint(equalTo: self.subtitleStackView.widthAnchor, multiplier: 0.1).isActive = true
            
            self.weatherImageView.loadView(imageID: icon)
        }
    }
    
    private func setupConstraints() {
        setupTitleLabelConstraints()
        setupSubtitleStackViewConstraints()
        setupAccessoryImageViewConstraints()
    }
    
    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: accessoryButton.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleStackView.topAnchor)
        ])
    }
    
    private func setupSubtitleStackViewConstraints() {
        NSLayoutConstraint.activate([
            subtitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleStackView.trailingAnchor.constraint(equalTo: accessoryButton.leadingAnchor),
            subtitleStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func setupAccessoryImageViewConstraints() {
        NSLayoutConstraint.activate([
            accessoryButton.topAnchor.constraint(equalTo: topAnchor),
            accessoryButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            accessoryButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            accessoryButton.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.16)
        ])
    }
}

extension DiaryListCollectionViewCell: ReuseIdentifiable { }

private enum Design {
    static let topLineColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
    static let stackViewSpacing = 4.0
    static let accessoryImageName = "chevron.right"
}
