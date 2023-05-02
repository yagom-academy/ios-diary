//
//  AlertFactoryService.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

protocol AlertFactoryService {
    func make(for data: AlertControllerData) -> UIAlertController
}
