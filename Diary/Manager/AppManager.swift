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
        
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
    
    private let coreDataManager: any CoreDataManagerType
    
    init(navigationController: UINavigationController, coreDataManager: any CoreDataManagerType) {
        self.navigationController = navigationController
        self.coreDataManager = coreDataManager
    }
    
    func start() {
        let useCase: MainViewControllerUseCaseType = MainViewControllerUseCase(coreDataManager: coreDataManager)
        let mainViewController = MainViewController(dateFormatter: dateFormatter, useCase: useCase)
        
        mainViewController.delegate = self
        navigationController.viewControllers = [mainViewController]
    }
}

// MARK: - MainViewControllerDelegate
extension AppManager: MainViewControllerDelegate {
    func didSelectRowAt(diaryContent: DiaryContentDTO) {
        let date = Date(timeIntervalSince1970: diaryContent.date)
        let formattedDate = dateFormatter.string(from: date)
        let useCase: DiaryDetailViewControllerUseCaseType = DiaryDetailViewControllerUseCase(coreDataManager: coreDataManager, diaryContent: diaryContent)
        let diaryDetailViewController = DiaryDetailViewController(date: formattedDate, useCase: useCase)
        
        diaryDetailViewController.delegate = self
        navigationController.pushViewController(diaryDetailViewController, animated: true)
    }
    
    func didTappedRightAddButton(newDiaryContent: DiaryContentDTO) {
        let todayDate = dateFormatter.string(from: Date())
        let useCase: DiaryDetailViewControllerUseCaseType = DiaryDetailViewControllerUseCase(coreDataManager: coreDataManager, diaryContent: newDiaryContent)
        let diaryDetailViewController = DiaryDetailViewController(date: todayDate, useCase: useCase)
        
        diaryDetailViewController.delegate = self
        navigationController.pushViewController(diaryDetailViewController, animated: true)
    }
}

// MARK: - DiaryDetailViewControllerDelegate
extension AppManager: DiaryDetailViewControllerDelegate {
    func popDiaryDetailViewController() {
        navigationController.popViewController(animated: true)
    }
}
