//
//  AppManager.swift
//  Diary
//
//  Created by Zion, Serena on 2023/08/30.
//

import UIKit

final class AppManager {
    private let navigationController: UINavigationController
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let localeID = Locale.preferredLanguages.first ?? "kr_KR"
        let deviceLocale = Locale(identifier: localeID).languageCode ?? "KST"
        
        dateFormatter.locale = Locale(identifier: deviceLocale)
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter
    }()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let dairyContents = decodeDairySample(fileName: "sample") else { return }
        let mainViewController = MainViewController(diaryContents: dairyContents, dateFormatter: dateFormatter)
        
        mainViewController.delegate = self
        navigationController.viewControllers = [mainViewController]
    }
    
    private func decodeDairySample(fileName: String) -> [DiaryContent]? {
        let jsonDecoder = JSONDecoder()
        guard let asset = NSDataAsset(name: fileName) else { return nil }
        guard let data = try? jsonDecoder.decode([DiaryContent].self, from: asset.data) else { return nil }
        
        return data
    }
}

// MARK: - MainViewControllerDelegate
extension AppManager: MainViewControllerDelegate {
    func didTappedRightAddButton() {
        let diarySample = DiarySample()
        let todayDate = dateFormatter.string(from: Date())
        let addDiaryViewController = AddDiaryViewController(todayDate: todayDate,
                                                            diaryTitle: diarySample.title,
                                                            diaryDescription: diarySample.description)
        
        navigationController.pushViewController(addDiaryViewController, animated: true)
    }
}
