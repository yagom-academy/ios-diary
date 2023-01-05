//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/19.
//

import UIKit

final class CustomListCell: UICollectionViewListCell {
    private let titleLabel = UILabel(textStyle: .title3)
    private let dateLabel = UILabel(textStyle: .body)
    private let previewLabel = UILabel(textStyle: .caption1)
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var imageStackview = UIStackView(subview: [iconImageView],
                                                  spacing: 0,
                                                  axis: .vertical,
                                                  alignment: .fill,
                                                  distribution: .fill)
    
    private lazy var bottomStackView = UIStackView(subview: [dateLabel,
                                                             imageStackview,
                                                             previewLabel],
                                                   spacing: 5,
                                                   axis: .horizontal,
                                                   alignment: .firstBaseline,
                                                   distribution: .fill)
    
    private lazy var labelStackView = UIStackView(subview: [titleLabel, bottomStackView],
                                                  spacing: 5,
                                                  axis: .vertical,
                                                  alignment: .leading,
                                                  distribution: .fillEqually)

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(_ data: DiaryData) {
        guard var contents = data.contentText?.components(separatedBy: "\n") else { return }
        self.titleLabel.text = contents.removeFirst()
        self.previewLabel.text = contents.joined(separator: " ")
        guard let date = data.createdAt else { return }
        self.dateLabel.text = Formatter.changeCustomDate(date)
    }
    
    func setupImage(image: UIImage? = nil) {
        guard let image = image else {
            self.iconImageView.image = nil
            return
        }

        self.iconImageView.image = image
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
                equalTo: self.contentView.trailingAnchor, constant: -20),
            
            imageStackview.widthAnchor.constraint(
                equalTo: imageStackview.heightAnchor),
            imageStackview.heightAnchor.constraint(
                lessThanOrEqualTo: dateLabel.heightAnchor)
        ])
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
