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
    
    func loadData() {
        do {
            let diaryDatas = try useCase.read()
            data = diaryDatas
        } catch {
            fatalError()
        }
    }
    
    func update(data: U.Element) {
        do {
             try useCase.update(element: data)
        } catch {
            fatalError()
        }
    }
    
    func create(data: U.Element) -> U.Element {
        do {
            return try useCase.create(element: data)
        } catch {
            fatalError()
        }
    }
}
