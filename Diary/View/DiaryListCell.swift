//
//  DiaryListView.swift
//  Diary
//
//  Created by 백곰,주디 on 2022/08/16.
//

import UIKit

class DiaryListCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        titleLabel.adjustsFontForContentSizeCategory = true
        return titleLabel
    }()
    
    private let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.preferredFont(forTextStyle: .body)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        return dateLabel
    }()
    
    private let bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        bodyLabel.adjustsFontForContentSizeCategory = true
        
        return bodyLabel
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 5
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubView()
        setConstraint()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DiaryListCell: ReuseIdentifying {
    private func setConstraint() {
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func addSubView() {
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(dateLabel)
        horizontalStackView.addArrangedSubview(bodyLabel)
        self.contentView.addSubview(verticalStackView)
    }
    
    func configure(with data: Diary) {
        self.titleLabel.text = data.title
        self.dateLabel.text = fetchDate(data: data.createdAt)
        self.bodyLabel.text = data.body
    }
    
    private func fetchDate(data: Double) -> String {
        let formatterDate = DateFormatter()
        formatterDate.dateStyle = .long
        formatterDate.timeStyle = .none
        formatterDate.locale = Locale.current
        
        return formatterDate.string(from: Date(timeIntervalSince1970: data))
    }
}
