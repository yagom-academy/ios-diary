//
//  CustomDiaryCell.swift
//  Diary
//  Created by inho, dragon on 2022/12/20.
//

import UIKit

class CustomDiaryCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let bodyLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        return stackView
    }()
    let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUpStackView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpStackView() {
        bottomStackView.addArrangedSubview(dateLabel)
        bottomStackView.addArrangedSubview(bodyLabel)
        
        totalStackView.addArrangedSubview(titleLabel)
        totalStackView.addArrangedSubview(bottomStackView)
    }
    
    func configureLayout() {
        contentView.addSubview(totalStackView)
        
        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            totalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            totalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
