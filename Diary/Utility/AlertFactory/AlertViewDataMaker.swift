//
//  AlertViewDataMaker.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import UIKit

struct AlertViewDataMaker: AlertDataService {
    func deleteAlert(completion: @escaping (() -> Void)) -> AlertControllerData {
        let cancel = AlertActionData(actionTitle: "취소",
                                     actionStyle: .cancel,
                                     completion: nil)
        let delete = AlertActionData(actionTitle: "삭제",
                                     actionStyle: .destructive,
                                     completion: completion)
        let alertViewData = AlertViewData(title: "진짜요?",
                                          message: "정말로 삭제하시겠어요?",
                                          actionDataList: [cancel, delete])
        
        return alertViewData
    }
    
    func ellipsisActionSheet(shareCompletion: @escaping (() -> Void),
                             deleteCompletion: @escaping (() -> Void)) -> AlertControllerData {
        let share = AlertActionData(actionTitle: "Share...",
                                    actionStyle: .default,
                                    completion: shareCompletion)
        let delete = AlertActionData(actionTitle: "Delete",
                                     actionStyle: .destructive,
                                     completion: deleteCompletion)
        let cancel = AlertActionData(actionTitle: "Cancel",
                                     actionStyle: .cancel,
                                     completion: nil)
        let actionSheetViewData = ActionSheetViewData(title: nil,
                                                      message: nil,
                                                      actionDataList: [share, delete, cancel])
        
        return actionSheetViewData
    }
}
