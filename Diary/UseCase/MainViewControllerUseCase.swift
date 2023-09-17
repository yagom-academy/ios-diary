//
//  MainViewControllerUseCase.swift
//  Diary
//
//  Created by Hyungmin Lee on 2023/09/14.
//

import Foundation

protocol MainViewControllerUseCaseType {
    func fetchDiaryContentDTO() -> [DiaryContentDTO]?
    func createNewDiary() -> DiaryContentDTO
    func deleteDiary(deleteDiaryId: UUID)
}

final class MainViewControllerUseCase: MainViewControllerUseCaseType {
    private let coreDataManager: any CoreDataManagerType
    
    init(coreDataManager: any CoreDataManagerType) {
        self.coreDataManager = coreDataManager
    }
    
    func fetchDiaryContentDTO() -> [DiaryContentDTO]? {
        let fetchRequest = DiaryEntity.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        guard let diaryEntity = try? coreDataManager.fetchData(request: fetchRequest) else { return nil }
        
        return diaryEntity.map {
            DiaryContentDTO(body: $0.body,
                             date: $0.date,
                             title: $0.title,
                             identifier: $0.id)
        }
    }
    
    func createNewDiary() -> DiaryContentDTO {
        return DiaryContentDTO(body: "",
                                date: Double.zero,
                                title: "",
                                identifier: UUID())
    }
    
    func deleteDiary(deleteDiaryId: UUID) {
        coreDataManager.deleteData(request: DiaryEntity.fetchRequest(), identifier: deleteDiaryId)
    }
}
