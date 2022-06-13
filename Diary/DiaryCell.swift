//
//  DiaryCell.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/13.
//

import UIKit

final class DiaryCell: UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .callout)
        return label
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        informationStackView.addArrangedSubviews(dateLabel, bodyLabel)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: SampleData) {
        titleLabel.text = data.title
        dateLabel.text = data.date.description
        bodyLabel.text = data.body
    }
    
    private func setUpLayout() {
        func setUpTitleLayout() {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            ])
        }
        
        func setupInfoLayout() {
            NSLayoutConstraint.activate([
                informationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                informationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                informationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
        
        setUpTitleLayout()
        setupInfoLayout()
    }
}
