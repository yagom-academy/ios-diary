//
//  CoreDataManager.swift
//  Diary
//
//  Created by leewonseok on 2022/12/27.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static var shared = CoreDataManager()
    
    private init() { }
    
    let appdelegate = UIApplication.shared.delegate as? AppDelegate

    lazy var context = appdelegate?.persistentContainer.viewContext
    
    let entityName = "Diary"
    
    func createDiary(data: DiaryData) {
        guard let context else {
            print("컨텍스트 불러오기 실패")
            return
        }
        
        guard let entity = NSEntityDescription.entity(forEntityName: self.entityName, in: context) else {
            print("엔티티 불러오기 실패")
            return
        }
        
        guard let diaryData = NSManagedObject(entity: entity, insertInto: context) as? Diary else {
            return
        }
        
        diaryData.id = data.id ?? UUID()
        diaryData.title = data.title
        diaryData.content = data.body
        diaryData.createdAt = data.createdAt
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    func fetchDiaryList() -> [Diary]? {
        guard let context else {
            print("컨텍스트 불러오기 실패")
            return nil
        }
        var diaryList: [Diary] = []
        
        let request = NSFetchRequest<NSManagedObject>(entityName: self.entityName)
        do {
            
            if let fetchedDiaryList = try context.fetch(request) as? [Diary] {
                diaryList = fetchedDiaryList
            }
        } catch {
           print("데이터 불러오기 실패")
        }
        return diaryList
    }
    
    func updateDiary(diary: Diary) {
        let request = NSFetchRequest<Diary>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            var updatedDiary = try context?.fetch(request).first as? Diary
            updatedDiary = diary
            try context?.save()
        } catch {
            print(error)
            return
        }
    }
    
    func deleteDiary(diary: Diary) {
        let request = NSFetchRequest<Diary>(entityName: self.entityName)
        request.predicate = NSPredicate(format: "id == %@", diary.id as CVarArg)
        
        do {
            if let fetchedDiary = try context?.fetch(request).first as? Diary {
                context?.delete(fetchedDiary)
            }
            try context?.save()
        } catch {
            print(error)
            return
        }
    }
    
}
