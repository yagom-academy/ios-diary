//
//  DiaryListCell.swift
//  Diary
//
//  Created by JPush, Wonbi on 2022/12/20.
//

import UIKit

final class DiaryListCell: UITableViewCell {
    let diaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical

        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal

        return stackView
    }()

    let dateLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    let previewLabel: UILabel = {
        let label = UILabel()

        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureStackView() {
        [titleLabel, informationStackView].forEach { view in
            self.diaryStackView.addArrangedSubview(view)
        }

        [dateLabel, previewLabel].forEach { label in
            self.informationStackView.addArrangedSubview(label)
        }
        
        configureConstraints()
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            diaryStackView.topAnchor.constraint(equalTo: self.topAnchor),
            diaryStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            diaryStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            diaryStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
