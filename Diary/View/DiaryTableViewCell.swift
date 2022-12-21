//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by 서현웅 on 2022/12/21.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
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
    }
}
