//
//  UIViewController+Extension.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/21.
//

import UIKit

extension UIViewController {
    var alertMaker: AlertMaker {
        return AlertMaker(viewController: self)
    }
}
