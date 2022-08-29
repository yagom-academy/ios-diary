//
//  CoreDataManager.swift
//  Diary
//
//  Created by Kiwi, Brad. on 2022/08/25.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() {}
    
    private var diary = [Diary]() {
        didSet {
            NotificationCenter.default.post(name: .diaryModelDataDidChanged,
                                            object: self)
        }
    }
    
    var context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    let modelName = "Diary"
    
    func saveDiary(model: DiaryContent) {
        if let context = context {
            let diary = Diary(context: context)
            diary.setValue(model.id, forKey: "id")
            diary.setValue(model.title, forKey: "title")
            diary.setValue(model.body, forKey: "body")
            diary.setValue(model.createdAt, forKey: "createdAt")
            do {
                try context.save()
                self.diary = fetchDiaryEntity()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDiary() -> [DiaryContent] {
        var diaryContent: [DiaryContent] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "createdAt", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                if let fetchedDiary = try context.fetch(request) as? [Diary] {
                    fetchedDiary.forEach { diaryContent.append(DiaryContent(title: $0.title,
                                                                            body: $0.body,
                                                                            createdAt: $0.createdAt)) }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return diaryContent
    }
    
    func deleteDiary(id: UUID) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        if let context = context {
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.modelName)
            request.predicate = NSPredicate(format: "id = %@", id as CVarArg)
            
            do {
                guard let diaryDelete = try context.fetch(request).first as? NSManagedObject else { return }
                context.delete(diaryDelete)
                self.diary = fetchDiaryEntity()
            } catch {
                print(error.localizedDescription)
            }
            appDelegate.saveContext()
        }
    }
    
    func updateDiary(item: DiaryContent) {
        if let context = context {
            let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: self.modelName)
            request.predicate = NSPredicate(format: "id = %@", item.id as CVarArg )
            do {
                if let fetchedDiary = try context.fetch(request).first as? Diary {
                    
                    fetchedDiary.setValue(item.title, forKey: "title")
                    fetchedDiary.setValue(item.body, forKey: "body")
                    fetchedDiary.setValue(item.createdAt, forKey: "createdAt")
                    fetchedDiary.setValue(item.id, forKey: "id")
                    
                    try context.save()
                    self.diary = fetchDiaryEntity()
                } else {
                    saveDiary(model: DiaryContent(id: item.id, title: item.title, body: item.body, createdAt: item.createdAt))
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDiaryEntity() -> [Diary] {
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dateOrder = NSSortDescriptor(key: "createdAt", ascending: false)
            request.sortDescriptors = [dateOrder]
            
            do {
                if let fetchedDiary = try context.fetch(request) as? [Diary] {
                    diary = fetchedDiary
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return self.diary
    }
}

extension CoreDataManager: DBMangerable {
    func loadData() {
        self.diary = fetchDiaryEntity()
    }
    
    func updateData(item: DiaryContent) {
        updateDiary(item: item)
    }
    
    func getData() -> [DiaryContent] {
        return fetchDiary()
    }
    
    func count() -> Int {
        return self.diary.count
    }
    
    func content(index: Int) -> DiaryContent {
        return fetchDiary()[index]
    }
}
