//
//  TableViewModel.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

import UIKit

final class TableViewModel<U: UseCase>: NSObject {
    private(set) var data: [U.Element] = []
    private let useCase: U
    
    init(useCase: U) {
        self.useCase = useCase
    }
    
    func loadData() throws {
        let diaryDatas = try useCase.read()
        data = diaryDatas
    }
    
    func update(data: U.Element) throws {
        try useCase.update(element: data)
    }
    
    func create(data: U.Element) throws -> U.Element {
        let result = try useCase.create(element: data)
        return result
    }
    
    func delete(data: U.Element) throws {
        try useCase.delete(element: data)
    }
}
