//
//  PersistentContainerManager.swift
//  Diary
//
//  Created by Mangdi, junho on 2022/12/27.
//

import CoreData

struct PersistentContainerManager {
    private lazy var persistentContainer: PersistentContainer = {
        return PersistentContainer.shared
    }()

    private mutating func fetchDiaryModelObjects() -> [DiaryModelObject] {
        do {
            let request = DiaryModelObject.fetchRequest()
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    mutating func fetchDiaries() -> [Diary] {
        let fetchedDiaryModelObjects = fetchDiaryModelObjects()
        let diaries = fetchedDiaryModelObjects.map {
            Diary(id: $0.id, title: $0.title, body: $0.body, createdAt: $0.createdAt)
        }
        return diaries
    }

    mutating func insertDiary(_ diary: Diary) {
        let diaryModelObejct = DiaryModelObject(context: persistentContainer.viewContext)
        diaryModelObejct.id = diary.id
        diaryModelObejct.title = diary.title
        diaryModelObejct.body = diary.body
        diaryModelObejct.createdAt = diary.createdAt
        persistentContainer.saveContext()
    }

    mutating func updateDiary(_ diary: Diary) {
        let fetchedDiaryModelObjects = fetchDiaryModelObjects()
        guard let diaryModelObejct = fetchedDiaryModelObjects.first(where: { $0.id == diary.id }) else { return }
        diaryModelObejct.title = diary.title
        diaryModelObejct.body = diary.body
        persistentContainer.saveContext()
    }

    mutating func deleteDiary(_ diary: Diary) {
        let fetchedDiaryModelObjects = fetchDiaryModelObjects()
        guard let diaryModelObejct = fetchedDiaryModelObjects.first(where: { $0.id == diary.id }) else { return }
        persistentContainer.viewContext.delete(diaryModelObejct)
        persistentContainer.saveContext()
    }
}
