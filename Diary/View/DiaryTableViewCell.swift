//
//  DiaryTalbeViewCell.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/24.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    static let identifier = "DiaryTableViewCell"
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .vertical
        return stackView
    }()
    
    private let subTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureMainStackView()
        configureSubtitleStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureMainStackView() {
        self.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(subTitleStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50)
        ])
    }
    
    private func configureSubtitleStackView() {
        subTitleStackView.addArrangedSubview(dateLabel)
        subTitleStackView.addArrangedSubview(bodyLabel)
    }
    
    func setUpLabel(title: String, date: String, body: String) {
        titleLabel.text = title
        dateLabel.text = date
        bodyLabel.text = body
    }
}
