//
//  DiaryCollectionViewCell.swift
//  Diary
//
//  Created by idinaloq, yetti on 2023/08/29.
//

import UIKit

class DiaryCollectionViewListCell: UICollectionViewListCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "타이블레이블"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "데이트레이블"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    private let previewLabel: UILabel = {
        let label = UILabel()
        label.text = "프리뷰레이블"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
}
