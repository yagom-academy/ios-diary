//
//  ListCell.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

final class ListCell: UICollectionViewListCell, CellMakeable {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private enum Constants {
        static let verticalStackViewSpacing: CGFloat = 10
        static let horizontalStackViewSpacing: CGFloat = 10
        static let verticalStackViewSpacingFromCellTop: CGFloat = 10
        static let verticalStackViewSpacingFromCellBottom: CGFloat = -10
        static let verticalStackViewSpacingFromCellLeading: CGFloat = 20
        static let verticalStackViewSpacingFromCellTrailing: CGFloat = -15
    }
    
    var titleLabel: UILabel = UILabel()
    var dateLabel: UILabel = UILabel()
    var descriptionLabel: UILabel = UILabel()
    var verticalStackView: UIStackView = UIStackView()
    var horizontalStackView: UIStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeProperties()
        setSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initializeProperties() {
        titleLabel = createLabel(font: .preferredFont(forTextStyle: .title2),
                                 textColor: .black,
                                 alignment: .left)
        dateLabel = createLabel(font: .preferredFont(forTextStyle: .body),
                                textColor: .black,
                                alignment: .left)
        descriptionLabel = createLabel(font: .preferredFont(forTextStyle: .caption1),
                                       textColor: .black,
                                       alignment: .left)
        verticalStackView = createStackView(axis: .vertical,
                                            alignment: .leading,
                                            distribution: .fill,
                                            spacing: Constants.verticalStackViewSpacing)
        horizontalStackView = createStackView(axis: .horizontal,
                                              alignment: .center,
                                              distribution: .fill,
                                              spacing: Constants.horizontalStackViewSpacing)
    }
    
    private func setSubviews() {
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addArrangedSubview(descriptionLabel)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        contentView.addSubview(verticalStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                       constant: Constants.verticalStackViewSpacingFromCellLeading),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                        constant: Constants.verticalStackViewSpacingFromCellTrailing),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor,
                                                   constant: Constants.verticalStackViewSpacingFromCellTop),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                      constant: Constants.verticalStackViewSpacingFromCellBottom)
        ])
        dateLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        dateLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        descriptionLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
}
