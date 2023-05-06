//
//  UIViewController+Share.swift
//  Diary
//
//  Created by Seoyeon Hong on 2023/05/05.
//

import UIKit

extension UIViewController {
    func share(someText: String?) {
        guard let someText else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [someText], applicationActivities: nil)

        self.present(activityViewController, animated: true, completion: nil)
        
    }
}
