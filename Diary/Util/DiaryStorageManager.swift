//
//  DiaryStorageManager.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/22.
//

import Foundation
import CoreData

final class DiaryStorageManager {
  private let storage = PersistentStore(fileName: "Diary")

  func create(diary: Diary) {
    let diaryEntity = DiaryEntity(context: self.storage.context)
    diaryEntity.setValue(diary.title, forKey: "title")
    diaryEntity.setValue(diary.body, forKey: "body")
    diaryEntity.setValue(diary.createdAt, forKey: "createdAt")
    diaryEntity.setValue(diary.uuid, forKey: "uuid")

    self.storage.saveContext()
    NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasSaved, object: nil)
  }

  func fetchAllDiaries() -> [DiaryEntity] {
    guard let diaryEntities = try? self.storage.context.fetch(DiaryEntity.fetchRequest()) else { return [] }
    return diaryEntities
  }

  func update() {
    self.storage.saveContext()
    NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasSaved, object: nil)
  }

  func delete(diary: DiaryEntity) {
    self.storage.context.delete(diary)
    self.storage.saveContext()
    NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasDeleted, object: nil)
  }

  func deleteAll() {
    guard let diaryEntities = try? self.storage.context.fetch(DiaryEntity.fetchRequest()) else { return }

    diaryEntities.forEach { entity in
      self.storage.context.delete(entity)
    }

    self.storage.saveContext()
  }
}
