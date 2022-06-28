//
//  TableViewModel.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

final class TableViewModel<U: CoreDataUseCase>: NSObject {
    private var data: [U.Element] = []
    private let useCase: U
    var dataCount: Int {
        return data.count
    }
    
    init(useCase: U) {
        self.useCase = useCase
    }
    
    func create(data: U.Element,
                completionHandler: ((U.Element) -> Void)? = nil,
                errorHandler: ((Error) -> Void)? = nil) {
        do {
            let result = try useCase.create(element: data)
            completionHandler?(result)
        } catch {
            errorHandler?(error)
        }
    }
    
    func loadData(errorHandler: ((Error) -> Void)? = nil) {
        do {
            let diaryDatas = try useCase.read()
            data = diaryDatas
        } catch {
            errorHandler?(error)
        }
    }
    
    func update(data: U.Element, errorHandler: ((Error) -> Void)? = nil) {
        do {
            try useCase.update(element: data)
        } catch {
            errorHandler?(error)
        }
    }
    
    func delete(data: U.Element, errorHandler: ((Error) -> Void)? = nil) {
        do {
            try useCase.delete(element: data)
        } catch {
            errorHandler?(error)
        }
    }
    
    func indexData(_ index: Int)-> U.Element? {
        guard index < data.count else {
            return nil
        }
        return data[index]
    }
}
