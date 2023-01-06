//
//  ViewController+Extension.swift
//  Diary
//
//  Created by 애종, 애쉬 on 2022/12/29.
//

import UIKit

extension UIViewController {
    func showActivityContoller(_ objectsToShare: [Any]) {
        let activityViewController =  UIActivityViewController(activityItems: objectsToShare,
                                                               applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true)
    }
}
