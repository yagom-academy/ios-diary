//
//  DiaryCell.swift
//  Diary
//
//  Created by 김동욱 on 2022/06/13.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

final class DiaryCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        addSubviews()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: DiaryData) {
        titleLabel.text = data.title
        dateLabel.text = data.date
        bodyLabel.text = data.body
    }
    
    private func addSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(informationStackView)
        
        informationStackView.addArrangedSubviews(dateLabel, bodyLabel)
    }
    
    private func setUpLayout() {
        func setUpTitleLayout() {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
            ])
        }
        
        func setupInfoLayout() {
            NSLayoutConstraint.activate([
                informationStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                informationStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                informationStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                informationStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10)
            ])
        }
        
        setUpTitleLayout()
        setupInfoLayout()
    }
}
