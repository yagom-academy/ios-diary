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
        return NSEntityDescription.entity(forEntityName: "Diary", in: context)
    }

    private func fetchDiaries() -> [DiaryMO] {
        do {
            let request = DiaryMO.fetchRequest()
            return try context.fetch(request)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }

    func getDiaries() -> [Diary] {
        let fetchedDiaries = fetchDiaries()
        let diaries = fetchedDiaries.map {
            Diary(id: $0.id, title: $0.title, body: $0.body, createdAt: $0.createdAt)
        }
        return diaries
    }

    func insertDiary(_ diary: Diary) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Diary", in: context) else { return }
        let diaryMO = NSManagedObject(entity: entity, insertInto: context)
        diaryMO.setValue(diary.id, forKey: "id")
        diaryMO.setValue(diary.title, forKey: "title")
        diaryMO.setValue(diary.body, forKey: "body")
        diaryMO.setValue(diary.createdAt, forKey: "createdAt")
        saveContext()
    }

    func updateDiary(_ diary: Diary) {
        let fetchedDiaries = fetchDiaries()
        guard let diaryMO = fetchedDiaries.first(where: { $0.id == diary.id }) else { return }
        diaryMO.title = diary.title
        diaryMO.body = diary.body
        saveContext()
    }

    func deleteDiary(_ diary: Diary) {
        let fetchedDiaries = fetchDiaries()
        guard let diaryMO = fetchedDiaries.first(where: { $0.id == diary.id }) else { return }
        context.delete(diaryMO)
        saveContext()
    }
}
