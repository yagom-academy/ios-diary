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
    return self.persistentContainer.viewContext
  }

  private init() {}

  func saveContext () {
    if self.context.hasChanges {
      do {
        try self.context.save()
      } catch {
        print("PersistentManagerError - SaveContext: ", error)
      }
    }
  }

  func create(diary: Diary) {
    let diaryEntity = DiaryEntity(context: self.context)
    diaryEntity.setValue(diary.title, forKey: "title")
    diaryEntity.setValue(diary.body, forKey: "body")
    diaryEntity.setValue(diary.createdAt, forKey: "createdAt")
    diaryEntity.setValue(diary.uuid, forKey: "uuid")

    self.saveContext()
    NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasSaved, object: nil)
  }

  func fetchAllDiaries() -> [DiaryEntity] {
    guard let diaryEntities = try? context.fetch(DiaryEntity.fetchRequest()) else { return [] }
    return diaryEntities
  }

  func update() {
    self.saveContext()
    NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasSaved, object: nil)
  }

  func delete(diary: DiaryEntity) {
    self.context.delete(diary)
    self.saveContext()
  }

  func deleteAll() {
    guard let diaryEntities = try? self.context.fetch(DiaryEntity.fetchRequest()) else { return }

    diaryEntities.forEach { entity in
      self.context.delete(entity)
    }

    self.saveContext()
  }
}
