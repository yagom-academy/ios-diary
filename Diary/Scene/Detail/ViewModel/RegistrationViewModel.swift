//
//  RegistrationViewModel.swift
//  Diary
//
//  Created by 조민호 on 2022/06/22.
//

import Foundation

final class RegistrationViewModel {
    private var diary: DiaryEntity?
    private(set) var createdAt = Date().timeIntervalSince1970
    private let diaryId = UUID().uuidString
}

extension RegistrationViewModel {
    func saveDiary(text: String?) {
        guard let content = text,
                content.isEmpty == false
        else {
            return
        }
        
        var splitedText = content.components(separatedBy: "\n")
        let title = splitedText.removeFirst()
        let body = splitedText.joined(separator: "\n")

        let diary = Diary(title: title, createdAt: createdAt, body: body, id: diaryId)
        
        PersistenceManager.shared.execute(by: .create(diary: diary))
    }
}
