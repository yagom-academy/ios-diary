//
//  DiaryAlertDataMaker.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

struct DiaryAlertDataMaker: DiaryAlertDataService {
    func deleteAlertData(completion: @escaping () -> Void) -> AlertViewData {
        let alertViewData = AlertViewData(title: "진짜요?",
                                          message: "정말로 삭제하시겠어요?",
                                          completion: completion)
        
        return alertViewData
    }
    
    func actionSheetData(shareCompletion: @escaping () -> Void,
                         deleteCompletion: @escaping () -> Void) -> ActionSheetViewData {
        let actionSheetViewData = ActionSheetViewData(title: nil,
                                                      message: nil,
                                                      shareCompletion: shareCompletion,
                                                      deleteCompletion: deleteCompletion)
        return actionSheetViewData
    }
}
