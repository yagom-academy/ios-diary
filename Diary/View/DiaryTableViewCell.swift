//  Diary - DiaryTableViewCell.swift
//  created by vetto on 2023/04/24

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let diaryInfoStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell() {
        diaryInfoStackView.addArrangedSubview(titleLabel)
        diaryInfoStackView.addArrangedSubview(infoLabel)
        
        self.contentView.addSubview(diaryInfoStackView)
        
        NSLayoutConstraint.activate([
            diaryInfoStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                    constant: 8),
            diaryInfoStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                       constant: -8),
            diaryInfoStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                        constant: 8),
            diaryInfoStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                         constant: -8)
        ])
    }
    
    func configureLabel(diaryItem: DiaryItem) {
        titleLabel.text = diaryItem.title
        infoLabel.text = String(diaryItem.createDate) + diaryItem.body
    }
}
