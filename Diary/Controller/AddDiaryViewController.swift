//
//  AddDiaryViewController.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/20.
//

import UIKit

class AddDiaryViewController: UIViewController {
    
    let addDiaryView = AddDiaryView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = addDiaryView
        // Do any additional setup after loading the view.
    }
}
