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
    
    let subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func configureDiaryCellLayout() {
        self.accessories = [.disclosureIndicator(options: .init(tintColor: .systemGray))]
        [dateLabel, previewLabel].forEach {
            subStackView.addArrangedSubview($0)
        }
        
        [titleLabel, subStackView].forEach {
            totalStackView.addArrangedSubview($0)
        }
        
        self.addSubview(totalStackView)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            totalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
