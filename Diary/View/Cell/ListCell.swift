//
//  ListCell.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/15.
//

import UIKit

final class ListCell: UICollectionViewCell, CellMakeable {
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
        titleLabel = createLabel(font: .preferredFont(forTextStyle: .body),
                                 textColor: .black,
                                 alignment: .left)
        dateLabel = createLabel(font: .preferredFont(forTextStyle: .body),
                                textColor: .black,
                                alignment: .left)
        descriptionLabel = createLabel(font: .preferredFont(forTextStyle: .body),
                                       textColor: .black,
                                       alignment: .left)
        verticalStackView = createStackView(axis: .vertical,
                                            alignment: .leading,
                                            distribution: .fillEqually,
                                            spacing: 5)
        horizontalStackView = createStackView(axis: .horizontal,
                                              alignment: .leading,
                                              distribution: .fillEqually,
                                              spacing: 5)
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
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
