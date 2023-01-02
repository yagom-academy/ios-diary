//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by jin on 12/22/22.
//

import UIKit

final class AddDiaryViewController: DiaryViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }
    
    override func configureNavigationItem() {
        super.configureNavigationItem()
        let currentDate = DateFormatter.conversionLocalDate(date: Date(), locale: .current, dateStyle: .long)
        self.navigationItem.title = currentDate
    }
}
