//
//  Coordinator.swift
//  Diary
//
//  Created by dudu, papri on 2022/06/27.
//

import UIKit

protocol Coordinator {
    var viewController: UIViewController? { get }
}

extension Coordinator {
    func popViewController(animated: Bool) {
        if Thread.isMainThread {
            viewController?.navigationController?.popViewController(animated: animated)
        } else {
            DispatchQueue.main.async {
                viewController?.navigationController?.popViewController(animated: animated)
            }
        }
    }
}
