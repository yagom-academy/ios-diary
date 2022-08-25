//
//  DBMangerable.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/23.
//

import Foundation

protocol DBMangerable {
    func loadData()
    func count() -> Int
    func content(index: Int) -> SampleDiaryContent
}
