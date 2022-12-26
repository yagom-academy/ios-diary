//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import UIKit

final class DiaryCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let titleLabel = UILabel(textStyle: .title3)
    private let dateLabel = UILabel(textStyle: .body)
    private let previewLabel = UILabel(textStyle: .caption1)
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private lazy var bottomStackView = UIStackView(subview: [dateLabel, previewLabel],
                                                   spacing: 5,
                                                   axis: .horizontal,
                                                   alignment: .firstBaseline,
                                                   distribution: .fill)
    private lazy var labelStackView = UIStackView(subview: [titleLabel, bottomStackView],
                                                  spacing: 3,
                                                  axis: .vertical,
                                                  alignment: .leading,
                                                  distribution: .fillEqually)
    private lazy var totalStackView = UIStackView(subview: [labelStackView, button],
                                                  spacing: 3,
                                                  axis: .horizontal,
                                                  alignment: .center,
                                                  distribution: .fill)
    
    func bindData(_ data: DiaryData) {
        self.titleLabel.text = data.title
        self.previewLabel.text = data.body
        guard let date = data.createdAt else { return }
        self.dateLabel.text = Formatter.changeCustomDate(date)
    }
}

// MARK: - UIConstraints
extension DiaryCollectionViewCell {
    private func setupUI() {
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 1
        contentView.addSubview(totalStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            totalStackView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor, constant: 5),
            totalStackView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor, constant: -5),
            totalStackView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor, constant: 20),
            totalStackView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor, constant: -20)
            
        ])
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
