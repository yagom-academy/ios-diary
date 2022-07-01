//
//  DetailViewModel.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/30.
//

import UIKit
protocol DetailViewModelDelegate: AnyObject {
    func errorHandler(_ error: Error)
}

enum DetailViewModelAction {
    case update(DiaryInfo)
    case delete(DiaryInfo)
}

final class DetailViewModel: NSObject {
    private var data: [DiaryInfo] = []
    let useCase: DiaryUseCase
    var delegate: DetailViewModelDelegate?
    private var dataCount: Int {
        return data.count
    }
    
    init(useCase: DiaryUseCase) {
        self.useCase = useCase
    }
    
    func requireAction(_ action: DetailViewModelAction) {
        switch action {
        case .update(let diaryInfo):
            update(data: diaryInfo)
        case .delete(let diaryInfo):
            delete(data: diaryInfo)
        }
    }
    
    private func update(data: DiaryInfo) {
        let result = useCase.update(element: data)
        
        switch result {
        case .success:
            return
        case .failure(let error):
            delegate?.errorHandler(error)
        }
    }
    
    private func delete(data: DiaryInfo) {
        
        let result = useCase.delete(element: data)
        switch result {
        case .success:
            return
        case .failure(let error):
            delegate?.errorHandler(error)
        }
    }
}
