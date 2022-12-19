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
        
        setNavigationBar()
    }
    
    private func setNavigationBar() {
        self.title = "일기장"
        let appearence = UINavigationBarAppearance()
        navigationController?.navigationBar.standardAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add,
                                        target: self,
                                        action: #selector(addButtonTapped))
        self.navigationItem.rightBarButtonItem = addBarButton
    }
    
    @objc private func addButtonTapped() {
        
    }
}
