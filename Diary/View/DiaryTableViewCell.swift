//
//  DiaryTableViewCell.swift
//  Diary
//
//  Copyright (c) 2022 woong, jeremy All rights reserved.
//

import UIKit

final class DiaryTableViewCell: UITableViewCell {
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var createdAtLabel: UILabel!
    @IBOutlet weak private var bodyLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        createdAtLabel.text = nil
        bodyLabel.text = nil
    }
    
    func configureCell(data: DiaryData) {
        if data.title?.isEmpty == true {
            titleLabel.text = "무제"
        } else {
            titleLabel.text = data.title
        }
        createdAtLabel.text = data.createdAt?.convertDate()
        bodyLabel.text = data.body
        accessoryType = .disclosureIndicator
    }
}
