//
//  DiaryListContentView.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/22.
//

import UIKit

final class DiaryListContentView: UIView, UIContentView {
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
        if let configuration = configuration as? DiaryListConfiguration {
            titleLabel.text = configuration.title
            bodyLabel.text = configuration.body

            if let createdAt = configuration.createdAt {
                createdAtLabel.text = DateFormatter.convertToCurrentLocalizedText(timeIntervalSince1970: createdAt)
            } else {
                createdAtLabel.text = nil
            }
        } else {
            titleLabel.text = nil
            bodyLabel.text = nil
            createdAtLabel.text = nil
        }
    }

    private func configureSubViews() {
        addSubview(titleLabel)
        stackView.addArrangedSubview(createdAtLabel)
        stackView.addArrangedSubview(bodyLabel)
        addSubview(stackView)

        createdAtLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        let spacing = CGFloat(8)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: spacing),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -spacing)
        ])
    }
}

struct DiaryListConfiguration: UIContentConfiguration {
    var title: String?
    var body: String?
    var createdAt: Double?

    func makeContentView() -> UIView & UIContentView {
        return DiaryListContentView(configuration: self)
    }

    func updated(for state: UIConfigurationState) -> DiaryListConfiguration {
        return self
    }
}
