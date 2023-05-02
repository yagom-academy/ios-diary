//
//  AlertActionData.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/02.
//

import Foundation

struct AlertActionData {
    let actionTitle: String
    let actionStyle: String
    let completion: (() -> Void)?
}
