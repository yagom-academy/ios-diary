//
//  DiaryInfoTableViewCell.swift
//  Diary
//
//  Created by kaki, 레옹아범 on 2023/04/25.
//

import UIKit

final class DiaryInfoTableViewCell: UITableViewCell {
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    private var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, bodyLabel])
        
        stackView.spacing = 5
        
        let mainStackView = UIStackView(arrangedSubviews: [titleLabel, stackView])
        
        mainStackView.axis = .vertical
        mainStackView.spacing = 5
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 3),
            mainStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15),
            mainStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3),
            mainStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -3)
        ])
    }
    
    func configureLabel(item: DiaryModel) {
        titleLabel.text = item.title
        dateLabel.text = Date.convertToDate(by: item.date)
        bodyLabel.text = item.body
    }
}
