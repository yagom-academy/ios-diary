//
//  DiaryItemCell.swift
//  Diary
//
//  Created by Hisop on 2024/01/03.
//

import UIKit

final class DiaryItemCell: UITableViewCell, ReuseIdentifying {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.spacing = 7
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )
        
        configureUI()
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabelName(diaryData: Diary) {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(diaryData.createdAt))
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        self.titleLabel.text = diaryData.title
        self.dateLabel.text = dateFormatter.string(from: date)
        self.descriptionLabel.text = diaryData.body
    }
}

extension DiaryItemCell {
    private func configureUI() {
        subStackView.addArrangedSubview(dateLabel)
        subStackView.addArrangedSubview(descriptionLabel)
        
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subStackView)
        
        contentView.addSubview(mainStackView)
        self.accessoryType = .disclosureIndicator
    }
    
    private func autoLayout() {
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor)
        ])
    }
}
