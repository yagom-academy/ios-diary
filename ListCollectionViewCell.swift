//
//  ListCollectionViewCell.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

class ListCollectionViewCell: UICollectionViewCell {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configureContents(with diary: Diary) {
        self.titleLabel.text = diary.title
        self.dateLabel.text = "오늘 날짜"
        self.bodyLabel.text = diary.body
    }
}
