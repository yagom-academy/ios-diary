//
//  AddViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class AddViewController: UIViewController {
    private let addView = AddDiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addView
        setNavigation()
    }
    
    private func setNavigation() {
        let date = Formatter.changeCustomDate(Date())
        self.title = date
    }
}
