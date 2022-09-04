//
//  MainTableViewCell.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/17.
//

import UIKit

final class MainTableViewCell: UITableViewCell, ReuseIdentifying {
    private var task: URLSessionDataTask?
    
    private let diaryTitle: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .title2)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let diaryBody: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .caption1)
        label.numberOfLines = 1
        
        return label
    }()
    
    private let diaryDate: UILabel = {
        let label = UILabel()
        label.adjustsFontForContentSizeCategory = true
        label.font = .preferredFont(forTextStyle: .body)
        label.numberOfLines = 1
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    private let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        self.configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureViews() {
        let compressionPriority = diaryBody.contentCompressionResistancePriority(for: .horizontal) + 1
        diaryDate.setContentCompressionResistancePriority(compressionPriority, for: .horizontal)
        
        self.contentView.addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [diaryDate, weatherImageView, diaryBody].forEach {
            horizontalStackView.addArrangedSubview($0)
        }
        
        [diaryTitle, horizontalStackView].forEach {
            verticalStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherImageView.widthAnchor.constraint(equalTo: horizontalStackView.widthAnchor, multiplier: 0.1),
            weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor, multiplier: 1)
        ])
    }
    
    func configure(with content: DiaryContent) {
        self.diaryTitle.text = content.title
        self.diaryDate.text = content.createdAt.dateFormatted()
        self.diaryBody.text = content.body
        task = self.weatherImageView.setImageURL(content.icon)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.task?.suspend()
        self.task?.cancel()
    }
}
