//
//  Alertable.swift
//  Diary
//
//  Created by 조민호 on 2022/07/01.
//

import UIKit

protocol Alertable {}

extension Alertable {
    var alertController: UIAlertController {
        return UIAlertController()
    }
}
