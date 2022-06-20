//
//  DiaryCell.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/14.
//

import UIKit

final class DiaryCell: UITableViewCell {
    static let identifier = "DiaryCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private func setUpCell() {
        addSubviews()
        makeConstraints()
        backgroundColor = .systemBackground
        accessoryType = .disclosureIndicator
    }
    
    private func addSubviews() {
        contentView.addSubview(baseStackView)
        baseStackView.addArrangedSubview(titleLabel)
        baseStackView.addArrangedSubview(bottomStackView)
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            baseStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            baseStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            baseStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    func setUpContents(data: DiaryEntity) {
        if data.title == "" {
            titleLabel.text = "[제목없음]"
        } else {
            titleLabel.text = data.title
        }
        dateLabel.text = data.createdAt.formattedString
        descriptionLabel.text = data.body?.trimmingCharacters(in: .newlines)
    }
}
