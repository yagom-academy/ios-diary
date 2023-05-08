//
//  ActionSheetViewData.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/02.
//

import UIKit

struct ActionSheetViewData {
    let title: String?
    let message: String?
    let style: UIAlertController.Style = .actionSheet
    let shareCompletion: () -> Void
    let deleteCompletion: () -> Void
}
