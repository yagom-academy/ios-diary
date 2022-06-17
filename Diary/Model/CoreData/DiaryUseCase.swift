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
        let maxPredicate = NSPredicate(format: "max(key) == %K", #keyPath(DiaryData.key))
        request.predicate = maxPredicate
        guard let diaryData = try? context.fetch(request) else {
            throw fatalError()
        }
        
        let array = diaryData as [AnyObject]
        
        switch array.count {
        case 0:
            return 0
        case 1:
            return Int(array[0].key)
        default:
            //에러 처리 하는게 맞지만... 그럼 절대 추가할수가 없다.
            return Int(array[0].key)
        }
    }
    
    func create(diary: DiaryInfo) throws {
        let key = try loadMaxKey() + 1
        let diaryData = NSEntityDescription.insertNewObject(forEntityName: "DiaryData", into: context) as! DiaryData
        
        diaryData.title = diary.title
        diaryData.body = diary.body
        diaryData.date = diary.date
        diaryData.key = Int64(key)
        
        guard let _ = try? context.save() else {
            throw fatalError()
        }

    }
    
    func read() throws -> [DiaryInfo] {
        guard let diarys = try? context.fetch(DiaryData.fetchRequest()) else {
            throw fatalError()
        }
        var diaryInfoArray: [DiaryInfo] = []
        for diary in diarys {
            let diaryInfo = DiaryInfo(title: diary.title, body: diary.body, date: diary.date, key: diary.key)
            diaryInfoArray.append(diaryInfo)
        }
        return diaryInfoArray
    }
    
    func update(key: Int) throws {
        
    }
    
    func delete(key: Int) throws {
        let request: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        let predicate = NSPredicate(format: "key = %@", String(key))
        request.predicate = predicate
        let result = try context.fetch(request)
        let resultArray = result as [NSManagedObject]
        guard resultArray.count > 0 else {
            throw fatalError()
        }
        context.delete(resultArray[0])
        try context.save()
    }
}
