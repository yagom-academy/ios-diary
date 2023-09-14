//
//  MainViewControllerUseCase.swift
//  Diary
//
//  Created by Hyungmin Lee on 2023/09/14.
//

import Foundation

protocol MainViewControllerUseCaseType {
    func fetchDiaryContentsDTO() -> [DiaryContentsDTO]?
    func createNewDiary() -> DiaryContentsDTO
}

final class MainViewControllerUseCase: MainViewControllerUseCaseType {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchDiaryContentsDTO() -> [DiaryContentsDTO]? {
        guard let diaryEntity = try? coreDataManager.fetchData(request: DiaryEntity.fetchRequest()) else { return nil }
        
        return diaryEntity.map {
            DiaryContentsDTO(body: $0.body,
                             date: $0.date,
                             title: $0.title,
                             identifier: $0.identifier)
        }
    }
    
    func createNewDiary() -> DiaryContentsDTO {
        return DiaryContentsDTO(body: "",
                                date: Double.zero,
                                title: "",
                                identifier: UUID())
    }
}
