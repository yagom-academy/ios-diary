//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by jin on 12/22/22.
//

import UIKit

class AddDiaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        configureNavigationItem()
    }
    
    private func configureNavigationItem() {
        let currentDate = DateFormatter.conversionLocalDate(date: Date(), local: .current, dateStyle: .long)
        self.navigationItem.title = currentDate
    }

}
