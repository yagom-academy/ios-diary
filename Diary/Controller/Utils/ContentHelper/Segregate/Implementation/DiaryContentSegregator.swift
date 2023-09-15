//
//  DiaryContentSegregator.swift
//  Diary
//
//  Created by Minsup, RedMango on 2023/09/07.
//

struct DiaryContentSegregator: DiaryContentSegregatable {
    func segregate(text: String?) -> (title: String, content: String) {
        let paragraphs = text?.components(separatedBy: "\n") ?? []
        
        // 첫 번째 개행 문자 이전의 텍스트를 제목으로 설정합니다.
        if let title = paragraphs.first {
            let content = paragraphs
                             .dropFirst()
                             .joined(separator: "\n")
                             .trimmingCharacters(in: .whitespacesAndNewlines)
            return (title: title, content: content)
        } else {
            return (title: "", content: "")
        }
    }
}
