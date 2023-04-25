//
//  DiaryListCell.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/25.
//

import UIKit

final class DiaryListCell: UITableViewCell {
    static let identifier = #function
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)

        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title3)

        return label
    }()

    private let previewLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return label
    }()
    
    private lazy var innerStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 10
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(previewLabel)

        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 5
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(innerStackView)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpAccessory()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpAccessory() {
        self.accessoryType = .disclosureIndicator
    }
    
    private func setUpLayout() {
        contentView.addSubview(contentStackView)
        
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    func configureLabels(with data: DiarySample) {
        let date = Date(timeIntervalSince1970: data.createdDate)
        
        titleLabel.text = data.title
        dateLabel.text = DateFormatter.diaryForm.localizeDateString(from: date)
        previewLabel.text = data.body
    }
}
