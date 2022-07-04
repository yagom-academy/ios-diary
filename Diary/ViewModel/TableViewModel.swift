//
//  TableViewModel.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit
protocol TableViewModelDelegate: AnyObject {
    func createHandler(_ data: DiaryInfo)
    func asyncUpdateHandler(_ data: DiaryInfo)
    func errorHandler(_ error: Error)
    func reloadData(_ datas: [DiaryInfo])
}

enum ViewModelAction {
    case create
    case loadData
    case update(DiaryInfo)
    case delete(DiaryInfo)
    case asyncUpdate(DiaryInfo)
}

final class TableViewModel: NSObject {
    private var data: [DiaryInfo] = []
    let useCase: DiaryUseCase
    var delegate: TableViewModelDelegate?
    private var dataCount: Int {
        return data.count
    }
    
    init(useCase: DiaryUseCase) {
        self.useCase = useCase
    }
    
    func requireAction(_ action: ViewModelAction) {
        switch action {
        case .create:
            create()
        case .loadData:
            loadData()
        case .update(let diaryInfo):
            update(data: diaryInfo)
        case .delete(let diaryInfo):
            delete(data: diaryInfo)
        case .asyncUpdate(let diaryInfo):
            asyncUpdate(data: diaryInfo)
        }
    }
    
    private func create() {
        let newDiary = DiaryInfo(title: "", body: "", date: Date(), key: nil)
        let result = useCase.create(element: newDiary)
        
        switch result {
        case .success(let diary):
            delegate?.createHandler(diary)
        case .failure(let error):
            delegate?.errorHandler(error)
        }
    }
    
    private func loadData() {
        let diaryDatas = useCase.read()
        switch diaryDatas {
        case .success(let diaryDatas):
            data = diaryDatas
            delegate?.reloadData(data)
        case.failure(let error ):
            delegate?.errorHandler(error)
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
    
    private func asyncUpdate(data: DiaryInfo) {
        guard let delegate = delegate else {
            return
        }
        useCase.asyncUpdate(element: data,
                            completionHandler: delegate.asyncUpdateHandler,
                            errorHandler: delegate.errorHandler)
    }
}
