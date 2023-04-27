//
//  KeyboardProtocol.swift
//  Diary
//
//  Created by 리지, Goat on 2023/04/27.
//

import Foundation

@objc protocol KeyboardProtocol {
    @objc optional func keyboardWillShow()
    @objc optional func keyboardWillHide()
    @objc optional func dismissKeyboard()
}
