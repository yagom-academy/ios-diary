//
//  PersistentContainerManager.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/27.
//

import CoreData

struct PersistentContainerManager {
    private let persistentContainer: PersistentContainer

    init(_ persistentContainer: PersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    private var diaryEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "DiaryModelObject", in: context)
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }

    private func fetchDiaryModelObjects() -> [DiaryModelObject] {
        do {
            let request = DiaryModelObject.fetchRequest()
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchDiaries() -> [Diary] {
        let fetchedDiaryModelObjects = fetchDiaryModelObjects()
        let diaries = fetchedDiaryModelObjects.map {
            Diary(id: $0.id, title: $0.title, body: $0.body, createdAt: $0.createdAt)
        }
        return diaries
    }

    func insertDiary(_ diary: Diary) {
        guard let entity = NSEntityDescription.entity(forEntityName: "DiaryModelObject", in: context) else { return }
        let diaryModelObejct = NSManagedObject(entity: entity, insertInto: context)
        diaryModelObejct.setValue(diary.id, forKey: "id")
        diaryModelObejct.setValue(diary.title, forKey: "title")
        diaryModelObejct.setValue(diary.body, forKey: "body")
        diaryModelObejct.setValue(diary.createdAt, forKey: "createdAt")
        saveContext()
    }

    func updateDiary(_ diary: Diary) {
        let fetchedDiaryModelObjects = fetchDiaryModelObjects()
        guard let diaryModelObejct = fetchedDiaryModelObjects.first(where: { $0.id == diary.id }) else { return }
        diaryModelObejct.title = diary.title
        diaryModelObejct.body = diary.body
        saveContext()
    }

    func deleteDiary(_ diary: Diary) {
        let fetchedDiaryModelObjects = fetchDiaryModelObjects()
        guard let diaryModelObejct = fetchedDiaryModelObjects.first(where: { $0.id == diary.id }) else { return }
        context.delete(diaryModelObejct)
        saveContext()
    }
}
