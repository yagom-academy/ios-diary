//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by MINT, BMO on 2023/08/28.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    static let identifier = "cell"
    
    let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.text = "TITLE"
        
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.text = "23.08.28"
        
        return label
    }()
    
    let preview: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요? 비모와 민트입니다."
        
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        contentView.addSubview(contentStackView)
        descriptionStackView.addArrangedSubview(date)
        descriptionStackView.addArrangedSubview(preview)
        contentStackView.addArrangedSubview(title)
        contentStackView.addArrangedSubview(descriptionStackView)
        
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
