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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "titleLabel"
        label.backgroundColor = .red
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "dateLabel"
        label.backgroundColor = .blue
        
        return label
    }()
    
    let previewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "previewLabel"
        label.backgroundColor = .brown
        
        return label
    }()
    
    let subtitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        stackView.backgroundColor = .systemTeal
        
        return stackView
    }()
    
    let accesoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemPurple
        
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
            accesoryImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
