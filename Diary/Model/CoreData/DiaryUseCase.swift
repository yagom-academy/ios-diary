//
//  DiaryUseCase.swift
//  Diary
//
//  Created by 우롱차, RED on 2022/06/16.
//

import CoreData

protocol UseCase {
    associatedtype Element
    func create(diary: Element) throws -> Element
    func read() throws -> [Element]
    func update(diaryInfo: Element) throws
    func delete(key: Int) throws
}

final class DiaryUseCase: UseCase {
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
    
    private func filterDiaryData(key: Int) throws -> [NSManagedObject] {
        let request: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        let predicate = NSPredicate(format: "key = %@", String(key))
        request.predicate = predicate
        let diarys = try context.fetch(request)
        let objectDiarys = diarys as [DiaryData]
        return objectDiarys
    }
    
    @discardableResult
    func create(diary: DiaryInfo) throws -> DiaryInfo {
        let key = try Int64(loadMaxKey()) + 1
        let diaryData = NSEntityDescription.insertNewObject(forEntityName: "DiaryData", into: context) as! DiaryData
        
        diaryData.title = diary.title
        diaryData.body = diary.body
        diaryData.date = diary.date
        diaryData.key = key
        
        guard let _ = try? context.save() else {
            throw fatalError()
        }
        
        return DiaryInfo(title: diary.title, body: diary.body, date: diary.date, key: key)
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
    
    func update(diaryInfo: DiaryInfo) throws {
        guard let key = diaryInfo.key else { return }
        let diarys = try filterDiaryData(key: Int(key))
        
        guard diarys.count > 0 else {
            throw fatalError()
        }
        let diary = diarys[0]
        diary.setValue(diaryInfo.title, forKey: "title")
        diary.setValue(diaryInfo.body, forKey: "body")
        try context.save()
    }
    
    func delete(key: Int) throws {
        let request: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        let predicate = NSPredicate(format: "key = %@", String(key))
        request.predicate = predicate
        let result = try context.fetch(request)
        let resultArray = result as [DiaryData]
        guard resultArray.count > 0 else {
            throw fatalError()
        }
        context.delete(resultArray[0])
        try context.save()
    }
}
