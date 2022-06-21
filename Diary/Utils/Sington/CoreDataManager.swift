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
  
  func createContext(diary: Diary) {
    guard let diaryEntity = NSEntityDescription.entity(forEntityName: "Diary", in: viewContext) else {
      return
    }
    
    let userModel = NSManagedObject(entity: diaryEntity, insertInto: viewContext)
    
    userModel.setValue(diary.identifier, forKey: "identifier")
    userModel.setValue(diary.title, forKey: "title")
    userModel.setValue(diary.description, forKey: "description")
    userModel.setValue(diary.createdAt, forKey: "createdAt")

    guard viewContext.hasChanges else {
      return
    }
    do {
      try viewContext.save()
    } catch {
      print(error)
    }
  }
}
