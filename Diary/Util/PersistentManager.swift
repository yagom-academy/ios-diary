//
//  PersistentManager.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/22.
//

import Foundation
import CoreData

final class PersistentManager {
  static let shared = PersistentManager()

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Diary")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  private var context: NSManagedObjectContext {
    return persistentContainer.viewContext
  }

  private init() {}

  func saveContext () {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

  func create(diary: Diary) {
    let diaryEntity = DiaryEntity(context: context)
    diaryEntity.setValue(diary.title, forKey: "title")
    diaryEntity.setValue(diary.body, forKey: "body")
    diaryEntity.setValue(diary.createdAt, forKey: "createdAt")

    self.saveContext()
  }

  func fetchAll() -> [Diary] {
    guard let diaryEntities = try? context.fetch(DiaryEntity.fetchRequest()) else { return [] }

    let diaries = diaryEntities.map {
      Diary(title: $0.title ?? "", body: $0.body ?? "", createdAt: $0.createdAt)
    }

    return diaries
  }

  func update(diary: Diary) {
    guard let diaryEntities = try? context.fetch(DiaryEntity.fetchRequest()) else { return }
    guard let diaryEntity = diaryEntities.first(where: { $0.uuid == diary.uuid }) else { return }

    diaryEntity.setValue(diary.title, forKey: "title")
    diaryEntity.setValue(diary.body, forKey: "body")
    diaryEntity.setValue(diary.createdAt, forKey: "createdAt")

    self.saveContext()
  }

  func delete(diary: Diary) {
    guard let diaryEntities = try? context.fetch(DiaryEntity.fetchRequest()) else { return }
    guard let diaryEntity = diaryEntities.first(where: { $0.uuid == diary.uuid }) else { return }

    context.delete(diaryEntity)

    self.saveContext()
  }
}
