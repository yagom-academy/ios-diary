//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItem()
    }
    
    func configureUI() {
        self.view.backgroundColor = .white
        
    }
    
    func configureNavigationItem() {
        self.navigationItem.title = "일기장"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDiaryPage))
        
    }
    
    @objc func addDiaryPage() { }
    
}
