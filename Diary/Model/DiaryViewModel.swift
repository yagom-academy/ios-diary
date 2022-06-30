//
//  DiaryViewModel.swift
//  Diary
//
//  Created by SeoDongyeon on 2022/06/30.
//

import Foundation

final class DiaryViewModel {
    
    private var diaryModel: DiaryModel?
    
    init(diaryModel: DiaryModel? = nil) {
        self.diaryModel = diaryModel
    }
    
    private func create(title: String, body: String) throws {
        diaryModel = DiaryModel(
            title: title,
            body: body,
            createdAt: Date(),
            id: UUID().uuidString
        )
        guard let diary = diaryModel else {
            return
        }
        try DiaryEntityManager.shared.create(diary: diary)
    }
    
    private func update(title: String, body: String) throws {
        guard let createdAt = diaryModel?.createdAt,
                let id = diaryModel?.id else {
            return
        }
        diaryModel = DiaryModel(
            title: title,
            body: body,
            createdAt: createdAt,
            id: id)
        guard let diary = diaryModel else {
            return
        }
        try DiaryEntityManager.shared.update(diary: diary)
    }
    
    func delete(diaryData: DiaryModel) throws {
        try DiaryEntityManager.shared.delete(diary: diaryData)
    }
    
    func checkDiaryData(title: String?, body: String?) throws {
        guard let title = title, let body = body else {
            return
        }
        if title.isEmpty && body.isEmpty {
            return
        }
        if diaryModel == nil {
            try create(title: title, body: body)
        } else {
            try update(title: title, body: body)
        }
    }
}
