//
//  DiaryAlertDataService.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

protocol DiaryAlertDataService {
    func deleteAlertData(completion: @escaping () -> Void) -> AlertViewData
    func actionSheetData(shareCompletion: @escaping () -> Void,
                         deleteCompletion: @escaping () -> Void) -> ActionSheetViewData
}
