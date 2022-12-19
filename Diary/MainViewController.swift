//
//  Diary - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    private let mainDiaryView = MainDiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainDiaryView
    }
}
