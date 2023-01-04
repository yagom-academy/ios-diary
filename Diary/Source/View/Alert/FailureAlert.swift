//  Diary - FailureAlert.swift
//  Created by Ayaan, zhilly on 2023/01/02

import UIKit

final class FailureAlert: UIAlertController {
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction(cancelAction)
    }
}
