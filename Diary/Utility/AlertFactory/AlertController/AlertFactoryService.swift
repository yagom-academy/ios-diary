//
//  AlertFactoryService.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

protocol AlertFactoryService {
    func makeAlert(for alertData: AlertViewData) -> UIAlertController
}
