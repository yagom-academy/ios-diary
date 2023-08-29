//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by Kobe, Moon on 2023/08/29.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    private let diaryTitle: UILabel = {
        let label = UILabel()
        label.text = "여기는 제목이 들어갈 자리"
        
        return label
    }()
    
    private let dateAndPreview: UILabel = {
        let label = UILabel()
        label.text = "2021년 8월 29일, 작은 글자로 텍스트가 들어갈 자리."
        
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 3
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        addSubViews()
        contentStackViewConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DiaryTableViewCell {
    private func addSubViews() {
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(diaryTitle)
        contentStackView.addArrangedSubview(dateAndPreview)
    }
    
    private func contentStackViewConstraints() {
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
