//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Erick on 2023/08/28.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    
    // MARK: - Static Property
    static let identifier = String(describing: DiaryTableViewCell.self)
    
    // MARK: - Private Property
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAccessory()
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}

// MARK: Setup Data
extension DiaryTableViewCell {
    func setupContent(title: String, creationDate: String, body: String) {
        titleLabel.text = title
        creationDateLabel.text = creationDate
        bodyLabel.text = body
    }
}

// MARK: - Setup UI Object
extension DiaryTableViewCell {
    private func setupAccessory() {
        self.accessoryType = .disclosureIndicator
    }
}

// MARK: - Configure UI
extension DiaryTableViewCell {
    private func configureUI() {
        configureContentView()
    }
    
    private func configureContentView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(creationDateLabel)
        contentView.addSubview(bodyLabel)
    }
}

// MARK: - Setup Constraint
extension DiaryTableViewCell {
    private func setupConstraints() {
        setupTitleLabelConstraints()
        setupCreationDateLabelConstraints()
        setupBodyLabelConstraints()
    }
    
    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])
    }
    
    private func setupCreationDateLabelConstraints() {
        NSLayoutConstraint.activate([
            creationDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            creationDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            creationDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
        
        creationDateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setupBodyLabelConstraints() {
        NSLayoutConstraint.activate([
            bodyLabel.leadingAnchor.constraint(equalTo: creationDateLabel.trailingAnchor, constant: 8),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
