//
//  Diary - ViewController.swift
//  Created by Donnie, OneTool. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    lazy var mainView = MainView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
    }
    
}

