//
//  AlertDataService.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

protocol AlertDataService {
    func deleteAlert(completion: @escaping (() -> Void)) -> AlertControllerData
    func ellipsisActionSheet(shareCompletion: @escaping (() -> Void),
                             deleteCompletion: @escaping (() -> Void)) -> AlertControllerData
}
