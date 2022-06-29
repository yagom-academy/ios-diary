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
    
}

final class TableViewModel: NSObject {
    private var data: [DiaryInfo] = []
    private let useCase: DiaryUseCase
    var delegate: TableViewModelDelegate?
    var dataCount: Int {
        return data.count
    }
    
    init(useCase: DiaryUseCase) {
        self.useCase = useCase
    }
    
    func create(data: DiaryInfo) {
        do {
            let result = try useCase.create(element: data)
            delegate?.createHandler(result)
        } catch {
            delegate?.errorHandler(error)
        }
    }
    
    func loadData() {
        do {
            let diaryDatas = try useCase.read()
            data = diaryDatas
        } catch {
            delegate?.errorHandler(error)
        }
    }
    
    func update(data: DiaryInfo) {
        do {
            try useCase.update(element: data)
        } catch {
            delegate?.errorHandler(error)
        }
    }
    
    func delete(data: DiaryInfo) {
        do {
            try useCase.delete(element: data)
        } catch {
            delegate?.errorHandler(error)
        }
    }
    
    func indexData(_ index: Int) -> DiaryInfo? {
        guard index < data.count else {
            return nil
        }
        return data[index]
    }
    
    func asyncUpdate(data: DiaryInfo) {
        guard let delegate = delegate else {
            return
        }
        useCase.asyncUpdate(element: data,
                            completionHandler: delegate.asyncUpdateHandler,
                            errorHandler: delegate.errorHandler)
    }
}
