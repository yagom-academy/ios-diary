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
        
        self.addSubview(diaryInfoStackView)
        
        NSLayoutConstraint.activate([
            diaryInfoStackView.topAnchor.constraint(equalTo: self.topAnchor),
            diaryInfoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            diaryInfoStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            diaryInfoStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func configureLabel(diaryItem: DiaryItem) {
        titleLabel.text = diaryItem.title
        infoLabel.text = String(diaryItem.createDate) + diaryItem.body
    }
}
