//
//  CoreDataManager.swift
//  Diary
//
//  Created by song on 2022/06/21.
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
  
  func createContext(title: String, contnet: String, identifier: String, date: Date) {
    guard let diaryEntity = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext) else {
      return
    }
    
    guard let userModel = NSManagedObject(entity: diaryEntity, insertInto: viewContext) as? Diary else {
      return
    }
    userModel.title = title
    userModel.content = contnet
    userModel.createdDate = date
    userModel.identifier = identifier
    
    guard viewContext.hasChanges else {
      return
    }
    
    do {
      try viewContext.save()
    } catch {
      fatalError("\(error)")
    }
  }
  
  func readContext() -> [Diary] {
    do {
      let diary = try viewContext.fetch(Diary.fetchRequest())
      return diary
    } catch {
      fatalError("\(error)")
    }
  }
  
  func updataContext(diary: Diary) {
    guard let identifier = diary.identifier else {
      return
    }
    
    let request = Diary.fetchRequest()
    request.predicate = NSPredicate(format: "identifier == %@", identifier)
    
    do {
      let diarys = try viewContext.fetch(request)
      diarys.forEach {
        $0.title = diary.title
        $0.createdDate = diary.createdDate
        $0.content = diary.content
      }
      
      guard viewContext.hasChanges else {
        return
      }
      
      try viewContext.save()
    } catch {
      fatalError("\(error)")
    }
  }
}
