//
//  AlertViewData.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

struct AlertViewData {
    let title: String?
    let message: String?
    let style: UIAlertController.Style = .alert
    let completion: () -> Void
}
