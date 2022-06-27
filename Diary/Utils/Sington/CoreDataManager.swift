//
//  CoreDataManager.swift
//  Diary
//
//  Created by Taeangel, Quokka on 2022/06/21.
//

import CoreData

final class CoredataManager {
  static let shared = CoredataManager()
  
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
  
  func createContext(etityName: String) -> NSManagedObject? {
    guard let diaryEntity = NSEntityDescription.entity(forEntityName: etityName, in: viewContext) else {
      return nil
    }
    
    return NSManagedObject(entity: diaryEntity, insertInto: viewContext)
  }
  
  func readViewContext() -> NSManagedObjectContext {
    return viewContext
  }
}
