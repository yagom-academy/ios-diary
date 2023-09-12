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
    func didSelectRowAt(diaryContent: DiaryEntity) {
        let diaryDetailViewController = DiaryDetailViewController(diaryEntity: diaryContent)
        
        diaryDetailViewController.delegate = self
        navigationController.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func didTappedRightAddButton() {
        let diaryDetailViewController = DiaryDetailViewController()
        
        diaryDetailViewController.delegate = self
        navigationController.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func fetchDiaryContents(mainViewController: MainViewController) {
        guard let diaryContents = try? diaryDataManager.fetchData(request: DiaryEntity.fetchRequest()) else { return }
        
        mainViewController.setUpDiaryEntity(diaryContents: diaryContents)
    }
    
    func deleteDiaryContent(diaryContent: DiaryEntity) {
        diaryDataManager.deleteData(entity: diaryContent)
        diaryDataManager.saveContext()
    }
}

// MARK: - DiaryDetailViewControllerDelegate
extension AppManager: DiaryDetailViewControllerDelegate {
    func createDiaryData(text: String) -> DiaryEntity? {
        guard let (title, body) = convertDiaryData(text: text) else { return nil }
        let date = Date().timeIntervalSince1970
        let diaryEntity = diaryDataManager.createDiaryData(title: title, body: body, date: date)
        
        diaryDataManager.saveContext()
        return diaryEntity
    }
    
    func updateDiaryData(diaryEntity: DiaryEntity, text: String) {
        guard let (title, body) = convertDiaryData(text: text) else { return }
        let date = Date().timeIntervalSince1970
        
        diaryEntity.title = title
        diaryEntity.body = body
        diaryEntity.date = date
        diaryDataManager.saveContext()
    }
    
    func deleteDiaryData(diaryEntity: DiaryEntity) {
        diaryDataManager.deleteData(entity: diaryEntity)
    }
    
    func popDiaryDetailViewController() {
        navigationController.popViewController(animated: true)
    }
    
    private func convertDiaryData(text: String) -> (String, String)? {
        let separatedText = text.split(separator: "\n", maxSplits: 1)
        guard let titleText = separatedText.first?.description else { return nil }
        
        let bodyText = separatedText.last?.description ?? ""
        
        return (titleText, bodyText)
    }
}
