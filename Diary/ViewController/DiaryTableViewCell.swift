//
//  DiaryTableViewCell.swift
//  Diary
//
//  Created by yyss99, Jusbug on 2023/08/29.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        createdDateLabel.text = nil
        bodyLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureLabel(sample: Sample) {
        let timeInterval = TimeInterval(sample.createdDate)
        let inputDate = Date(timeIntervalSince1970: timeInterval)

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년 MM월 dd일"
        let formattedDate = outputFormatter.string(from: inputDate)
         
        createdDateLabel.text = formattedDate
        titleLabel.text = sample.title
        bodyLabel.text = sample.body
    }
}
