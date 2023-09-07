//
//  DiaryContentSegregatable.swift
//  Diary
//
//  Created by Minsup, RedMango on 2023/09/07.
//

protocol DiaryContentSegregatable {
    func segregate(text: String?) -> (title: String, content: String)
}
