//
//  DetailViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class DetailViewController: UIViewController {
    private let detailView = DetailDiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailView
        setNavigation()
    }
    
    private func setNavigation() {
        let date = Formatter.changeCustomDate(Date())
        title = date
    }
}
