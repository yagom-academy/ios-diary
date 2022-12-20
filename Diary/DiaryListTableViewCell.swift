//
//  DiaryListTableViewCell.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

final class DiaryListTableViewCell: UITableViewCell {
    private var diaryForm: DiaryForm?
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let diaryInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let diaryDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        return stackView
    }()
    
    private let diaryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let disclosureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        return imageView
    }()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        updateContent()
    }
    
    private func configureLayout() {
        contentView.addSubview(cellStackView)
        cellStackView.addSubview(diaryInfoStackView)
        cellStackView.addArrangedSubview(disclosureImageView)
        diaryInfoStackView.addArrangedSubview(diaryTitleLabel)
        diaryInfoStackView.addSubview(diaryDetailStackView)
        diaryDetailStackView.addArrangedSubview(createdDateLabel)
        diaryDetailStackView.addArrangedSubview(previewLabel)
        
        NSLayoutConstraint.activate([
            cellStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
            cellStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            cellStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            cellStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    private func updateContent() {
        diaryTitleLabel.text = diaryForm?.title
        createdDateLabel.text = String(diaryForm?.createdAt ?? 0)
        previewLabel.text = diaryForm?.body
    }
}
