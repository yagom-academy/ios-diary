//
//  DiaryListCell.swift
//  Diary
//
//  Copyright (c) 2022 hamo and mini All rights reserved.

import UIKit

final class DiaryListCell: UITableViewCell {
    static let identifier = String(describing: DiaryListCell.self)
    var number: Int? {
        didSet {
            setNeedsUpdateConfiguration()
        }
    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        accessoryType = .disclosureIndicator
        var content = DiaryContentConfiguration().updated(for: state)
        content.headerString = number?.description
        content.dateString = number?.description
        content.bodyString = number?.description
        
        contentConfiguration = content

    }
}
