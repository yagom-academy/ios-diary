//
//  UIApplication+.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/28.
//
import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
        }

    static func topViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        if let navigationController = rootViewController as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        }

        return rootViewController
    }
}
