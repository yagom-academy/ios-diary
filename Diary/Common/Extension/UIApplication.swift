//
//  UIApplication.swift
//  Diary
//
//  Created by mmim, grumpy, mino on 2022/06/22.
//

import UIKit

extension UIApplication {
    func topViewController() -> UIViewController? {
        UIApplication.shared.windows
            .filter { $0.isKeyWindow }
            .first?.rootViewController?
            .topViewController()
    }
}
