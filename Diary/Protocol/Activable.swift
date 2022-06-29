//
//  Activable.swift
//  Diary
//
//  Created by Donnie, OneTool on 2022/06/28.
//

import UIKit

protocol Activitable: UIViewController {}

extension Activitable {
    func activitySheet(activityItems: [Any]) {
        let activityViewController = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        self.present(activityViewController, animated: true)
    }
}
