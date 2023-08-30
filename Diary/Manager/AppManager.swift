//
//  AppManager.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import UIKit

final class AppManager {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let dairySample = self.decodeDairySample(fileName: "sample") else { return }
        let mainViewController = MainViewController(dairySamples: dairySample)
        
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    private func decodeDairySample(fileName: String) -> [DiaryContent]? {
        let jsonDecoder = JSONDecoder()
        guard let asset = NSDataAsset(name: fileName) else { return nil }
        guard let data = try? jsonDecoder.decode([DiaryContent].self, from: asset.data) else { return nil }
        
        return data
    }
}
