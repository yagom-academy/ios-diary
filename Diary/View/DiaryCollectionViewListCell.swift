//
//  DiaryCollectionViewListCell.swift
//  Diary
//
//  Created by Dasan, kyungmin on 2023/08/28.
//

import UIKit

final class DiaryCollectionViewListCell: UICollectionViewListCell {
    private let contentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = .zero
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private let underContentsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = .zero
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let createdDateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupComponents()
        configureUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Setup Data
extension DiaryCollectionViewListCell {
    func setupLabels(_ diary: Diary) {
        titleLabel.text = diary.title
        createdDateLabel.text = String(diary.createdDate)
        previewLabel.text = diary.body
    }
}

// MARK: Setup Components
extension DiaryCollectionViewListCell {
    private func setupComponents() {
        setupDiaryCollectionViewListCell()
    }
    
    private func setupDiaryCollectionViewListCell() {
        self.accessories = [.disclosureIndicator()]
    }
}

// MARK: Configure UI
extension DiaryCollectionViewListCell {
    private func configureUI() {
        configureContentView()
        configureContentsStackView()
        configureUnderContentsStackView()
    }
    
    private func configureContentView() {
        contentView.addSubview(contentsStackView)
    }
    
    private func configureContentsStackView() {
        contentsStackView.addArrangedSubview(titleLabel)
        contentsStackView.addArrangedSubview(underContentsStackView)
    }
    
    private func configureUnderContentsStackView() {
        underContentsStackView.addArrangedSubview(createdDateLabel)
        underContentsStackView.addArrangedSubview(previewLabel)
    }
}

// MARK: Setup Constraint
extension DiaryCollectionViewListCell {
    private func setupConstraint() {
        setupContentsStackViewConstraint()
        setupCreatedDateLabelConstraint()
    }
    
    private func setupContentsStackViewConstraint() {
        NSLayoutConstraint.activate([
            contentsStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            contentsStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            contentsStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    private func setupCreatedDateLabelConstraint() {
        NSLayoutConstraint.activate([
            createdDateLabel.widthAnchor.constraint(equalTo: createdDateLabel.heightAnchor, multiplier: 10)
        ])
    }
}
