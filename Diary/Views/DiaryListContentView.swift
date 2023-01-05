//
//  DiaryListContentView.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/22.
//

import UIKit

final class DiaryListContentView: UIView, UIContentView {
    struct Configuration: UIContentConfiguration {
        var title: String?
        var body: String?
        var createdAt: TimeInterval?
        var iconImage: UIImage?

        func makeContentView() -> UIView & UIContentView {
            return DiaryListContentView(configuration: self)
        }

        func updated(for state: UIConfigurationState) -> Configuration {
            return self
        }
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let createdAtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()

    private let weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        return imageView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        return stackView
    }()

    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration)
        }
    }

    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        configureSubViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure(_ configuration: UIContentConfiguration) {
        let iconPlaceholder = UIImage(systemName: "questionmark.circle")
        if let configuration = configuration as? Configuration {
            titleLabel.text = configuration.title
            bodyLabel.text = configuration.body

            if let createdAt = configuration.createdAt {
                createdAtLabel.text = createdAt.currentLocalizedText()
            } else {
                createdAtLabel.text = nil
            }

            if let iconImage = configuration.iconImage {
                weatherIconImageView.image = iconImage
            } else {
                weatherIconImageView.image = iconPlaceholder
            }
        } else {
            titleLabel.text = nil
            bodyLabel.text = nil
            createdAtLabel.text = nil
            weatherIconImageView.image = iconPlaceholder
        }
    }

    private func configureSubViews() {
        addSubview(titleLabel)
        stackView.addArrangedSubview(createdAtLabel)
        stackView.addArrangedSubview(weatherIconImageView)
        stackView.addArrangedSubview(bodyLabel)
        addSubview(stackView)

        createdAtLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        createdAtLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        createdAtLabel.setContentHuggingPriority(.defaultHigh + 1, for: .horizontal)
        createdAtLabel.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        let spacing = CGFloat(8)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            weatherIconImageView.heightAnchor.constraint(equalTo: createdAtLabel.heightAnchor),
            weatherIconImageView.widthAnchor.constraint(equalTo: createdAtLabel.heightAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
