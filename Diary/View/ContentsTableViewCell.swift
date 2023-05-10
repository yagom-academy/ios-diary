//
//  ContentsTableViewCell.swift
//  Diary
//
//  Created by KokkilE, Hyemory on 2023/04/24.
//

import UIKit

final class ContentsTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        label.setContentHuggingPriority(.init(rawValue: 1), for: .horizontal)
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = createTitleStackView()
        configureLayout(stackView)
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        weatherIconImageView.image = nil
    }
    
    func configure(title: String, description: String, date: String) {
        titleLabel.text = title
        dateLabel.text = date
        descriptionLabel.text = description.replacingOccurrences(of: "\n", with: "")
    }
    
    func configure(iconImage: UIImage?) {
        weatherIconImageView.image = iconImage
    }
    
    private func createDetailStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [dateLabel,
                                                       weatherIconImageView,
                                                       descriptionLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }
    
    private func createTitleStackView() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [titleLabel,
                                                       createDetailStackView()])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        
        return stackView
    }
    
    private func configureLayout(_ stackView: UIStackView) {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 24),
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
