//
//  DiaryManagable.swift
//  Diary
//
//  Created by bonf, bard on 2022/08/25.
//

protocol DiaryManagable {
    var diaryList: [Diary] { get }
    
    func create(_ diary: Diary)
    func fetch()
    func update(_ diary: Diary)
    func delete(_ diary: Diary)
}
