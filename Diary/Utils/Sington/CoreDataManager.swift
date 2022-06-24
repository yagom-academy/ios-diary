//
//  CoreDataManager.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/21.
//

import CoreData

final class CoredataManager {
  static let sherd = CoredataManager()
  
  private init() {}
  
  private lazy var persistantContainer: NSPersistentContainer = {
    let persistantContainer = NSPersistentContainer(name: "CoreDataModel")
    persistantContainer.loadPersistentStores { description, error in
      if let error = error {
        fatalError()
      }
    }
    return persistantContainer
  }()
  
  private var viewContext: NSManagedObjectContext {
    return persistantContainer.viewContext
  }
  
  func save() {
    guard viewContext.hasChanges else {
      return
    }
    do {
      try viewContext.save()
    } catch {
      fatalError("\(error)")
    }
  }
  
  func createContext(title: String, content: String, identifier: String, date: Date) {
    guard let diaryEntity = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext) else {
      return
    }
    
    guard let userModel = NSManagedObject(entity: diaryEntity, insertInto: viewContext) as? Diary else {
      return
    }
    userModel.title = title
    userModel.content = content
    userModel.createdDate = date
    userModel.identifier = identifier
    save()
  }
  
  func readContext() -> [Diary] {
    do {
      let diary = try viewContext.fetch(Diary.fetchRequest())
      return diary
    } catch {
      fatalError("\(error)")
    }
  }
  
  func updataContext(title: String, content: String, identifier: String, date: Date) {
    
    let request = Diary.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", identifier)
    
    if let diarys = try? viewContext.fetch(request).first {
      diarys.title = title
      diarys.createdDate = date
      diarys.content = content
    }
    save()
  }
  
  @discardableResult
  func deleteContext(identifier: String) -> [Diary] {
    let request = Diary.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", identifier)
    
    if let diary = try? viewContext.fetch(request).first {
      viewContext.delete(diary)
    }
    save()
    
    return readContext()
  }
}
