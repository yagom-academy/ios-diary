//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import UIKit

protocol IdentifierReusable { }

extension IdentifierReusable {
    static var reuseIdentifier: String {
        return String.init(describing: self)
    }
}

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
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, previewLabel])
        stackView.spacing = 5
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var totalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, bottomStackView])
        stackView.spacing = 5
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    func bindData(_ data: Diary) {
        self.titleLabel.text = data.title
        self.previewLabel.text = data.body
        self.dateLabel.text = data.date.description
    }
}

// MARK: - UIConstraints
extension DiaryCollectionViewCell {
    private func setupUI() {
        self.contentView.addSubview(totalStackView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            totalStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            totalStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
    }
}

extension DiaryCollectionViewCell: IdentifierReusable { }
