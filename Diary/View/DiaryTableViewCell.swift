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
    private let diaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let dateAndBodyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        
        return stackView
    }()
    
    private let creationDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        
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
        self.selectionStyle = .none
    }
}

// MARK: - Configure UI
extension DiaryTableViewCell {
    private func configureUI() {
        configureContentView()
        configureDiaryStackView()
        configureDateAndBodyStackView()
    }
    
    private func configureContentView() {
        contentView.addSubview(diaryStackView)
    }
    
    private func configureDiaryStackView() {
        diaryStackView.addArrangedSubview(titleLabel)
        diaryStackView.addArrangedSubview(dateAndBodyStackView)
    }
    
    private func configureDateAndBodyStackView() {
        dateAndBodyStackView.addArrangedSubview(creationDateLabel)
        dateAndBodyStackView.addArrangedSubview(bodyLabel)
    }
}

// MARK: - Setup Constraint
extension DiaryTableViewCell {
    private func setupConstraints() {
        setupDiaryStackViewConstraints()
    }
    
    private func setupDiaryStackViewConstraints() {
        NSLayoutConstraint.activate([
            diaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            diaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            diaryStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            diaryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
}
