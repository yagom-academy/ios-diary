//
//  DiaryStorageManager.swift
//  Diary
//
//  Created by Minseong, Lingo on 2022/06/22.
//

import Foundation
import CoreData

final class DiaryStorageManager {
  private let persistentStorage = PersistentStorage(fileName: "Diary")

  func createDiary(text: String, weather: Weather?) {
    var separatedText = text.components(separatedBy: "\n")
    let title = separatedText.first
    separatedText.removeFirst()
    let body = separatedText.joined(separator: "\n")

    if let title = title, !title.isEmpty {
      let diaryEntity = DiaryEntity(context: self.persistentStorage.context)
      diaryEntity.setValue(title, forKey: "title")
      diaryEntity.setValue(body, forKey: "body")
      diaryEntity.setValue(Date().timeIntervalSince1970, forKey: "createdAt")
      diaryEntity.setValue(UUID().uuidString, forKey: "uuid")
      diaryEntity.setValue(weather?.main, forKey: "weatherMain")
      diaryEntity.setValue(weather?.icon, forKey: "weatherIcon")

      self.persistentStorage.saveContext()
      NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasSaved, object: nil)
    }
  }

  func fetchAllDiaries() -> [Diary] {
    guard let diaryEntities = try? self.persistentStorage.context.fetch(DiaryEntity.fetchRequest()) else { return [] }

    return diaryEntities.map { entity in
      return Diary(
        uuid: entity.uuid,
        title: entity.title,
        body: entity.body,
        createdAtTimeFrom1970: entity.createdAt,
        weatherIconID: entity.weatherIcon
      )
    }
  }

  func updateDiary(uuid: String, text: String) {
    let request = DiaryEntity.fetchRequest()
    request.predicate = NSPredicate(format: "uuid == %@", uuid)

    guard let entity = try? self.persistentStorage.context.fetch(request).first else { return }

    var separatedText = text.components(separatedBy: "\n")
    let title = separatedText.first
    separatedText.removeFirst()
    let body = separatedText.joined(separator: "\n")

    entity.title = title
    entity.body = body

    self.persistentStorage.saveContext()
    NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasSaved, object: nil)
  }

  func deleteDiary(uuid: String) {
    let request = DiaryEntity.fetchRequest()
    request.predicate = NSPredicate(format: "uuid == %@", uuid)

    guard let entity = try? self.persistentStorage.context.fetch(request).first else { return }

    self.persistentStorage.context.delete(entity)
    self.persistentStorage.saveContext()
    NotificationCenter.default.post(name: DiaryStorageNotification.diaryWasDeleted, object: nil)
  }

  func deleteAllDiaries() {
    guard let diaryEntities = try? self.persistentStorage.context.fetch(DiaryEntity.fetchRequest()) else { return }

    diaryEntities.forEach { entity in
      self.persistentStorage.context.delete(entity)
    }

    self.persistentStorage.saveContext()
  }
}
