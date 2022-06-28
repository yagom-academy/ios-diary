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

  func create(text: String) {
    var separatedText = text.components(separatedBy: "\n")
    let title = separatedText.first
    separatedText.removeFirst()
    let body = separatedText.joined(separator: "\n")

    if let title = title, !title.isEmpty {
      let diaryEntity = DiaryEntity(context: self.storage.context)
      diaryEntity.setValue(title, forKey: "title")
      diaryEntity.setValue(body, forKey: "body")
      diaryEntity.setValue(Date().timeIntervalSince1970, forKey: "createdAt")
      diaryEntity.setValue(UUID().uuidString, forKey: "uuid")

      self.storage.saveContext()
      NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasSaved, object: nil)
    }
  }

  func fetchAllDiaries() -> [Diary] {
    guard let diaryEntities = try? self.storage.context.fetch(DiaryEntity.fetchRequest()) else { return [] }

    return diaryEntities.map { entity in
      return Diary(
        uuid: entity.uuid,
        title: entity.title,
        body: entity.body,
        createdAt: entity.createdAt
      )
    }
  }

  func update(uuid: String, text: String) {
    let request = DiaryEntity.fetchRequest()
    request.predicate = NSPredicate(format: "uuid == %@", uuid)

    guard let entity = try? self.storage.context.fetch(request).first else { return }

    var separatedText = text.components(separatedBy: "\n")
    let title = separatedText.first
    separatedText.removeFirst()
    let body = separatedText.joined(separator: "\n")

    entity.title = title
    entity.body = body

    self.storage.saveContext()
    NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasSaved, object: nil)
  }

  func delete(uuid: String) {
    let request = DiaryEntity.fetchRequest()
    request.predicate = NSPredicate(format: "uuid == %@", uuid)

    guard let entity = try? self.storage.context.fetch(request).first else { return }

    self.storage.context.delete(entity)
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
