//
//  DetailViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

class DetailViewController: UIViewController {
    let detailView = DiaryDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailView
    }
}
