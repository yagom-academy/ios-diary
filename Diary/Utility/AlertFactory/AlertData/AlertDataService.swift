//
//  AlertDataService.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

enum AlertStyle {
    case alert
    case actionSheet
}

protocol AlertDataService {
    func makeData(alertStyle: AlertStyle, actionDataList: [AlertActionData]) -> AlertControllerData
}
