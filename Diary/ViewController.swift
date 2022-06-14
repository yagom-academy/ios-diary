//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    private lazy var mainView = MainView.init(frame: view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
    }
}
