//
//  DiaryAlertFactory.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

protocol DiaryAlertFactory {
    func deleteDiaryAlert(for data: AlertViewData) -> UIAlertController
    func actionSheet(for data: ActionSheetViewData) -> UIAlertController
    func retryAlert(for data: AlertViewData) -> UIAlertController
}
