//
//  DiaryService.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/13.
//

import Foundation

struct DiaryService {
    private let coreDataManager = CoreDataManager(name: "Diary")
    
    func loadDiaryList() throws -> [DiaryEntity] {
        try coreDataManager.fetch(of: DiaryEntity())
    }
    
    func createDiary() -> DiaryEntity {
        let diary = DiaryEntity(context: coreDataManager.container.viewContext)
        
        diary.id = UUID()
        diary.date = Date()
        
        return diary
    }
    
    func write(content: String, to diary: DiaryEntity) {
        let separatedContent = separateTitleAndBody(of: content)
        
        diary.title = separatedContent.title
        diary.body = separatedContent.body
    }
    
    func delete(_ diary: DiaryEntity) {        
        coreDataManager.deleteContext(of: diary)
    }
    
    func saveDiary() throws {
        try coreDataManager.saveContext()
    }
    
    private func separateTitleAndBody(of content: String) -> (title: String, body: String) {
        let title = content.components(separatedBy: "\n")[0]
        var body = ""
        
        if let range = content.range(of: "\n") {
            body = String(content[range.upperBound...])
        }
        
        return (title, body)
    }
}
