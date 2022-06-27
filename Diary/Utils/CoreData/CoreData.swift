//
//  CoreData.swift
//  Diary
//
//  Created by LIMGAUI on 2022/06/27.
//

import Foundation

final class CoreData {
  static func createDiary(title: String, content: String, identifier: String, date: Date) {
    guard let diary = CoredataManager.shared.createContext(etityName: "Diary") as? Diary else {
      return
    }
    
    diary.title = title
    diary.content = content
    diary.identifier = identifier
    diary.createdDate = date
    
    CoredataManager.shared.save()
  }
  
  static func readDiary() -> [Diary] {
    let viewContext = CoredataManager.shared.readViewContext()
    do {
      let diary = try viewContext.fetch(Diary.fetchRequest())
      return diary
    } catch {
      fatalError("\(error)")
    }
  }
  
  static func updateDiary(title: String, date: Date, content: String, identifier: String) {
    let viewContext = CoredataManager.shared.readViewContext()
    
    let request = Diary.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", identifier)
    
    if let diarys = try? viewContext.fetch(request).first {
      diarys.title = title
      diarys.createdDate = date
      diarys.content = content
    }
    
    CoredataManager.shared.save()
  }
  
  static func deleteDiary(identifier: String) {
    let viewContext = CoredataManager.shared.readViewContext()
    
    let request = Diary.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", identifier)
    
    if let diary = try? viewContext.fetch(request).first {
      viewContext.delete(diary)
    }
    CoredataManager.shared.save()
  }
}
