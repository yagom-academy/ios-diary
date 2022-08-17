//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 백곰, 주디 on 2022/08/17.
//

import UIKit

class AddDiaryViewController: UIViewController {
    private var addDiaryView = AddDiaryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addDiaryView
        
        self.navigationItem.title = DateManager().fetchDate(data: Date().timeIntervalSince1970)
    }
}
