//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by 이시원 on 2022/06/13.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var baseStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTextStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        return label
    }()
    
    lazy var subTextStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createdAtLabel, bodyLabel])
        stackView.axis = .vertical
        return stackView
    }()
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()
    
    private func configureLayout() {
        self.addSubview(baseStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: self.topAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            baseStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            baseStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
