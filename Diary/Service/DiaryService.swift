//
//  DiaryService.swift
//  Diary
//
//  Created by MINT, BMO on 2023/09/13.
//

import Foundation
import CoreData

struct DiaryService: CoreDataManageable {
    var container: NSPersistentContainer
    
    init(name: String) {
        self.container = {
            let container = NSPersistentContainer(name: name)
            container.loadPersistentStores { _, error in
                if let error = error {
                    fatalError("Unable to load persistent stores: \(error)")
                }
            }
            return container
        }()
    }
    
    func loadDiaryList() throws -> [DiaryEntity] {
        try self.fetch(of: DiaryEntity())
    }
    
    func createDiary() -> DiaryEntity {
        let diary = DiaryEntity(context: container.viewContext)
        
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
        self.deleteContext(of: diary)
    }
    
    func saveDiary() throws {
        try self.saveContext()
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
