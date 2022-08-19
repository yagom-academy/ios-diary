//
//  DiaryPostViewController.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/17.
//

import UIKit

final class DiaryPostViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.title = Date.currentFormattedDate
    }
}
