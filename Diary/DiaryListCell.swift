//
//  DiaryListCell.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/20.
//

import UIKit

class DiaryListCell: UITableViewCell {
    static var reuseIdentifier: String {
        return "DiaryListCell"
    }
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
         return label
    }()
    
    lazy var containerStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        configureHierarchy()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.accessoryType = .disclosureIndicator
    }
    
    func configureHierarchy() {
        contentView.addSubview(containerStackView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
        ])
    }
}
