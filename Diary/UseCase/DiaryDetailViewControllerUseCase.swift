//
//  DiaryDetailViewControllerUseCase.swift
//  Diary
//
//  Created by Hyungmin Lee on 2023/09/14.
//

import Foundation

protocol DiaryDetailViewControllerUseCaseType {
    func setUpTextFromDiaryContentDTO() -> String
    func upsert(diaryDetailContent: String)
    func deleteDiary()
}

final class DiaryDetailViewControllerUseCase: DiaryDetailViewControllerUseCaseType {
    private let coreDataManager: CoreDataManager
    private let diaryContent: DiaryContentDTO
    
    init(coreDataManager: CoreDataManager, diaryContent: DiaryContentDTO) {
        self.coreDataManager = coreDataManager
        self.diaryContent = diaryContent
    }
    
    func setUpTextFromDiaryContentDTO() -> String {
        if diaryContent.title.count == 0 && diaryContent.body.count == 0 {
            return ""
        }
        
        return diaryContent.title + "\n" + diaryContent.body
    }
    
    func upsert(diaryDetailContent: String) {
        guard let (title, body) = convertDiaryData(text: diaryDetailContent) else { return }
        let isExistDiary = coreDataManager.isExistData(request: DiaryEntity.fetchRequest(), identifier: diaryContent.identifier)
        let diaryEntityProperty: [String: Any] = ["title": title,
                                                  "body": body,
                                                  "date": Date().timeIntervalSince1970,
                                                  "id": diaryContent.identifier]
        if isExistDiary {
            coreDataManager.updateData(request: DiaryEntity.fetchRequest(), entityProperties: diaryEntityProperty)
        } else {
            coreDataManager.insertData(entityName: "DiaryEntity", entityProperties: diaryEntityProperty)
        }
    }
    
    func deleteDiary() {
        coreDataManager.deleteData(request: DiaryEntity.fetchRequest(), identifier: diaryContent.identifier)
    }
}

// MARK: - Private
extension DiaryDetailViewControllerUseCase {
    private func convertDiaryData(text: String) -> (String, String)? {
        let separatedText = text.split(separator: "\n", maxSplits: 1)
        guard let titleText = separatedText.first?.description else { return nil }
        
        if let bodyText = separatedText.dropFirst().first {
            return (titleText, String(describing: bodyText))
        }
        
        return (titleText, "")
    }
}
