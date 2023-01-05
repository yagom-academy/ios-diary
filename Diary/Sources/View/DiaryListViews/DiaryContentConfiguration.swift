//
//  DiaryContentConfiguration.swift
//  Diary
//
//  Created by hamo and mini on 2022/12/20.
//

import UIKit

struct DiaryContentConfiguration: UIContentConfiguration, Hashable {
    var headerString: String?
    var dateString: String?
    var bodyString: String?
    var imageURL: String?
    
    func makeContentView() -> UIView & UIContentView {
        return DiaryListCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> Self {
        return self
    }
}
