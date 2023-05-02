//
//  AlertViewDataMaker.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

struct AlertViewDataMaker: AlertDataService {
    func makeData(alertStyle: AlertStyle, actionDataList: [AlertActionData]) -> AlertControllerData {
        switch alertStyle {
        case .alert:
            let alertViewData = AlertViewData(title: "진짜요?",
                                              message: "정말로 삭제하시겠어요?",
                                              actionDataList: actionDataList)
            
            return alertViewData
        case .actionSheet:
            let actionSheetViewData = ActionSheetViewData(title: nil,
                                                          message: nil,
                                                          actionDataList: actionDataList)
            
            return actionSheetViewData
        }
    }
}
