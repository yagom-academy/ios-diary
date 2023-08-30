//
//  MainTableViewCell.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    static let reuseIdentifier = "MainTableViewCell"
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 10)
        label.setContentHuggingPriority(.init(1), for: .horizontal)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        setUpConstraints()
        setUpAccessory()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpContents(title: String, date: String, body: String) {
        titleLabel.text = title
        dateLabel.text = date
        previewLabel.text = body
    }
}

// MARK: - Private
extension MainTableViewCell {
    private func configureUI() {
        [dateLabel, previewLabel].forEach {
            contentsStackView.addArrangedSubview($0)
        }
        
        [titleLabel, contentsStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(mainStackView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    private func setUpAccessory() {
        accessoryType = .disclosureIndicator
    }
}
