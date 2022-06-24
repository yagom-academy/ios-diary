//
//  DiaryStorageManager.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/22.
//

import Foundation
import CoreData

final class DiaryStorageManager {
  static let shared = DiaryStorageManager()

  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "Diary")
    container.loadPersistentStores { _, error in
      if let error = error {
        print("PersistentManagerError - LoadContainer: ", error)
      }
    }

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
        print("PersistentManagerError - SaveContext: ", error)
      }
    }
  }

  func create(diary: Diary) {
    let diaryEntity = DiaryEntity(context: context)
    diaryEntity.setValue(diary.title, forKey: "title")
    diaryEntity.setValue(diary.body, forKey: "body")
    diaryEntity.setValue(diary.createdAt, forKey: "createdAt")
    diaryEntity.setValue(diary.uuid, forKey: "uuid")

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

    self.saveContext()
  }

  func delete(diary: Diary) {
    guard let diaryEntities = try? context.fetch(DiaryEntity.fetchRequest()) else { return }
    guard let diaryEntity = diaryEntities.first(where: { $0.uuid == diary.uuid }) else { return }

    self.context.delete(diaryEntity)

    self.saveContext()
  }

  func deleteAll() {
    guard let diaryEntities = try? context.fetch(DiaryEntity.fetchRequest()) else { return }

    diaryEntities.forEach { entity in
      self.context.delete(entity)
    }

    self.saveContext()
  }
}
