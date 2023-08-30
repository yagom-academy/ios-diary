//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/29.
//

import UIKit

final class DiaryCollectionViewListCell: UICollectionViewListCell {
    static let identifier: String = "DiaryCollectionViewListCell"
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.init(800), for: .horizontal)
        
        return label
    }()
    
    private let previewLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        
        return label
    }()
    
    private let titleLabelStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let dateAndPreviewStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        titleLabelStackView.addArrangedSubview(titleLabel)
        dateAndPreviewStackView.addArrangedSubview(dateLabel)
        dateAndPreviewStackView.addArrangedSubview(previewLabel)
        contentView.addSubview(titleLabelStackView)
        contentView.addSubview(dateAndPreviewStackView)
        
        self.accessories = [.disclosureIndicator()]
    }
    
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            titleLabelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            titleLabelStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabelStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabelStackView.bottomAnchor.constraint(equalTo: dateAndPreviewStackView.topAnchor, constant: -8),
            
            dateAndPreviewStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dateAndPreviewStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            dateAndPreviewStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configureLabel(_ data: DiaryEntity) {
        titleLabel.text = data.title
        dateLabel.text = DateFormatter().formatDate(data)
        previewLabel.text = data.body
    }
}
