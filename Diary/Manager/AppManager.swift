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
        guard let diaryContents = try? diaryDataManager.fetchData(request: DiaryEntity.fetchRequest()) else { return }
        let mainViewController = MainViewController(diaryContents: diaryContents, dateFormatter: dateFormatter)
        
        mainViewController.delegate = self
        navigationController.viewControllers = [mainViewController]
    }
}

// MARK: - MainViewControllerDelegate
extension AppManager: MainViewControllerDelegate {
    func didTappedRightAddButton() {
        let addDiaryViewController = DiaryDetailViewController()
        
        addDiaryViewController.delegate = self
        navigationController.pushViewController(addDiaryViewController, animated: true)
    }
    
    func fetchDiaryContents(mainViewController: MainViewController) {
        guard let diaryContents = try? diaryDataManager.fetchData(request: DiaryEntity.fetchRequest()) else { return }
        
        mainViewController.setUpDiaryEntity(diaryContents: diaryContents)
    }
}

// MARK: - DiaryDetailViewControllerDelegate
extension AppManager: DiaryDetailViewControllerDelegate {
    func createDiaryData(text: String) {
        let separatedText = text.split(separator: "\n", maxSplits: 1)
        let titleText = separatedText.first?.description ?? ""
        let bodyText = separatedText.last?.description ?? ""
        let date = Date().timeIntervalSince1970
        
        diaryDataManager.createDiaryData(title: titleText, body: bodyText, date: date)
        diaryDataManager.saveContext()
    }
    
    func updateDiaryData() {
        
    }
}
