//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import UIKit

final class CustomListCell: UICollectionViewListCell {
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
    
    func bindData(_ data: DiaryData) {
        guard var contents = data.contentText?.components(separatedBy: "\n") else { return }
        self.titleLabel.text = contents.removeFirst()
        self.previewLabel.text = contents.joined(separator: " ")
        guard let date = data.createdAt else { return }
        self.dateLabel.text = Formatter.changeCustomDate(date)
    }
}

// MARK: - UIConstraints
extension CustomListCell {
    private func setupUI() {
        contentView.addSubview(labelStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(
                equalTo: self.contentView.topAnchor, constant: 5),
            labelStackView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor, constant: -5),
            labelStackView.leadingAnchor.constraint(
                equalTo: self.contentView.leadingAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(
                equalTo: self.contentView.trailingAnchor, constant: -20)
        ])
    }
}
