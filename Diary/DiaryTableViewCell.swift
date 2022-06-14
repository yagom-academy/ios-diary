//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by safari, Eddy on 2022/06/13.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    lazy var baseStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subTextStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        
        return label
    }()
    
    lazy var subTextStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [createdAtLabel, bodyLabel])
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        return stackView
    }()
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(baseStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            baseStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            baseStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.85),
            baseStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        ])
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
