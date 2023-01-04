//  Diary - AlertFactory.swift
//  Created by Ayaan, zhilly on 2023/01/02

import UIKit

enum AlertKind {
    case failure(title: String?, message: String?)
    case exit
}

class AlertFactory {
    private enum Constant {
        static let exitAlertTitle = "종료"
        static let exitAlertMessage = "다이어리 불러오기 실패하여 앱을 종료합니다."
    }
    static func make(_ alertKind: AlertKind) -> UIAlertController {
        switch alertKind {
        case .failure(let title, let message):
            return FailureAlert(title: title, message: message, preferredStyle: .alert)
        case .exit:
            return ExitAlert(title: Constant.exitAlertTitle,
                             message: Constant.exitAlertMessage,
                             preferredStyle: .alert)
        }
    }
}
