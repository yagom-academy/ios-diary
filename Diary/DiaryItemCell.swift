//
//  DiaryItemCell.swift
//  Diary
//
//  Created by Hisop on 2024/01/03.
//

import UIKit

class DiaryItemCell: UITableViewCell {
    static let reuseIdentifier: String = "DiaryItemCell"
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        
        return label
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(subStackView)
        
        return stackView
    }()
    
    private lazy var subStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        autoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabelName(diaryData: Diary) {
        let dateFormatter = DateFormatter()
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(diaryData.createdAt))
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        
        self.titleLabel.text = diaryData.title
        self.dateLabel.text = dateFormatter.string(from: date)
        self.descriptionLabel.text = diaryData.body
    }
}

extension DiaryItemCell {
    private func autoLayout() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
}
