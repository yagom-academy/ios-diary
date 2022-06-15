//
//  Diary - ViewController.swift
//  Created by Donnie, OneTool. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    
    private enum Constants {
        static let navigationBarTitle = "일기장"
    }
    
    private lazy var mainView = MainView(frame: view.frame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = mainView
        setNavigationTitle()
    }
    
    private func setNavigationTitle() {
        navigationController?.navigationBar.topItem?.title = Constants.navigationBarTitle
    }
}

