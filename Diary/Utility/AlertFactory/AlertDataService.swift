//
//  AlertDataService.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

protocol AlertDataService {
    func decodeError(_ error: Error) -> AlertViewData
}
