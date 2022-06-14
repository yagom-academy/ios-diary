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
        configureLayout()
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
        stackView.spacing = 10
        
        return stackView
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    lazy private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    lazy private var previewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    private func configureLayout() {
        self.contentView.addSubview(mainStackView)
        self.mainStackView.addArrangedSubview([titleLabel, subStackView])
        self.subStackView.addArrangedSubview([dateLabel, previewLabel])
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        self.accessoryType = .disclosureIndicator
    }
    
    func configureContents(_ diaryArray: Diary) {
        titleLabel.text = diaryArray.title
        dateLabel.text = diaryArray.createdAt
        previewLabel.text = diaryArray.body
    }
}
