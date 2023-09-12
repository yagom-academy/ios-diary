//
//  DiaryStorageProtocol.swift
//  Diary
//
//  Created by Erick on 2023/08/29.
//

protocol DiaryManageable {
    func storeDiary(_ diary: DiaryEntry) throws
    func deleteDiary(_ diary: DiaryEntry) throws
}
