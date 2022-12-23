//
//  DiaryListCell.swift
//  Diary
//
//  Copyright (c) 2022 hamo and mini All rights reserved.

import UIKit

final class DiaryListCell: UITableViewCell {
    static let identifier = String(describing: DiaryListCell.self)
    var diary: Diary? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var content = DiaryContentConfiguration().updated(for: state)
        content.headerString = diary?.title
        content.dateString = diary?.createDate
        content.bodyString = diary?.body
        
        contentConfiguration = content
    }
}
