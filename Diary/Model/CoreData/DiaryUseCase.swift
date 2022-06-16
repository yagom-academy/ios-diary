//
//  DiaryUseCase.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/16.
//

import CoreData

final class DiaryUseCase {
    let containerManager = ContainerManager.shared
    lazy var context = containerManager.persistentContainer.viewContext
    lazy var diaryEntity = NSEntityDescription.entity(forEntityName: "DiaryData", in: context)
    
    func loadMaxKey() throws -> Int {
        let request: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        let maxPredicate = NSPredicate(format: "max(key) == %@", #keyPath(DiaryData.key))
        request.predicate = maxPredicate
        guard let diaryData = try? context.fetch(request) else {
            throw fatalError()
        }
        
        switch diaryData.count {
        case 0:
            return 0
        case 1:
            return Int(diaryData[0].key)
        default:
            throw fatalError()
        }
    }
    
    func create(diary: DiaryData) throws {
        let key = try loadMaxKey() + 1
        
        if let diaryEntity = diaryEntity {
            let newDiary = NSManagedObject(entity: diaryEntity, insertInto: context)
            newDiary.setValue(diary.title, forKey: "title")
            newDiary.setValue(diary.body, forKey: "body")
            newDiary.setValue(diary.date, forKey: "date")
            newDiary.setValue(key, forKey: "key")
        }
        
        guard let _ = try? context.save() else {
            throw fatalError()
        }

    }
    
    func read() throws -> [DiaryData] {
        guard let diarys = try? context.fetch(DiaryData.fetchRequest()) as [DiaryData] else {
            throw fatalError()
        }
         return diarys
    }
    
    func update(key: Int) throws {
        
    }
    
    func delete(key: Int) throws {
        
    }
}
