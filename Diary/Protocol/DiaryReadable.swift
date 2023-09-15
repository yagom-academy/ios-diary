//
//  DiaryReadable.swift
//  Diary
//
//  Created by Erick on 2023/09/12.
//

protocol DiaryReadable {
    func diaryEntrys() throws -> [DiaryEntry]
}
