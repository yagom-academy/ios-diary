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
    func makeData(
        title: String?,
        message: String?,
        alertStyle: AlertStyle,
        actionDataList: [AlertActionData]
    ) -> AlertControllerData
}

extension AlertDataService {
    func makeData(
        title: String? = nil,
        message: String? = nil,
        alertStyle: AlertStyle,
        actionDataList: [AlertActionData]
    ) -> AlertControllerData {
        switch alertStyle {
        case .alert:
            let alertViewData = AlertViewData(title: title,
                                              message: message,
                                              actionDataList: actionDataList)
            
            return alertViewData
        case .actionSheet:
            let actionSheetViewData = ActionSheetViewData(title: title,
                                                          message: message,
                                                          actionDataList: actionDataList)
            
            return actionSheetViewData
        }
    }
}
