//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by SeHong on 2023/04/24.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    
    static let identifier = "DiaryTableViewCell"
    
    private let diaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let diaryDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .caption1)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellData(diaryItem: Diary) {
        titleLabel.text = diaryItem.title
        dateLabel.text = Formatter.changeToString(from: diaryItem.createdAt)
        bodyLabel.text = diaryItem.body
    }
    
    private func setupLayout() {
        contentView.addSubview(diaryStackView)
        
        diaryStackView.addArrangedSubview(titleLabel)
        diaryStackView.addArrangedSubview(diaryDetailStackView)
        NSLayoutConstraint.activate([
            diaryStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            diaryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            diaryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            diaryStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
        
        diaryDetailStackView.addArrangedSubview(dateLabel)
        diaryDetailStackView.addArrangedSubview(bodyLabel)
    }
    
}
