//
//  Diary - DiaryListCell.swift
//  Created by Rhode, 무리.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class DiaryListCell: UITableViewCell {
    static let identifier = "DiaryListCell"
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .horizontal)
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textAlignment = .right
        
        return label
    }()
    
    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubViews()
        configureConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContent(data: Diary) {
        titleLabel.text = data.title
        bodyLabel.text = data.body.removeNewLinePrefix()
        dateLabel.text = Date(timeIntervalSince1970: data.date).convertDate()
        
        guard let url = URL(string: imageURLString(diary: data)) else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.iconImage.image = image
                    }
                }
            }
        }
    }
    
    private func imageURLString(diary: Diary) -> String {
        guard let iconName = diary.iconName else { return "" }
        
        let baseURL = "https://openweathermap.org/img/wn/"
        let resolution = "@2x.png"
        
        return baseURL + iconName + resolution
    }
    
    private func configureSubViews() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(detailStackView)
        detailStackView.addArrangedSubview(dateLabel)
        detailStackView.addArrangedSubview(iconImage)
        detailStackView.addArrangedSubview(bodyLabel)
    }
    
    private func configureConstraint() {
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            iconImage.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, multiplier: 1/10),
            iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor)
        ])
    }
}
