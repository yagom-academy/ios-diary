//
//  AlertViewDataMaker.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import Foundation

struct AlertViewDataMaker: AlertDataService {
    func decodeErrorAlert(_ error: Error) -> AlertViewData {
        let alertViewData = AlertViewData(title: "Decode Error",
                                          message: error.localizedDescription,
                                          style: .alert,
                                          enableOkAction: true,
                                          okActionTitle: "확인",
                                          enableCancelAction: false,
                                          cancelActionTitle: nil)
        
        return alertViewData
    }
    
//    func shareAndDeleteSheet() -> AlertViewData {
//        let actionSheetData = AlertViewData(title: "shareAndDelete",
//                                            message: <#T##String#>,
//                                            style: <#T##UIAlertController.Style#>,
//                                            enableOkAction: <#T##Bool#>, okActionTitle: <#T##String#>, enableCancelAction: <#T##Bool#>, cancelActionTitle: <#T##String?#>)
//    }
}
