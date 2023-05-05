//
//  UIViewController+Share.swift
//  Diary
//
//  Created by Seoyeon Hong on 2023/05/05.
//

import UIKit

extension UIViewController {
    func shareText(_ textToShare: String?) {
        guard let textToShare else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)

        self.present(activityViewController, animated: true, completion: nil)
        
    }
}
