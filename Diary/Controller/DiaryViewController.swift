//
//  DiaryViewController.swift
//  Diary
//
//  Created by Kiwon Song on 2022/08/17.
//

import UIKit

class DiaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setNavigationbar()
    }
   
    private func setNavigationbar() {
        let date = Date().formatted("yyyy년 MM월 dd일")
        self.navigationItem.title = date
    }

}
