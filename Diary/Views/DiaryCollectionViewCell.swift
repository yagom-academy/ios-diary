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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, previewLabel])
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bottomStackView])
        stackView.spacing = 3
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelStackView, button])
        stackView.spacing = 3
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func bindData(_ data: Diary) {
        self.titleLabel.text = data.title
        self.previewLabel.text = data.body
        self.dateLabel.text = data.customDate
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
        button.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
    }
}

extension DiaryCollectionViewCell: IdentifierReusable { }
