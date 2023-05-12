//
//  DiaryAlertDataMaker.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

struct DiaryAlertDataMaker: DiaryAlertDataFactory {
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
    
    func retryAlertData(completion: @escaping () -> Void) -> AlertViewData {
        let alertViewData = AlertViewData(title: "재시도",
                                          message: "날씨 정보를 가져오는 데 실패했습니다.",
                                          completion: completion)
        return alertViewData
    }
}
