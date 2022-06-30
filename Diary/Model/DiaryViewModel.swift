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
    
    private func create(title: String, body: String) {
        diaryModel = DiaryModel(
            title: title,
            body: body,
            createdAt: Date(),
            id: UUID().uuidString
        )
        guard let diary = diaryModel else {
            return
        }
        DiaryEntityManager.shared.create(diary: diary)
    }
    
    private func update(title: String, body: String) {
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
        DiaryEntityManager.shared.update(diary: diary)
    }
    
    func delete(diaryData: DiaryModel) throws {
        try DiaryEntityManager.shared.delete(diary: diaryData)
    }
    
    func checkDiaryData(title: String?, body: String?) {
        guard let title = title, let body = body else {
            return
        }
        if title.isEmpty && body.isEmpty {
            return
        }
        if diaryModel == nil {
            create(title: title, body: body)
        } else {
            update(title: title, body: body)
        }
    }
}
