//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureNavigationBar()
    }

    func configureNavigationBar() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .add)
        self.navigationItem.rightBarButtonItem?.target = self
        self.navigationItem.rightBarButtonItem?.action = #selector(tappedAddButton)
    }

    @objc func tappedAddButton(_ sender: UIBarButtonItem) {
        print(#function)
    }
}
