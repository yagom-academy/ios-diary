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
    
    func configureLabel(sample: Sample) {
        let formattedSampleDate = CustomDateFormatter.formatSampleDate(sampleDate: sample.createdDate)

        createdDateLabel.text = formattedSampleDate
        titleLabel.text = sample.title
        bodyLabel.text = sample.body
    }
}
