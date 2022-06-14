//
//  MainViewCell.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

class MainViewCell: UITableViewCell {
    
    private enum Constant {
        static let inset: CGFloat = 3
    }
    
    private var titleLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.preferredFont(forTextStyle: .title1)
        return lable
    }()
    
    private var dateLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.preferredFont(forTextStyle: .title1)
        return lable
    }()
    
    private var descriptionLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.preferredFont(forTextStyle: .title1)
        return lable
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [dateLabel, descriptionLabel])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    func setConsantrait() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constant.inset),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constant.inset),
            titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: Constant.inset),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: Constant.inset),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constant.inset),
            stackView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor)
        ])
    }
    
    func setDiaryData(_ data: DiaryData) {
        titleLabel.text = data.title
        dateLabel.text = DiaryDateFormatter.shared.string(from: data.date)
        descriptionLabel.text = data.body
    }
}
