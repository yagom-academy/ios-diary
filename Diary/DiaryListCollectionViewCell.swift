//
//  DiaryListCollectionViewCell.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/16.
//

import UIKit

class DiaryListCollectionViewCell: UICollectionViewCell {
    // MARK: - properties
    
    static let identifier = "cell"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        
        return label
    }()
    
    private let subtitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        
        return stackView
    }()
    
    private let accesoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // MARK: - initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit() {
        setupSubviews()
        setupConstraints()
    }
    
    // MARK: - functions
    
    func setupCellProperties(with model: JSONModel) {
        titleLabel.text = model.title
        previewLabel.text = model.body
        dateLabel.text = model.createdAt.convertToString()
    }
    
    private func setupSubviews() {
        [dateLabel, previewLabel].forEach { subtitleStackView.addArrangedSubview($0) }
        [titleLabel, subtitleStackView, accesoryImageView].forEach { self.addSubview($0) }
    }
    
    private func setupConstraints() {
        setupTitleLabelConstraints()
        setupSubtitleStackViewConstraints()
        setupAccesoryImageViewConstraints()
    }
    
    private func setupTitleLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: accesoryImageView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: subtitleStackView.topAnchor)
        ])
    }
    
    private func setupSubtitleStackViewConstraints() {
        NSLayoutConstraint.activate([
            subtitleStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subtitleStackView.trailingAnchor.constraint(equalTo: accesoryImageView.leadingAnchor),
            subtitleStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupAccesoryImageViewConstraints() {
        NSLayoutConstraint.activate([
            accesoryImageView.topAnchor.constraint(equalTo: topAnchor),
            accesoryImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            accesoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            accesoryImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.16)
        ])
    }
}
