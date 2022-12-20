//
//  DiaryListTableViewCell.swift
//  Diary
//
//  Created by SummerCat and som on 2022/12/20.
//

import UIKit

final class DiaryListTableViewCell: UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
    
    var diaryForm: DiaryForm? {
        didSet {
            updateContent()
        }
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
    }
    
    private func configureLayout() {
        contentView.addSubview(diaryInfoStackView)
        diaryInfoStackView.addArrangedSubview(diaryTitleLabel)
        diaryInfoStackView.addArrangedSubview(diaryDetailStackView)
        diaryDetailStackView.addArrangedSubview(createdDateLabel)
        diaryDetailStackView.addArrangedSubview(previewLabel)
        
        NSLayoutConstraint.activate([
            diaryInfoStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            diaryInfoStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
            diaryInfoStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 4),
            diaryInfoStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -4)
        ])
    }
    
    private func updateContent() {
        diaryTitleLabel.text = diaryForm?.title
        createdDateLabel.text = String(diaryForm?.createdAt ?? 0)
        previewLabel.text = diaryForm?.body
    }
}
