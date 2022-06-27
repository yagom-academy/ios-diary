//
//  ErrorAlertProtocol.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/14.
//

protocol ErrorAlertProtocol: Error {
    var alertTitle: String { get }
    var alertMessage: String { get }
}
