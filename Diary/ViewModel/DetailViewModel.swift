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
        do {
            try useCase.update(element: data)
        } catch {
            delegate?.errorHandler(error)
        }
    }
    
    private func delete(data: DiaryInfo) {
        do {
            try useCase.delete(element: data)
        } catch {
            delegate?.errorHandler(error)
        }
    }
}
