//
//  DataTransferObject.swift
//  Diary
//
//  Created by Rowan, Harry on 2023/05/06.
//

import Foundation

protocol DataTransferObject: Identifiable {
    var id: UUID { get set }
}
