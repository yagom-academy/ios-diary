//
//  DiaryAlertDataFactory.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

protocol DiaryAlertDataFactory {
    func deleteAlertData(completion: @escaping () -> Void) -> AlertViewData
    func actionSheetData(shareCompletion: @escaping () -> Void,
                         deleteCompletion: @escaping () -> Void) -> ActionSheetViewData
    func retryAlertData(completion: @escaping () -> Void) -> AlertViewData
}
