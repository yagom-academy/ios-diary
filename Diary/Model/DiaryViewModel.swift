//
//  DiaryViewModel.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/09/02.
//
import UIKit

struct DiaryViewModel {
    let coreDataManager = CoreDataManager.shared

    var islineChanged = false
    var realTimeTypingValue: String = " " {
        didSet {
            if realTimeTypingValue == "\n" {
                islineChanged = true
            }
        }
    }
    var itemTitle: String?
    var itemBody: String?
    var id = UUID()
    var index: Int?
    var latitude: String?
    var longitude: String?
}
