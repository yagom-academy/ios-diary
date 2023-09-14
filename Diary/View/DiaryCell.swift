//
//  DiaryCell.swift
//  Diary
//
//  Created by hoon, karen on 2023/08/29.
//

import UIKit

final class DiaryCell: UITableViewCell {
    private let titleLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let dateLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    private let weatherIconImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let previewLabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let contentStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let descriptionStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(title: String?, date: String, preview: String?, icon: String?) {
        titleLabel.text = title
        dateLabel.text = date
        previewLabel.text = preview
        
        guard let icon else {
            return
        }
        
        guard let cache = CacheManager.shared.object(forKey: NSString(string: icon)) else {
            fetchIconImage(id: icon)
            return
        }
        
        weatherIconImageView.image = cache
    }
    
    private func fetchIconImage(id: String) {
        let icon = WeatherAPI.weatherIcon(id: id)
        
        NetworkManager.shared.fetchData(API: icon) { [weak self] result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else {
                    return
                }
                
                DispatchQueue.main.async {
                    CacheManager.shared.setObject(image, forKey: NSString(string: id))
                    self?.weatherIconImageView.image = image
                }
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    private func configure() {
        configureAccessory()
        configureSubviews()
        configureConstraints()
    }
    
    private func configureAccessory() {
        accessoryType = .disclosureIndicator
    }
    
    private func configureSubviews() {
        configureContentView()
        configureDescriptionStackView()
        configureContentStackView()
    }
    
    private func configureContentView() {
        contentView.addSubview(contentStackView)
    }
    
    private func configureDescriptionStackView() {
        descriptionStackView.addArrangedSubview(dateLabel)
        descriptionStackView.addArrangedSubview(weatherIconImageView)
        descriptionStackView.addArrangedSubview(previewLabel)
    }
    
    private func configureContentStackView() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionStackView)
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            weatherIconImageView.heightAnchor.constraint(equalTo: dateLabel.heightAnchor),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor)
        ])
    }
}
