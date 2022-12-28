//
//  CoreDataManager.swift
//  Diary
//
//  Created by Aaron, Gundy, Rhovin on 2022/12/27.
//

import Foundation
import CoreData

class CoreDataManager {
    static var shared: CoreDataManager = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Diary")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    var diaryEntity: NSEntityDescription? {
        return  NSEntityDescription.entity(forEntityName: "DiaryEntity", in: context)
    }

    // MARK: - CREATE
    func create(diary: Diary) {
        createDiaryEntity(diary: diary)
        saveContext()
    }

    private func createDiaryEntity(diary: Diary) {
        if let entity = diaryEntity {
            let managedObject = NSManagedObject(entity: entity, insertInto: context)
            managedObject.setValue(diary.title, forKey: "title")
            managedObject.setValue(diary.body, forKey: "body")
            managedObject.setValue(diary.createdAt, forKey: "createdAt")
            managedObject.setValue(diary.uuid, forKey: "uuid")
        }
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    // MARK: - READ
    func read() -> [Diary] {
        return fetchDiaryList()
    }

    private func fetchDiaryEntity() -> [DiaryEntity] {
        do {
            let request = DiaryEntity.fetchRequest()
            let results = try context.fetch(request)

            return results
        } catch {
            print(error.localizedDescription)
        }

        return []
    }

    private func fetchDiaryList() -> [Diary] {
        var diaryList: [Diary] = []
        let fetchResults = fetchDiaryEntity()
        for result in fetchResults {
            let diary = Diary(title: result.title ?? "",
                              body: result.body ?? "",
                              createdAt: result.createdAt ?? Date(),
                              uuid: result.uuid ?? UUID())
            diaryList.append(diary)
        }

        return diaryList
    }

    // MARK: - UPDATE
    func update(diary: Diary) {
        let fetchResults = fetchDiaryEntity()
        for result in fetchResults where result.uuid == diary.uuid {
            result.title = diary.title
            result.body = diary.body
        }
        saveContext()
    }

    // MARK: - DELETE
    func delete(diary: Diary) {
        let fetchResults = fetchDiaryEntity()
        let diaryEntity = fetchResults.filter({ $0.uuid == diary.uuid })[0]
        context.delete(diaryEntity)
        saveContext()
    }
}
