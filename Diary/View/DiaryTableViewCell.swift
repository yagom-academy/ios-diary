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
    
    func configureCell(title: String,
                       createdAt: Int,
                       body: String) {
        titleLabel.text = title
        createdAtLabel.text = createdAt.convertDate()
        bodyLabel.text = body
        accessoryType = .disclosureIndicator
    }
}
