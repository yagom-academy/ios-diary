//
//  CustomCell.swift
//  Diary
//
//  Created by Finnn, 수꿍 on 2022/08/16.
//

import UIKit

class CustomCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "CustomCell"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.setContentCompressionResistancePriority(.required,
                                                      for: .horizontal)
        
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10
        
        return stackView
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,
                                            constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                 constant: -10),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                           constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                constant: -10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                              constant: -10)
        ])
    }
}
