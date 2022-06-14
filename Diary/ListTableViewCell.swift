//
//  ListTableViewCell.swift
//  Diary
//
//  Created by 두기, marisol on 2022/06/14.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    lazy private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 8
        
        return stackView
    }()
    
    lazy private var subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        return stackView
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "타이틀 입니다"
        
        return label
    }()
    
    lazy private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = "2020년 12월 23일"
        
        return label
    }()
    
    lazy private var previewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of e"
        
        return label
    }()
    
    private func configureView() {
        self.contentView.addSubview(mainStackView)
        self.mainStackView.addArrangedSubview([titleLabel, subStackView])
        self.subStackView.addArrangedSubview([dateLabel, previewLabel])
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.35)
        ])
        self.accessoryType = .disclosureIndicator
    }
}
