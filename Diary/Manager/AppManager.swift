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
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return dateFormatter
    }()
    
    private let diaryDataManager: DiaryCoreDataManager
    
    init(navigationController: UINavigationController, diaryDataManager: DiaryCoreDataManager) {
        self.navigationController = navigationController
        self.diaryDataManager = diaryDataManager
    }
    
    func start() {
        guard let diaryData = try? diaryDataManager.fetchData(request: DiaryEntity.fetchRequest()) else { return }
        let mainViewController = MainViewController(diaryEntity: diaryData, dateFormatter: dateFormatter)
        
        mainViewController.delegate = self
        navigationController.viewControllers = [mainViewController]
    }
}

// MARK: - MainViewControllerDelegate
extension AppManager: MainViewControllerDelegate {
    func didTappedRightAddButton() {
        let diarySample = DiarySample()
        let todayDate = dateFormatter.string(from: Date())
        let addDiaryViewController = DiaryDetailViewController(todayDate: todayDate,
                                                            diaryTitle: diarySample.title,
                                                            diaryDescription: diarySample.description)
        
        navigationController.pushViewController(addDiaryViewController, animated: true)
    }
}
