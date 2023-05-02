//
//  AlertControllerData.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/02.
//

import UIKit

protocol AlertControllerData {
    var title: String? { get }
    var message: String? { get }
    var style: UIAlertController.Style { get }
    var actionDataList: [AlertActionData] { get }
}
