//
//  DiaryContentComposable.swift
//  Diary
//
//  Created by Minsup, RedMango on 2023/09/07.
//

import Foundation

protocol DiaryContentComposable {
    func composite(title: String?, content: String?) -> String?
}
