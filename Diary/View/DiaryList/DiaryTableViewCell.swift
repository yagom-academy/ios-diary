//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let dateAndDescriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    private let diaryTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3, compatibleWith: nil)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1, compatibleWith: nil)
        
        return label
    }()
    
    private let shortDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption2, compatibleWith: nil)
        
        return label
    }()
    
    static let identifier = "DiaryTableViewCell"
    private var diaryListViewModel: DiaryViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        setupDateLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureUI(data: DiaryContent) {
        diaryListViewModel = DiaryViewModel(data: data)
        
        diaryTitleLabel.text = diaryListViewModel?.titleText
        dateLabel.text = diaryListViewModel?.dateText
        shortDescriptionLabel.text = diaryListViewModel?.shortDescriptionText
    }
    
    private func configureLayout() {
        self.contentView.addSubview(rootStackView)
        
        rootStackView.addArrangedSubview(diaryTitleLabel)
        rootStackView.addArrangedSubview(dateAndDescriptionStackView)
        
        dateAndDescriptionStackView.addArrangedSubview(dateLabel)
        dateAndDescriptionStackView.addArrangedSubview(shortDescriptionLabel)
        
        NSLayoutConstraint.activate([
            rootStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            rootStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    private func setupDateLabel() {
        let standardPriority = shortDescriptionLabel.contentCompressionResistancePriority(for: .horizontal)
        
        dateLabel.setContentCompressionResistancePriority(standardPriority + 1, for: .horizontal)
    }
}
