//
//  DiaryStorageProtocol.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

protocol DiaryStorageProtocol {
    func diaryEntrys() -> [DiaryEntry]
    func storeDiary(_ diary: DiaryEntry)
}
