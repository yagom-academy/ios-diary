//
//  DiaryListTableViewCell.swift
//  Diary
//
//  Created by by Maxhyunm, Hamg on 2023/08/29.
//

import UIKit

final class DiaryListTableViewCell: UITableViewCell {
    static let identifier: String = "cell"
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption2)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabel()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        weatherIconImageView.image = nil
    }
    
    private func setupLabel() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherIconImageView)
        contentView.addSubview(bodyLabel)
    }
    
    private func configureUI() {
        accessoryType = .disclosureIndicator
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            weatherIconImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            weatherIconImageView.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 15),
            weatherIconImageView.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            weatherIconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.05),
            weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: weatherIconImageView.trailingAnchor, constant: 15),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            bodyLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor)
        ])
    }
    
    func setModel(title: String, date: String, body: String, icon: String?) {
        titleLabel.text = title
        dateLabel.text = date
        bodyLabel.text = body
        
        if let icon {
            guard let cachedImage = ImageCachingManager.shared.object(forKey: NSString(string: icon)) else {
                setImageView(icon: icon)
                return
            }
            weatherIconImageView.image = cachedImage
        }
    }
    
    func setImageView(icon: String) {
        NetworkManager.shared.fetchData(NetworkConfiguration.weatherIcon(id: icon)) { [weak self] result in
            switch result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    ImageCachingManager.shared.setObject(image, forKey: NSString(string: icon))
                    self?.weatherIconImageView.image = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
