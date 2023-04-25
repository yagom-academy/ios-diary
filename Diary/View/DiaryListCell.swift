//
//  DiaryListCell.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/25.
//

import UIKit

final class DiaryListCell: UITableViewCell {
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

        return label
    }()
    
    private lazy var innerStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(previewLabel)

        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(innerStackView)

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
    
    func setUpAccessory() {
        self.accessoryType = .disclosureIndicator
    }
    
    func setUpLayout() {
        let safe = contentView.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: safe.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
}
