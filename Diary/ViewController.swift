//
//  Diary - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let apearance = UINavigationBarAppearance()
        apearance.configureWithOpaqueBackground()
        apearance.backgroundColor = .white
        
        navigationItem.title = "일기장"
        navigationController?.navigationBar.standardAppearance = apearance
        navigationController?.navigationBar.compactAppearance = apearance
        navigationController?.navigationBar.scrollEdgeAppearance = apearance
    }
    
    
}
