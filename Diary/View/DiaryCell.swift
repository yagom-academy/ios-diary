//
//  DiaryCell.swift
//  Diary
//
//  Created by 써니쿠키, LJ on 2022/12/20.
//

import UIKit

final class DiaryCell: UICollectionViewListCell {
    
    let titleLabel = CustomLabel()
    let dateLabel = CustomLabel(font: .subheadline)
    let previewLabel = CustomLabel(font: .caption2)
    
    private let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    func configureDiaryCellLayout() {
        configureAccessories()
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        [dateLabel, previewLabel].forEach { subStackView.addArrangedSubview($0) }
        [titleLabel, subStackView].forEach { totalStackView.addArrangedSubview($0) }
        contentView.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    private func configureAccessories() {
        self.accessories = [.disclosureIndicator(options: .init(tintColor: .systemGray))]
    }
}
