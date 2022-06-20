//
//  MainViewCell.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

final class MainViewCell: UITableViewCell {
    private enum Constant {
        static let lineInset: CGFloat = 8
        static let sideInset: CGFloat = 20
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        setConsantrait()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("셀 생성 중 에러 생김")
    }
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        contentView.addSubview(label)
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, descriptionLabel])
        contentView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = Constant.lineInset
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func setConsantrait() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constant.lineInset),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: Constant.sideInset),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -Constant.lineInset),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -Constant.lineInset),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constant.lineInset),
            stackView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
        ])
    }
    
    func setDiaryData(_ data: DiaryData) {
        titleLabel.text = data.title
        dateLabel.text = data.date.toString
        descriptionLabel.text = data.body
    }
}
