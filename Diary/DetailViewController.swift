//
//  DetailViewController.swift
//  Diary
//
//  Created by Kyo, Baem on 2022/12/20.
//

import UIKit

final class DetailViewController: UIViewController {
    private let detailView = DiaryDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = detailView
    }
}
