//
//  AlertActionData.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/02.
//

import UIKit

struct AlertActionData {
    let actionTitle: String
    let actionStyle: UIAlertAction.Style
    let completion: (() -> Void)?
}
