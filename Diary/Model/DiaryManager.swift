//
//  DiaryManager.swift
//  Diary
//
//  Created by Mary & Whales on 2023/08/30.
//

import CoreData

final class DiaryManager {
    private(set) var diaryContents: [DiaryContent] = []
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init() throws {
        try refresh()
    }
    
    func refresh() throws {
        let diaries = try context.fetch(Diary.fetchRequest())
        var contents: [DiaryContent] = []
        
        diaries.forEach { element in
            contents.append(DiaryContent(id: element.id,
                                         title: element.title,
                                         body: element.body,
                                         timeInterval: element.timeInterval))
        }
        
        diaryContents = contents
    }
    
    func insert(diaryContent: DiaryContent) throws {
        let entity = NSEntityDescription.entity(forEntityName: "Diary", in: context)
        
        if let entity = entity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            
            managedObject.setValue(diaryContent.title, forKey: "title")
            managedObject.setValue(diaryContent.body, forKey: "body")
            managedObject.setValue(diaryContent.timeInterval, forKey: "timeInterval")
            managedObject.setValue(diaryContent.id, forKey: "id")
            
            try context.save()
        }
    }
    
    func update(diaryContent: DiaryContent) throws {
        let request = Diary.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", diaryContent.id as CVarArg)
        
        let diaries = try context.fetch(request)
        
        diaries.forEach { diary in
            diary.title = diaryContent.title
            diary.body = diaryContent.body
        }
        
        try context.save()
    }
    
    func delete(id: UUID) throws {
        let request = Diary.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        let diaries = try context.fetch(request)
        
        guard let diary = diaries.first else { return }
        
        context.delete(diary)
        try context.save()
        
        diaryContents = diaryContents.filter { $0.id != id }
    }
}
