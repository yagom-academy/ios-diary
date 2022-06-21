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
    guard let diaryEntity = NSEntityDescription.entity(forEntityName: "DiaryModel", in: viewContext) else {
      return
    }
    
    guard let userModel = NSManagedObject(entity: diaryEntity, insertInto: viewContext) as? DiaryModel else {
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
      print(error)
    }
  }
  
  func readContext() -> [DiaryModel] {
    do {
      let diary = try viewContext.fetch(DiaryModel.fetchRequest())
      return diary
    } catch {
      fatalError("\(error)")
    }
  }
}
