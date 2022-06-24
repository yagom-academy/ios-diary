//
//  ListCell.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

fileprivate extension DiaryConstants {
    static let verticalStackViewSpacing: CGFloat = 10
    static let horizontalStackViewSpacing: CGFloat = 10
    static let verticalStackViewSpacingFromCellTop: CGFloat = 10
    static let verticalStackViewSpacingFromCellBottom: CGFloat = -10
    static let verticalStackViewSpacingFromCellLeading: CGFloat = 20
    static let verticalStackViewSpacingFromCellTrailing: CGFloat = -15
}

final class ListCell: UICollectionViewListCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
        
    private lazy var horizontalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [dateLabel, descriptionLabel])
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fill
        view.spacing = DiaryConstants.horizontalStackViewSpacing
        return view
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, horizontalStackView])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.alignment = .leading
        view.distribution = .fill
        view.spacing = DiaryConstants.verticalStackViewSpacing
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Method

extension ListCell {
    
    func updateLabels(diaryModel: DiaryModel) {
        titleLabel.text = diaryModel.title
        descriptionLabel.text = diaryModel.body
        dateLabel.text = diaryModel.createdAt.formattedDate
    }
    
    private func setSubviews() {
        contentView.addSubview(verticalStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: DiaryConstants.verticalStackViewSpacingFromCellLeading
            ),
            verticalStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: DiaryConstants.verticalStackViewSpacingFromCellTrailing
            ),
            verticalStackView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: DiaryConstants.verticalStackViewSpacingFromCellTop
            ),
            verticalStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: DiaryConstants.verticalStackViewSpacingFromCellBottom
            )
        ])
        
        dateLabel.setContentHuggingPriority(
            .defaultLow,
            for: .horizontal
        )
        dateLabel.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .horizontal
        )
        descriptionLabel.setContentHuggingPriority(
            .defaultHigh,
            for: .horizontal
        )
        descriptionLabel.setContentCompressionResistancePriority(
            .defaultLow,
            for: .horizontal
        )
    }
}
