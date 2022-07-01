//
//  CoreData.swift
//  Diary
//
//  Created by LIMGAUI on 2022/06/27.
//

import Foundation

final class DiaryData {
  static func create(title: String, content: String, identifier: String, date: Date, main: String, iconID: String) {
    guard let diary = CoredataManager.shared.createContext(etityName: "Diary") as? Diary else {
      return
    }
    
    diary.title = title
    diary.content = content
    diary.identifier = identifier
    diary.createdDate = date
    diary.main = main
    diary.iconID = iconID
    
    CoredataManager.shared.save()
  }
  
  static func read() -> [Diary] {
    let viewContext = CoredataManager.shared.readViewContext()
    do {
      let diary = try viewContext.fetch(Diary.fetchRequest())
      return diary
    } catch {
      fatalError("\(error)")
    }
  }
  
  static func update(title: String, date: Date, content: String, identifier: String) {
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
  
  static func delete(identifier: String) {
    let viewContext = CoredataManager.shared.readViewContext()
    
    let request = Diary.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", identifier)
    
    if let diary = try? viewContext.fetch(request).first {
      viewContext.delete(diary)
    }
    
    CoredataManager.shared.save()
  }
}
