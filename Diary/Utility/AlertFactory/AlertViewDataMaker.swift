//
//  AlertViewDataMaker.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/04/27.
//

import Foundation

struct AlertViewDataMaker: AlertDataService {
    func decodeError(_ error: Error) -> AlertViewData {
        let alertViewData = AlertViewData(title: "Decode Error",
                                          message: error.localizedDescription,
                                          style: .alert,
                                          enableOkAction: true,
                                          okActionTitle: "확인",
                                          enableCancelAction: false,
                                          cancelActionTitle: nil)
        
        return alertViewData
    }
}
